---
layout: post
title: 巧用jackson ObjectMapper实现字典翻译
date: 2022-4-18
categories: java
tags: [java, mvc]
description: 无。
---

### 巧用jackson ObjectMapper实现字典翻译
思路：
#### 设计两个注解  TranslateDescription（翻译的注解）
TranslateResponseBody (用于切ResponseBody的注解)

```java 
/**
 * @author L
 */
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.FIELD})
public @interface TranslateDescription {

    /**
     * 翻译的class
     *
     * @return
     */
    Class<? extends BaseTranslate<Object>> value();

}


/**
 * @author L
 */
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.METHOD})
@ResponseBody
public @interface TranslateResponseBody {

}

```
#### 设计两个 BeanSerializerModifier
1. PutTranslateKeySerializer
```java  
/**
 * 将需要翻译的值写入set中序列化工具
 * @author L
 */
public class PutTranslateKeySerializer extends BeanSerializerModifier {

    @Override
    public List<BeanPropertyWriter> changeProperties(SerializationConfig config, BeanDescription beanDesc, List<BeanPropertyWriter> beanProperties) {
        for (BeanPropertyWriter beanProperty : beanProperties) {
            TranslateDescription translateDescription = beanProperty.getAnnotation(TranslateDescription.class);
            if (translateDescription != null) {
                //自定以序列器
                beanProperty.assignSerializer(new JsonSerializer<Object>() {
                    @Override
                    public void serialize(Object value, JsonGenerator gen, SerializerProvider serializers) throws IOException {
                        Class<? extends BaseTranslate<Object>> clazz = translateDescription.value();
                        BaseTranslate<Object> bean = SpringContextUtils.getBean(clazz);
                        bean.putInSet(value);
                        gen.writeString(value.toString());
                    }
                });
            }
        }
        return beanProperties;
    }
}
```
2 TranslateSerializer
```java  
/**
 * 翻译序列化工具
 *
 * @author L
 */
public class TranslateSerializer extends BeanSerializerModifier {


    public static final String TRANSLATE_LAST = "String";

    @Override
    public List<BeanPropertyWriter> changeProperties(SerializationConfig config, BeanDescription beanDesc, List<BeanPropertyWriter> beanProperties) {
        for (BeanPropertyWriter beanProperty : beanProperties) {
            TranslateDescription translateDescription = beanProperty.getAnnotation(TranslateDescription.class);
            String name = beanProperty.getName();
            if (translateDescription != null) {
                //自定以序列器
                beanProperty.assignSerializer(new JsonSerializer<Object>() {
                    @Override
                    public void serialize(Object value, JsonGenerator gen, SerializerProvider serializers) throws IOException {
                        gen.writeString(value.toString());
                        Class<? extends BaseTranslate<?>> clazz = translateDescription.value();
                        BaseTranslate<?> bean = SpringContextUtils.getBean(clazz);
                        Map<?, String> resultMap = bean.getResultMap();
                        String parse = resultMap.get(value);
                        // 增加一个字段为 原字段+String
                        gen.writeStringField(name + TRANSLATE_LAST, parse);
                    }
                });
            }
        }
        return beanProperties;
    }
}
```

#### TranslateLocal 翻译的ThreadLocal简单实现

```java
/**
 * @author L
 */
public class TranslateLocal {

    private static final ThreadLocal<Map<Object, Object>> TRANSLATE_LOCAL = ThreadLocal.withInitial(HashMap::new);

    public static void clear() {
        Map<Object, Object> objectObjectMap = TRANSLATE_LOCAL.get();
        objectObjectMap.clear();
    }

    public static void put(Object key, Object value) {
        Map<Object, Object> map = TRANSLATE_LOCAL.get();
        map.put(key, value);
    }

    public static Object get(Object key) {
        Map<Object, Object> map = TRANSLATE_LOCAL.get();
        return map.get(key);
    }

}

```

