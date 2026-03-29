# Docker 基本原理与使用

## 1. 基本使用

- `docker image pull`：拉取镜像到本地；
- `docker image ls`：列出本地镜像；
- `docker container run`：从 image 文件生成一个正在运行的容器实例；
- `docker container ls`：列出正在运行的容器；
- `docker container kill`：终止容器；
- `docker container start <container_id>`：启动已经生成的、停止运行的容器；
- `docker container exec -it <container_id> bash`：进入一个正在运行的容器，并且使用 bash 进行交互；
