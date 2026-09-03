# docerk指令

## 镜像
| 特性          | 镜像（Image）           | 容器（Container）                   |
|--------------|------------------------|-------------------------------------|
| **定义**     | 运行容器的模板         | 镜像的运行实例                     |
| **是否可修改** | 只读                   | 运行时可读写                       |
| **是否有进程** | 无                     | 运行时是一个进程                   |
| **是否可存储数据** | 存储的是软件环境，不存数据 | 可存储数据，但如果删除，数据会丢失（除非挂载卷） |
| **生命周期** | 持久化，构建后不会丢失  | 临时，如果 `docker rm`，则会被删除  |
| **是否可以有多个实例** | 一份镜像可启动多个容器 | 每个容器都是独立的                 |

## 详细查看镜像信息

- docker inspect nvcr.io/nvidian/bundlesdf，它会返回该镜像的完整元数据，包括环境变量、挂载点、层结构等。

- 查看正在运行的容器：`docker ps`
- 查看所有容器（包括已停止的）`docker ps -a`
- 进入正在运行的容器`docker exec -it bundlesdf bash`
- 如果容器已经停止，你需要先启动它`docker start bundlesdf, docker exec -it bundlesdf bash`
- 查看容器的日志：`docker logs bundlesdf`,如果日志较长，你可以用 -f 选项实时查看,`docker logs -f bundlesdf`
- 停止、启动和删除容器`docker stop bundlesdf`,`docker start bundlesdf`，如果你想 删除容器（必须先停止），`docker rm bundlesdf`
- 删除镜像前，必须先删除所有基于它的容器，否则 Docker 会报错。`docker rmi nvcr.io/nvidian/bundlesdf`
- 退出容器 `exit`,或者按 Ctrl+D 就会退出当前 shell，容器也会随之停止（因为你用的是 --rm 选项）。
- 如果你想保留容器运行，只想临时脱离，可以按下,`Ctrl+P  Ctrl+Q`，这样会把你从容器 shell 分离出来，容器继续在后台运行。

## docker容器使用

- 直接输入`docker`，可以查看docker客户端的所有命令选项
-  常用指令
    | 命令                     | 功能                                   | 示例                                  |
    |--------------------------|----------------------------------------|---------------------------------------|
    | `docker run`             | 启动一个新的容器并运行命令            | `docker run -d ubuntu`               |
    | `docker ps`              | 列出当前正在运行的容器                | `docker ps`                           |
    | `docker ps -a`           | 列出所有容器（包括已停止的容器）      | `docker ps -a`                        |
    | `docker build`           | 使用 Dockerfile 构建镜像              | `docker build -t my-image .`         |
    | `docker images`          | 列出本地存储的所有镜像                | `docker images`                       |
    | `docker pull`            | 从 Docker 仓库拉取镜像                | `docker pull ubuntu`                  |
    | `docker push`            | 将镜像推送到 Docker 仓库              | `docker push my-image`                |
    | `docker exec`            | 在运行的容器中执行命令                | `docker exec -it container_name bash` |
    | `docker stop`            | 停止一个或多个容器                    | `docker stop container_name`          |
    | `docker start`           | 启动已停止的容器                      | `docker start container_name`         |
    | `docker restart`         | 重启一个容器                          | `docker restart container_name`       |
    | `docker rm`              | 删除一个或多个容器                    | `docker rm container_name`            |
    | `docker rmi`             | 删除一个或多个镜像                    | `docker rmi my-image`                 |
    | `docker logs`            | 查看容器的日志                        | `docker logs container_name`          |
    | `docker inspect`         | 获取容器或镜像的详细信息              | `docker inspect container_name`       |
    | `docker exec -it`        | 进入容器的交互式终端                  | `docker exec -it container_name /bin/bash` |
    | `docker network ls`      | 列出所有 Docker 网络                  | `docker network ls`                   |
    | `docker volume ls`       | 列出所有 Docker 卷                    | `docker volume ls`                    |
    | `docker-compose up`      | 启动多容器应用（从 docker-compose.yml 文件） | `docker-compose up`                   |
    | `docker-compose down`    | 停止并删除由 docker-compose 启动的容器、网络等 | `docker-compose down`                 |
    | `docker info`            | 显示 Docker 系统的详细信息            | `docker info`                         |
    | `docker version`         | 显示 Docker 客户端和守护进程的版本信息 | `docker version`                      |
    | `docker stats`           | 显示容器的实时资源使用情况            | `docker stats`                        |
    | `docker login`           | 登录 Docker 仓库                      | `docker login`                        |
    | `docker logout`          | 登出 Docker 仓库                      | `docker logout`                       |

