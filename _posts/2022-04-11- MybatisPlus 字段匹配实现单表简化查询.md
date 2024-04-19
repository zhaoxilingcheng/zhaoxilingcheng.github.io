---
layout: post
title: MybatisPlus 字段匹配实现单表简化查询
date: 2022-4-11
categories: java
tags: [java,orm]
description: 无。
---

### MybatisPlus 字段匹配实现单表简化查询

1. MatchStrategyInterface.class 匹配的接口

```java
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;

import java.lang.reflect.Field;

/**
 * MybatisPlus 匹配原则
 * @author L
 */
public interface MatchStrategyInterface {

    /**
     * 是否匹配
     * @param queryField
     * @param doField
     * @return
     */
    boolean match(Field queryField, Field doField);

    /**
     * 进行填充queryWrapper
     * @param queryWrapper
     * @param doFieldColumn DO字段对应的column值
     * @param queryFieldValue
     * @param <R> DO的泛型
     */
    <R> void fillWrapper(QueryWrapper<R> queryWrapper, String doFieldColumn, Object queryFieldValue);
}

```

2. 通用匹配实现

```java
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;

import java.lang.reflect.Field;
import java.util.Collection;
import java.util.Objects;

/**
 * 基础的转换策略提取
 *
 * @author L
 */
public abstract class BaseMatchStrategy implements MatchStrategyInterface {

    @Override
    public boolean match(Field queryField, Field doField) {
        String queryFieldName = queryField.getName();
        String doFieldName = doField.getName();
        if (Objects.equals(queryFieldName, doFieldName)) {
            return false;
        }
        return match(queryFieldName, doFieldName);
    }

    /**
     * field to String
     *
     * @param queryFieldName
     * @param doFieldName
     * @return
     */
    protected abstract boolean match(String queryFieldName, String doFieldName);

    @Override
    public <R> void fillWrapper(QueryWrapper<R> queryWrapper, String doFieldColumn, Object queryFieldValue) {
        if (Objects.isNull(queryFieldValue)) {
            return;
        }
        if(queryFieldValue instanceof String && queryFieldValue.toString().trim().length() == 0) {
            return;
        }
        if(queryFieldValue instanceof Collection && ((Collection<?>)queryFieldValue).size() == 0) {
            return;
        }
        this.fillWrapperNotEmpty(queryWrapper, doFieldColumn, queryFieldValue);
    }

    /**
     * queryFieldValue不为 empty 进行填充 queryWrapper
     * @param queryWrapper
     * @param doFieldColumn
     * @param queryFieldValue
     * @param <R>
     */
    protected abstract <R> void fillWrapperNotEmpty(QueryWrapper<R> queryWrapper, String doFieldColumn, Object queryFieldValue);

}

```

3. 集合匹配实现

```java

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;

import java.util.Collection;

/**
 * 集合基础
 * @author L
 */
public abstract class BaseCollectionMatchStrategy extends BaseMatchStrategy {

    @Override
    protected <R> void fillWrapperNotEmpty(QueryWrapper<R> queryWrapper, String doFieldColumn, Object queryFieldValue) {
        if(!(queryFieldValue instanceof Collection)) {
            return;
        }
        this.fillWrapperWithCollection(queryWrapper, doFieldColumn, (Collection<?>) queryFieldValue);
    }

    /**
     * collection 不为空 进行填充 queryWrapper
     * @param queryWrapper
     * @param doFieldColumn
     * @param collection
     * @param <R>
     */
    protected abstract <R> void fillWrapperWithCollection(QueryWrapper<R> queryWrapper, String doFieldColumn, Collection<?> collection);
}
```

4. in collection

```java
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.Objects;

/**
 * in Collection
 * @author L
 */
@Component
public class InListMatchStrategy extends BaseCollectionMatchStrategy {

    private static final String SUFFIX = "List";

    @Override
    protected <R> void fillWrapperWithCollection(QueryWrapper<R> queryWrapper, String doFieldColumn, Collection<?> collection) {
        queryWrapper.in(doFieldColumn, collection);
    }

    @Override
    protected boolean match(String queryFieldName, String doFieldName) {
        if(Objects.equals(queryFieldName, doFieldName + SUFFIX)) {
            return Boolean.TRUE;
        }
        return false;
    }
}

```

5. QueryWrapperFillUtils.class 工具类

