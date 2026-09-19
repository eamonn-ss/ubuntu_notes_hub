# 安装docker

> 环境：Ubuntu + Docker
> 验证：未复核（2026-09-19 仅做仓库整理，未在本机重跑步骤）
> 相关：[docker-commands-cheatsheet.md](docker-commands-cheatsheet.md)


## 参考`https://dockerdocs.xuanyuan.me/install/ubuntu`

## 使用官方安装脚本自动安装

```bash
curl -fsSL https://test.docker.com -o test-docker.sh
sudo sh test-docker.sh
```

## 手动安装（推荐）

1. 卸载旧版本docker

- Docker 的旧版本被称为 docker，docker.io 或 docker-engine 。如果已安装，请卸载它们：

    ```bash 
    sudo apt-get remove docker docker-engine docker.io containerd runc
    ```

- 当前称为 Docker Engine-Community 软件包 docker-ce 

2. 使用 Docker 仓库进行安装

- 在新主机上首次安装 Docker Engine-Community 之前，需要设置Docker仓库。之后，您可以从仓库安装和更新Docker。

- 设置仓库
    * 更新 apt 包索引 
        ```bash 
        * sudo apt-get update
        ```
    * 安装 apt 依赖包，用于通过HTTPS来获取仓库:
        ```bash
        sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common
        ```

    * 添加 Docker 的官方 GPG 密钥：
        ```bash 
        sudo curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        ```

    * 使用以下指令设置稳定版仓库:
        ```bash
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/ \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
        ```

3.  安装 Docker Engine-Community
- 更新 apt 包索引:
    ```bash 
    sudo apt-get update
    ```

- 安装最新版本的 Docker Engine-Community 和 containerd：
    ```bash 
    sudo apt-get install docker-ce docker-ce-cli containerd.io
    ```
    - 要安装特定版本的 Docker Engine-Community，请先列出仓库中可用的版本：
    ```bash
        apt-cache madison docker-ce
    ```
    - 然后使用第二列中的版本字符串安装特定版本：
    ```bash 
    sudo apt-get install docker-ce=,<VERSION_STRING>, docker-ce-cli=,<VERSION_STRING>, containerd.io
    ```

1. 镜像加速配置
- 修改 /etc/docker/daemon.json，设置 registry mirror，具体命令如下:
    ```bash 
    sudo vim /etc/docker/daemon.json
    ```
    ```bash
    {
        "registry-mirrors": [
            "https://docker.1ms.run",
            "https://docker.xuanyuan.me"
        ]
    }
    ```
- 重启docker
    ```bash 
    systemctl daemon-reload`,`systemctl restart docker
    ```
- 如果 registry-1.docker.io 无法访问，说明 Docker Hub 可能被墙或是上述镜像源失效，需重新配置。

- 检查配置是否生效

    ```te sudo docker info```
    从结果中看到如下内容：
    ```bash
     Registry Mirrors:
    https://docker.1ms.run/
    https://docker.xuanyuan.me/
    ```
5. 测试 Docker 安装
- ```bash 
  sudo docker run hello-world
  ```
- 会出现如下内容，则安装成功。
    ```bash
    Hello from Docker!
    This message shows that your installation appears to be working correctly.
    ```

1. 如果要使用 Docker 作为非 root 用户，请将用户添加到 docker 组：
   ```bash 
   sudo usermod -aG docker your-user
   ```
- your-user ：要添加到 docker 组的 用户名。你需要替换为你的实际用户名
- 添加用户到 docker 组后，修改 不会立即生效，需要重新登录。或是手动刷新用户组。使用
  `newgrp docker`命令，然后可以尝试```docker ps```,而不需要
  ```bash sudo docker ps```,如上述不行，可以重启电脑。
- 确认用户是否在 docker 组，使用`groups your-user`
- 当出现已在用户组中，依旧没有权限时，这可能是Docker 进程与客户端通信是通过 Unix Socket (/var/run/docker.sock)，你可能需要手动修改权限。
    * 检查当前权限`ls -lah /var/run/docker.sock`如果输出类似于：`srw-rw---- 1 root docker 0 Mar 8 12:34 /var/run/docker.sock`，说明 docker.sock 归 docker 组管理，但如果你刚加入 docker 组，可能还没生效。需要手动修改权限，`bash sudo chmod 666 /var/run/docker.sock`，然后再次尝试。
    * 或是重启docker`sudo systemctl restart docker`,或是重启系统。


1. 卸载docker
- 停止 Docker： `sudo systemctl stop docker`
- 卸载 Docker 相关的软件包：
    ```bash
    sudo apt-get remove --purge docker docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras -y
    ```
-  删除镜像、容器、配置文件等内容：
    ```bash
    sudo rm -rf /var/lib/docker
    sudo rm -rf /etc/docker
    sudo rm -rf ~/.docker
    sudo rm -rf /var/lib/containerd
    ```
- 清理系统
    ```bash
    sudo apt-get autoremove -y
    sudo apt-get autoclean
    ```
- 检查是否还有 Docker 相关的软件：`dpkg -l | grep docker`

- Shell 可能仍然缓存了 docker 的旧路径，可以执行以下命令来更新：`hash -r`