- 常用选项说明:

    -d（--detach）：后台运行容器（不占用你当前终端），例如 docker run -d ubuntu。
    -it（--interactive，--tty）：以交互式终端运行容器，保持标准输入打开（允许你交互），分配一个伪终端（给你一个看得见的 shell）例如 docker exec -it container_name bash。
    -t（--tag）：为镜像指定标签，例如 docker build -t my-image .。
- 启动容器
    ```te
    docker run -itd \
    --name your_container_name \              # 给容器起个名字，方便管理
    -v /your/host/path:/container/path \      # 映射主机目录（可选）
    -p 8080:80 \                               # 映射端口（可选：主机:容器）
    --gpus all \                               # 使用 GPU（可选，需支持）
    --network host \                           # 网络配置（可选）
    --restart unless-stopped \                # 重启策略（可选）
    IMAGE_NAME:TAG \                           # 镜像名和标签（例如 ubuntu:20.04）
    COMMAND                                    # 容器启动后执行的命令（如 bash）
    ```

    在 Docker 中，一旦容器被创建并运行后，无法直接修改已运行容器的名称。如果你第一次启动容器时没有使用 --name 参数，Docker 会随机为该容器分配一个名称。

    | 参数                     | 全称                      | 功能                                      |
    |--------------------------|---------------------------|-------------------------------------------|
    | `-i`                     | `--interactive`           | 保持标准输入流打开（交互）                |
    | `-t`                     | `--tty`                   | 分配伪终端（让你能看到 shell）            |
    | `-d`                     | `--detach`                | 后台运行                                  |
    | `--name`                 | —                         | 容器命名                                  |
    | `-v`                     | `--volume`                | 目录挂载（持久化数据）                    |
    | `-p`                     | `--publish`               | 端口映射（主机:容器）                     |
    | `--gpus all`            | —                         | 启用 GPU（需 NVIDIA 容器运行时）         |
    | `--network host`        | —                         | 使用主机网络                              |
    | `--restart`             | —                         | 容器崩溃后自动重启                        |

- 当`docker run -itd --name my_ubuntu ubuntu:20.04 bash`，想进入后台容器怎么办，`docker exec -it my_ubuntu bash`，想删除容器和镜像，`docker stop my_ubuntu
,docker rm my_ubuntu,docker rmi ubuntu:20.04`
- 几种常用进入容器的方法
    | 场景                     | 命令                                       |
    |--------------------------|--------------------------------------------|
    | 运行新容器并进入        | `docker run -it ubuntu:20.04 bash`        |
    | 启动已退出的容器并进入  | `docker start -ai container_name`         |
    | 进入正在运行的容器      | `docker exec -it container_name bash`     |

    docker start 后面不能加额外参数（比如 bash），它只接受容器名字或 ID

- 导出和导入容器

    如果要导出本地某个容器，可以使用 docker export 命令：`docker export [OPTIONS] CONTAINER > file.tar`,如：`docker export my_container > my_container_backup.tar`,或者使用 -o 参数:`docker export -o my_container_backup.tar my_container`,my_container 是容器的名字或 ID,my_container_backup.tar 是导出的 tar 包（包含整个容器文件系统）

    导入容器（docker import）,注意：docker import 是导入成镜像（不是直接还原为容器）,`docker import file.tar [REPOSITORY[:TAG]]`,如:`docker import file.tar [REPOSITORY[:TAG]]`

    保存镜像为 .tar 文件（docker save），`docker save -o <保存的文件名>.tar <镜像名>:<标签>`,如:`docker save -o ubuntu20.04.tar ubuntu:20.04`,加载 .tar 文件为镜像（docker load）,`docker load -i <镜像文件>.tar`,如：`docker load -i ubuntu20.04.tar`,若加载成功后，可以用：`docker images`,看到这个镜像已经恢复，可直接运行`docker run -it ubuntu:20.04`，

    | 比较项                  | `save/load`           | `export/import`          |
    |-------------------------|-----------------------|--------------------------|
    | 操作对象                | 镜像                  | 容器                     |
    | 保留镜像层/历史        | ✅ 是                 | ❌ 否                    |
    | 是否可变成镜像          | ✅ 本身就是            | ✅ 会变成镜像            |
    | 常用于                  | 镜像传输、分享        | 容器打包（运行环境）    |

