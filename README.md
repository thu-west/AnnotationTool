# 基于主动学习的标注系统
本系统最初的开发目的是用于医疗健康电子病历中非结构化数据（例如“现病史”和“既往史”）的实体标注和关系标注。我们应用了主动学习技术来提高标注的效率。本系统也可以用于医疗指南的标注以及非医疗健康方面的非结构化数据的标注。

****
## 目录
* [开发记录](#开发记录)
* [系统功能和演示](#系统功能和演示)
* [部署指令](#部署指令)
* [常见问题](#常见问题)
* [联系方式](#联系方式)

## 开发记录

## 系统功能和演示

## 部署指令

以下命令为新版标注系统的部署指令，并在Ubuntu 18.04上通过了测试。

1. 安装docker和docker-compose

```sh
sudo apt update
sudo apt install docker.io docker-compose
```

2. 构建镜像

```sh
cd annotationTool2
./scripts.sh build
```

3. 编译代码

```sh
cd annotationTool2
./scripts.sh compile
```

4. 启动网站

```sh
cd annotationTool2
./scripts.sh start
```

5. *关闭

```sh
cd annotationTool2
./scripts.sh stop
```

## 常见问题
* "主动学习"是如何体现的?
* 如何标注"一对多"和"多对一"关系?
* 如何标注同义词?
* 标注结果的输出格式是什么?

## 联系方式

新版标注工具维护人员联系方式：believe.chenyu@gmail.com
