# annotation_tool2

> A Vue.js project

## Build Setup

``` bash
# install dependencies
npm install

# serve with hot reload at localhost:8080
npm run dev

# build for production with minification
npm run build

# build for production and view the bundle analyzer report
npm run build --report
```

For a detailed explanation on how things work, check out the [guide](http://vuejs-templates.github.io/webpack/) and [docs for vue-loader](http://vuejs.github.io/vue-loader).

## 备忘

O是保留符号

标注时可以选择是否显示机器的标注结果

信心是一个非负实数，越小代表信心越低，会更优先标注。

[TODO]支持多人同时标注

Active Learning
TODO: 论文


## 文件夹说明

* annotationTool 原来的标注工具
* annotationTool2 主动学习NER标注工具
* machine 主动学习的机器客户端


X -> 一对多_和 主关系
一对多_和 -> A, B, C has_a


* 实体类型: 实体 is_an_instance_of 实体标签
* 一对一: 实体1 关系 实体2
* 一对多_和, 一对多_或,一对多_一: 实体1 关系 虚拟节点, 虚拟节点 has_a 实体2
* 多对一_和 多对一_或 多对一_一: 实体1 is_a 虚拟节点, 虚拟节点 关系 实体2


TODO

1. 管理界面分离，支持修改分栏
2. 自动关系生成
3. 原文显示实体原文
ftap