## docker镜像使用

- 常用命令
    | 命令                     | 作用                            | 示例                                |
    |--------------------------|---------------------------------|-------------------------------------|
    | `docker images`          | 查看本地所有镜像               | `docker images`                     |
    | `docker pull`            | 从远程仓库拉取镜像             | `docker pull ubuntu:20.04`         |
    | `docker build`           | 基于 Dockerfile 构建镜像       | `docker build -t myimage:v1 .`     |
    | `docker tag`             | 给镜像打标签                   | `docker tag ubuntu:20.04 myrepo/ubuntu:custom` |
    | `docker rmi`             | 删除镜像                       | `docker rmi ubuntu:20.04`          |
    | `docker save`            | 将镜像保存为 .tar 文件         | `docker save -o ubuntu.tar ubuntu:20.04` |
    | `docker load`            | 从 .tar 文件加载镜像           | `docker load -i ubuntu.tar`        |
    | `docker inspect`         | 查看镜像详细信息               | `docker inspect ubuntu:20.04`      |
    | `docker history`         | 查看镜像构建历史               | `docker history ubuntu:20.04`      |
    | `docker search`          | 在 Docker Hub 搜索镜像         | `docker search ubuntu`              |
    | `docker push`            | 推送镜像到仓库                 | `docker push myrepo/myimage:v1`    |

- 删除未使用镜像（dangling）：`docker image prune`,删除全部镜像（⚠️ 慎用）：`docker rmi $(docker images -q)`
- 创建镜像

    1. docker commit 是用于 将运行中的容器保存成一个新的镜像 的命令。`docker commit [OPTIONS] CONTAINER_ID_OR_NAME [REPOSITORY[:TAG]]`

    | 参数                     | 含义                                     | 示例                     |
    |--------------------------|------------------------------------------|--------------------------|
    | `-a, --author`           | 指定作者名                              | `-a "eamon"`             |
    | `-m, --message`          | 提交备注（类似 Git 提交信息）          | `-m "添加了 Python"`     |
    | `-p, --pause`            | 提交时是否暂停容器（默认开启）          | `--pause=false` 可提升速度 |

    2. Dockerfile 是一组 构建镜像的指令集合，可以理解为“镜像的配方/食谱”。`docker build -t myapp:1.0 .`
    | 参数 | 全称        | 含义                                  |
    |------|-------------|---------------------------------------|
    | `-t` | `--tag`     | 给构建的镜像起名字（比如 myapp:1.0） |
    | `.`  | —           | 指定 Dockerfile 所在目录（当前目录）  |


## Docker 容器连接

- Docker 中的 -p 和 -P 参数，它们是用于 容器端口与宿主机端口的映射（port mapping）,-p 和 -P 是让容器内部的端口暴露给宿主机使用的方式，方便浏览器、其他服务访问容器里的应用。

1. -p：显式端口映射:`docker run -p <host_port>:<container_port> <image>`,如：`docker run -d -p 8080:80 nginx`，宿主机的 8080 端口 → 容器的 80 端口，

容器里运行的是 nginx（默认监听 80 端口），浏览器访问 http://localhost:8080 就能访问 nginx！

2. -P（大写）：自动分配随机端口（不推荐用于生产），`docker run -d -P nginx`,Docker 会把容器中所有 EXPOSE 的端口映射到宿主机上的随机高位端口（如 32768~60999）,比如：容器 80 → 宿主机 32770。通过以下命令查看映射:`docker port <container_id>`,输出：80/tcp -> 0.0.0.0:32770

3. 多个端口映射：`docker run -d -p 8080:80 -p 8443:443 nginx`,把容器的 80 映射到宿主的 8080,把容器的 443 映射到宿主的 8443

    | 命令                         | 映射说明                                    |
    |------------------------------|--------------------------------------------|
    | `-p 8000:80`                 | 显式映射，宿主 8000 → 容器 80              |
    | `-p 127.0.0.1:8000:80`       | 限定只允许 localhost 访问                  |
    | `-P`                         | 自动映射所有暴露端口到随机宿主端口        |

    | 场景                      | 推荐做法                                         |
    |---------------------------|--------------------------------------------------|
    | 想暴露 Web 服务          | 使用 `-p` 明确指定                              |
    | 想部署多个服务          | 使用 `-p` 分配不同端口（如 8080, 8081）        |
    | 想只让本机访问          | `-p 127.0.0.1:8080:80`                          |
    | 测试用、临时用          | 可以用 `-P`，但要配合 `docker port` 查看映射  |

