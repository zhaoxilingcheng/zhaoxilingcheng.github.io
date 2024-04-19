---
layout: post
title: 最简单的个人博客搭建
date: 2021-9-02
categories: blog
tags: [博客]
description: 无。
---

## 心路历程
> 之前的aliyun服务器已经过期， 博客没了， 重新购入了腾讯云， 本想延续上个内容继续使用hexo搭建一个个人博客， 转念一想， 不如直接使用github pages搭建一个个人博客得了，说干就干。

## 搭建过程
1. fork https://github.com/cnfeat/blog.io
2. 改仓库名为 {username}.github.io, ex: zhaoxilingcheng.github.io
3. 进入settings > pages 选择source为master分支 点击save
4. 打开 {username}.github.io, 完成了个人博客的搭建
5. 修改 _config.yml 文件内容为个人内容
6. 编辑 404.md 文件， 这里使用腾讯公益404
```
<script type="text/javascript" src="//qzonestyle.gtimg.cn/qzone/hybrid/app/404/search_children.js" charset="utf-8" homePageUrl="#https://lostmylife.top#" homePageName="回到主页"></script>
```
## 域名配置
1. 配置dns解析 解析 www与@ 地址为
```
185.199.110.153
```
2. settings > pages  填写 Custom domain 为你的域名， 点击保存  ex: lostmylife.top
3. 开启 Enforce HTTPS

## 编写文章
1. 在_posts目录 添加md文件 格式为 年-月-日-标题.md
2. 增加markdown的表格内容
```markdown
---
layout: post
title: 文章标题
date: 2021-9-02
categories: blog
tags: [tag]
description: 简要描述。
---
```
3. 使用markdown语法进行编写
4. git提交文件