```java

import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.LambdaUtils;
import com.baomidou.mybatisplus.core.toolkit.support.ColumnCache;
import com.xxx.SpringContextUtils;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.lang.reflect.Field;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.stream.Collectors;


/**
 * @author L
 */
@Component
public class QueryWrapperFillUtils {

    @Autowired
    private List<MatchStrategyInterface> matchStrategyInterfaceList;

    /**
     * 内部能匹配上述策略的Field列表
     */
    private final static ConcurrentMap<Class<?>, List<MatchInfo>> MATCH_MAP = new ConcurrentHashMap<>();

    public static QueryWrapperFillUtils getInstance(){
        return SpringContextUtils.getBean(QueryWrapperFillUtils.class);
    }

    /**
     * buildAndFillQueryWrapper
     * @param query
     * @param entityDO
     * @param <R>
     * @return
     */
    public <R> QueryWrapper<R> buildAndFillQueryWrapper(Object query, R entityDO) {
        QueryWrapper<R> queryWrapper = new QueryWrapper<>(entityDO);
        return this.fillQueryWrapper(queryWrapper, query, entityDO);
    }

    /**
     * 将查询对象装换为QueryWrapper
     * 按照策略的不同进行不同的转换
     *
     * @param query
     * @return
     */
    public <R> QueryWrapper<R> fillQueryWrapper(QueryWrapper<R> queryWrapper, Object query, R entityDO) {
        List<MatchInfo> optionalMatchInfoList = getMatchInfos(query, entityDO);
        for (MatchInfo matchInfo : optionalMatchInfoList) {
            try {
                Object queryFieldValue = matchInfo.queryField.get(query);
                matchInfo.getMatchStrategyInterface().fillWrapper(queryWrapper, matchInfo.getDoFieldColumn(), queryFieldValue);
            } catch (IllegalAccessException ignored) {
            }
        }
        return queryWrapper;
    }


    /**
     * 获取 MatchInfo列表
     *
     * @param query
     * @param entityDO
     * @param <R>
     * @return
     */
    private <R> List<MatchInfo> getMatchInfos(Object query, R entityDO) {
        List<MatchInfo> optionalMatchInfoList = MATCH_MAP.get(query.getClass());
        if (Objects.isNull(optionalMatchInfoList)) {
            // 加锁避免重复匹配
            synchronized (query.getClass().getName()) {
                optionalMatchInfoList = MATCH_MAP.get(query.getClass());
                if (Objects.nonNull(optionalMatchInfoList)) {
                    return optionalMatchInfoList;
                }
                optionalMatchInfoList = new LinkedList<>();
                Field[] queryFields = query.getClass().getDeclaredFields();
                Field[] doFields = entityDO.getClass().getDeclaredFields();
                Map<String, Field> queryFieldMap = Arrays.stream(queryFields).collect(Collectors.toMap(Field::getName, i -> i));
                Map<String, Field> doFieldMap = Arrays.stream(doFields).collect(Collectors.toMap(Field::getName, i -> i));
                List<Field> fields = new LinkedList<>();
                queryFieldMap.forEach((k,v)->{
                    Field field = doFieldMap.get(k);
                    if(Objects.isNull(field)) {
                        fields.add(v);
                    }
                });
                for (Field queryField : fields) {
                    for (Field doField : doFields) {
                        for (MatchStrategyInterface matchStrategyInterface : matchStrategyInterfaceList) {
                            boolean match = matchStrategyInterface.match(queryField, doField);
                            if (match) {
                                Map<String, ColumnCache> columnMap = LambdaUtils.getColumnMap(entityDO.getClass());
                                ColumnCache columnCache = columnMap.get(LambdaUtils.formatKey(doField.getName()));
                                String column = columnCache.getColumn();
                                queryField.setAccessible(Boolean.TRUE);
                                MatchInfo matchInfo = new MatchInfo(queryField, doField, column, matchStrategyInterface);
                                optionalMatchInfoList.add(matchInfo);
                                break;
                            }
                        }
                    }
                }
                MATCH_MAP.putIfAbsent(query.getClass(), optionalMatchInfoList);
            }
        }
        return optionalMatchInfoList;
    }

    @Data
    @AllArgsConstructor
    private static class MatchInfo {

        private Field queryField;

        private Field doField;

        /**
         * DO类匹配的field对象对应的column 字符
         */
        private String doFieldColumn;

        private MatchStrategyInterface matchStrategyInterface;
    }

}

```

### 使用
在query 对象中建立满足对应匹配规则的字段名，则可实现对应策略的wrapper填充  
ex： DO.code  
query.codeList  
采用QueryWrapperFillUtils.getInstance().buildAndFillQueryWrapper(query, DO); 得到wrapper。  
单表不只需要设计特定的规则，就不需要自己拼装啦。  