## Docker 仓库管理

- 仓库（Repository）是集中存放镜像的地方。目前 Docker 官方维护了一个公共仓库 Docker Hub。大部分需求都可以通过在 Docker Hub 中直接下载镜像来实现。

- 注册, 在 https://hub.docker.com 免费注册一个 Docker 账号。

- 登录和退出:登录需要输入用户名和密码，登录成功后，我们就可以从 docker hub 上拉取自己账号下的全部镜像。`docker login`,通过 docker search 命令来查找官方仓库中的镜像，并利用 docker pull 命令来将它下载到本地.`ocker search ubuntu`,推送镜像,用户登录后，可以通过 docker push 命令将自己的镜像推送到 Docker Hub。以下命令中的 username 请替换为你的 Docker 账号用户名。

  1. `docker login [registry_url]`,默认指向的是 Docker Hub

  2. 登录信息默认保存在本地：`~/.docker/config.json`

  3. docker tag：给镜像打标签，把本地镜像「重新命名」成带有远程仓库格式的镜像名，以便推送。`docker tag <源镜像名>:<tag> <目标镜像名>:<tag>`,这不会复制镜像，只是给同一个镜像打了一个新标签（指向）。 yourname 请替换为你的 Docker 账号用户名,假设你本地有个镜像叫 myapp:latest，想上传到 Docker Hub 的 yourname/myapp:v1：`docker tag myapp:latest yourname/myapp:v1`,

  4. docker push：推送镜像到远程仓库,`docker push <镜像名>:<tag>`,`docker push yourname/myapp:v1`,远程仓库镜像名一般长这样`[registry_url/]username/image_name[:tag]`

  5. 登出 Docker Hub（默认）`docker logout`,登出私有仓库`docker logout harbor.mycompany.com`

## Docker Dockerfile

Dockerfile 是一个文本文件，包含了构建 Docker 镜像的所有指令。Dockerfile（首字母大写，没后缀）,也可以用其他文件格式，但用 -f 指定

Dockerfile 是一个用来构建镜像的文本文件，文本内容包含了一条条构建镜像所需的指令和说明。

通过定义一系列命令和参数，Dockerfile 指导 Docker 构建一个自定义的镜像。

