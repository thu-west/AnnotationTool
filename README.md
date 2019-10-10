# 标注系统

## 部署指令

以下命令在Ubuntu 18.04上通过了测试。

1. 安装docker和docker-compose

```sh
sudo apt update
sudo apt install docker.io docker-compose
```

2. 构建镜像

```sh
./scripts.sh build
```

3. 导入数据库结构

```sh
./importdb.sh kg_structure.sql
```

4. 编译代码

```sh
./scripts.sh compile
```

5. 启动网站

```sh
./scripts.sh start
```

6. *关闭

```sh
./scripts.sh stop
```