#### BaseTranslate
此类是翻译的基类，内部功能为，将key存储在Set中实现批量查询。

```java  
/**
 * 基础翻译类
 * @author L
 */
@Slf4j
public abstract class BaseTranslate<T> {

    /**
     * 获取翻译结果集
     * @return
     */
    public Map<Object, String> getResultMap() {
        Object valueObject = TranslateLocal.get(this.getClass().getSimpleName() + "Map");
        if(Objects.isNull(valueObject)){
            Map<Object, String> map = Collections.emptyMap();
            try{
                map = parseResult(getSet());
            } catch (Exception e) {
                log.info("获取解析发生异常", e);
            }
            if(Objects.isNull(map)) {
                map = Collections.emptyMap();
            }
            TranslateLocal.put(this.getClass().getSimpleName() + "Map", map);
            return map;
        }
        return (Map<Object, String>) valueObject;
    }

    /**
     * 解析结果
     * @param set
     */
    protected abstract Map<Object, String> parseResult(Set<T> set);

    /**
     * 将数据放入set中
     * @param k
     * @return
     */
    protected Set<T> putInSet(T k) {
        Set<T> set = getSet();
        set.add(k);
        return set;
    }

    /**
     * 获取set
     * @return
     */
    protected Set<T> getSet() {
        Object valueObject = TranslateLocal.get(this.getClass().getSimpleName() + "Set");
        Set<T> set = Objects.isNull(valueObject) ? new HashSet<>() : (Set<T>) valueObject;
        TranslateLocal.put(this.getClass().getSimpleName() + "Set", set);
        return set;
    }

    /**
     * clearMap
     */
    public void clear() {
        TranslateLocal.put(this.getClass().getSimpleName() + "Map", null);
        TranslateLocal.put(this.getClass().getSimpleName() + "Set", null);
    }

}
```

#### 实现ResponseBody切面 ResponseBodyAdvice

```java  
/**
 * @author L
 */
@ControllerAdvice
@Slf4j
public class CustomReturnJsonAdvice implements ResponseBodyAdvice<Object> {
    public final static ObjectMapper PUT_SET_OBJECT_MAPPER;
    public final static ObjectMapper OBJECT_MAPPER;
    static{
        OBJECT_MAPPER = new ObjectMapper();
        OBJECT_MAPPER.setSerializerFactory(OBJECT_MAPPER.getSerializerFactory().withSerializerModifier(new TranslateSerializer()));
        OBJECT_MAPPER.setDateFormat(new SimpleDateFormat(DEFAULT_DATE_TIME_FORMAT));

        PUT_SET_OBJECT_MAPPER = new ObjectMapper();
        PUT_SET_OBJECT_MAPPER.setSerializerFactory(PUT_SET_OBJECT_MAPPER.getSerializerFactory().withSerializerModifier(new PutTranslateKeySerializer()));
    }

    @Override
    public boolean supports(MethodParameter returnType, Class<? extends HttpMessageConverter<?>> converterType) {
        return returnType.hasMethodAnnotation(TranslateResponseBody.class);
    }

    @Override
    public Object beforeBodyWrite(Object body, MethodParameter returnType, MediaType selectedContentType, Class<? extends HttpMessageConverter<?>> selectedConverterType, ServerHttpRequest request, ServerHttpResponse response) {
        if (Objects.isNull(body)) {
            return null;
        }
        try {
            // 1. 先将要编译的数据写入threadLocal中
            PUT_SET_OBJECT_MAPPER.writeValueAsString(body);
            // 进行翻译
            String s = OBJECT_MAPPER.writeValueAsString(body);
            Object parse = JSON.parse(s);
            return parse;
        } catch (Exception e) {
            log.error("解析json发生异常,error=", e);
            return body;
        } finally {
            TranslateLocal.clear();
        }
    }
}
```
### 使用
在Vo的字段上加@TranslateDescription注解，在controller方法上加@TranslateResponseBody