-  Dockerfile 指令详解
    | 指令         | 说明                                          | 示例                               |
    |--------------|-----------------------------------------------|------------------------------------|
    | `FROM`       | 指定基础镜像（必须）                         | `FROM ubuntu:20.04`                |
    | `RUN`        | 执行命令（安装、配置等）                     | `RUN apt install -y curl`          |
    | `COPY`       | 复制文件到镜像中                            | `COPY . /app`                       |
    | `ADD`        | 类似 `COPY`，还支持 URL 下载和解压          | `ADD https://... /app/file`        |
    | `WORKDIR`    | 设置工作目录                                | `WORKDIR /app`                      |
    | `CMD`        | 容器启动时默认执行的命令                    | `CMD ["python3", "main.py"]`      |
    | `ENTRYPOINT` | 启动入口点，通常和 `CMD` 配合使用           | `ENTRYPOINT ["python3"]`           |
    | `EXPOSE`     | 声明容器监听端口（不会自动映射）             | `EXPOSE 8080`                       |
    | `ENV`        | 设置环境变量                                | `ENV PATH /opt/bin:$PATH`          |
    | `ARG`        | 构建时参数（区别于 `ENV`）                  | `ARG VERSION=1.0`                  |

    - FROM 是 Dockerfile 中最重要的一行指令之一，表示构建镜像的起点，也就是“基础镜像”。
        | 基础镜像         | 含义                                    |
        |------------------|-----------------------------------------|
        | `ubuntu`         | 纯净的 Ubuntu 系统环境                  |
        | `python:3.9`     | 带 Python 3.9 的环境                    |
        | `node:18`        | Node.js 开发环境                        |
        | `alpine`         | 极简 Linux 发行版（几 MB）             |
        | `nvidia/cuda`    | 带 CUDA 的 GPU 运行环境                 |
        | `scratch`        | 空白镜像（干净，常用于构建最小镜像）   |

    - RUN 是在构建镜像时运行某个命令，并把执行结果打包进最终镜像中。它不是运行容器，而是构建镜像的一个步骤，构建完以后这步的结果会“烙进镜像”里。
        | 用法               | 示例                       | 作用                      |
        |--------------------|----------------------------|---------------------------|
        | 安装依赖           | `RUN apt install -y xxx`   | 安装系统软件              |
        | 复制并编译代码     | `RUN make`                 | 代码编译                  |
        | 设置环境结构       | `RUN mkdir /app`          | 创建目录、配置环境        |
        | 清理缓存           | `RUN apt clean`            | 减少镜像大小              |

        shell 形式（最常见），`RUN apt update && apt install -y python3`,本质就像你在 shell 中输入命令一样。

        exec 形式（JSON 格式）,`RUN ["apt", "install", "-y", "python3"]`,推荐在需要 精确控制参数 或 兼容特殊字符（如空格） 时使用。

        多个 RUN 指令和合并技巧

        ```te
        # 不推荐：每个 RUN 会生成一层，镜像变大
        RUN apt update
        RUN apt install -y git

        # 推荐：合并成一层，构建更快
        RUN apt update && apt install -y git
        ```

        清理缓存，减小镜像体积（超重要）`RUN apt update && apt install -y git && rm -rf /var/lib/apt/lists/*`

        | 指令         | 执行时机         | 用途                  |
        |--------------|------------------|-----------------------|
        | `RUN`        | 🔧 构建镜像时    | 安装、配置环境        |
        | `CMD`        | 🚀 运行容器时    | 默认运行命令          |
        | `ENTRYPOINT` | 🚀 运行容器时    | 更强绑定的启动命令    |

    - COPY 是将你本地的文件/目录复制进正在构建的镜像中。

    `COPY <源路径> <目标路径>`,<源路径> 是你本地项目目录中的文件/文件夹,<目标路径> 是容器镜像内的路径（从 / 根目录起）,把当前目录的所有文件（除了 .dockerignore 过滤掉的）复制到镜像内的 /app 目录, 就像是把代码、配置文件、模型、依赖等打包进镜像，让镜像内也能访问这些文件。

    配合 .dockerignore 使用,可以防止将一些无关内容（如缓存、临时文件）复制进镜像，减小体积

    - ADD 是用来将文件/目录复制进镜像的高级版命令，带有“自动解压”和“远程下载”的功能。

    `ADD <源路径> <目标路径>`,`ADD model.tar.gz /models/` 构建时会自动解压成 /models/model/... 内容，而不是一个压缩包。这个功能是 COPY 没有的。

    `ADD https://example.com/app.tar.gz /downloads/`, 会从网络下载文件并保存到镜像里。这个 COPY 也不能做。从 URL 下载会导致构建过程依赖网络，不利于缓存,Docker 官方推荐用 COPY + curl/wget 更明确

    - WORKDIR 是设置容器内的“工作目录”，就像你在终端用 cd 进入一个目录一样。在 Dockerfile 中，后续的命令（比如 RUN、COPY、CMD 等）都会相对于这个目录运行。

    `WORKDIR <路径>`,多次使用 WORKDIR 会自动拼接,

    ```te
    WORKDIR /app
    WORKDIR src
    WORKDIR code
    ```
    等价于：`WORKDIR /app/src/code`

    - CMD 用来指定容器启动时默认要执行的命令。它不是构建时执行的（像 RUN），而是你用 docker run 启动容器时默认执行的命令。当你运行镜像会自动执行,如果你在 docker run 命令中提供了自己的命令，CMD 就会被覆盖,一个 Dockerfile 只能有一个 CMD,如果你写了多个，只有最后一个生效.

    - ENTRYPOINT 是容器启动时强制执行的“主命令”，不会被 docker run 传参轻易覆盖。相比之下，CMD 是默认命令，可被覆盖；而 ENTRYPOINT 更像是“主程序入口”，更强绑定、更固定。

    - EXPOSE 是在 Dockerfile 中声明“容器内部会使用的端口”，用来告诉别人容器服务在哪监听。注意❗它不会真的把端口映射出来，只是一个说明/声明性的标记。
        `EXPOSE <端口>[/协议]`

    - ENV 用于在构建镜像时定义环境变量，容器运行时也能使用。`ENV <变量名>=<值>`

    - ARG 是在镜像构建过程中使用的变量，只能在 docker build 的阶段使用，容器运行时用不到。

    敏感信息（如密码、token）不要写在 ENV，可以临时传给 ARG 用完就丢。
    `ARG SECRET_TOKEN, RUN git clone https://example.com/repo --token=${SECRET_TOKEN}`





- docker build 是根据 Dockerfile 的指令，一层一层构建出一个完整的 Docker 镜像，`docker build [OPTIONS] PATH | URL | -`,PATH：指向 Dockerfile 所在目录（通常是 . 当前目录）, URL：可用 Git 地址作为构建上下文, -：从标准输入读取 Dockerfile 内容（不常用）

    常用参数：
    | 参数              | 全称          | 说明                                                 |
    |-------------------|---------------|------------------------------------------------------|
    | `-t`              | `--tag`       | 给镜像命名和打标签，如 myapp:1.0                    |
    | `-f`              | `--file`      | 指定 Dockerfile 文件（默认是 Dockerfile）            |
    | `--no-cache`      | —             | 构建时不使用缓存，全部从头执行                        |
    | `--build-arg`     | —             | 构建时传入参数，配合 `ARG` 指令使用                  |
    | `--platform`      | —             | 指定构建平台（如 linux/amd64，适用于跨架构）        |
    | `--progress`      | —             | 设置构建进度显示方式：auto、plain、tty               |
    | `--target`        | —             | 多阶段构建中指定阶段名称                             |

    1. 构建当前目录的 Dockerfile 镜像，`docker build -t myapp:1.0 .`,-t myapp:1.0 给镜像起名叫 myapp，标签是 1.0, . 表示当前目录包含 Dockerfile
    2. 使用指定的 Dockerfile 文件构建 `docker build -f Dockerfile.dev -t devapp .`
    3. 传入构建参数 --build-arg, Dockerfile 中：`ARG APP_ENV  RUN echo "Environment: $APP_ENV"`,构建时传入：`docker build --build-arg APP_ENV=production -t myapp:prod .`
    4. 禁用构建缓存（每次都重新构建）`docker build --no-cache -t myapp:clean .`，默认情况下，Docker 会对每一层进行缓存，只要 Docker 判断这一层和上次构建时一模一样，它就直接跳过，使用缓存版本（更快但可能不是最新）。
    5. 使用多阶段构建目标（--target），
        ```te
        FROM node AS builder
        RUN npm install

        FROM nginx
        COPY --from=builder /app/dist /usr/share/nginx/html
        ```
        `docker build --target builder -t myapp:builder .`
    6. 指定平台（跨平台构建）,`docker build --platform linux/arm64 -t armapp .`，当你在 AMD/x86 平台（比如 Intel/AMD 电脑）用 docker build 构建镜像时，这个镜像默认是为 linux/amd64 构建的。`docker buildx create --use`，`docker buildx build --platform linux/arm64 -t myimage:arm64 .`,这样你就会在 x86 机器上构建出一个适用于 ARM64 架构的镜像。



- 默认构建时只识别当前目录下的 Dockerfile，`docker build -t myapp .`,如果你的文件名不是 Dockerfile，可以手动指定：`docker build -f MyDockerfile.txt -t myapp .`
- 如果你要创建多个 Dockerfile（例如不同环境），可以命名为：`Dockerfile.dev, Dockerfile.prod, Dockerfile.conda`,然后分别用 -f 构建`docker build -f Dockerfile.prod -t myapp:prod .`

## docker compose

- Docker Compose 是一个工具，用于定义和管理多个 Docker 容器的运行。通过一个配置文件（docker-compose.yml）
- `docker-compose [OPTIONS] COMMAND [ARGS...]`或是`docker-compose [OPTIONS] COMMAND [ARGS...]`,使用新版 docker compose 语法
- 
    | 命令     | 作用                               | 说明                          |
    |----------|------------------------------------|-------------------------------|
    | `up`     | 启动服务                           | 默认会构建镜像并启动          |
    | `down`   | 停止服务并清理容器、网络          | 💥 推荐关闭时使用             |
    | `build`  | 手动构建服务镜像                   | 相当于 `docker build`        |
    | `start`  | 启动已停止的容器                   | 不会重建镜像                 |
    | `stop`   | 停止运行的服务容器                 | 暂停运行不清除容器           |
    | `restart`| 重启容器                           | 容器重启，镜像不变           |
    | `logs`   | 查看服务日志                       | 跟 `docker logs` 类似        |
    | `ps`     | 查看服务状态                       | 哪些容器正在跑               |    
