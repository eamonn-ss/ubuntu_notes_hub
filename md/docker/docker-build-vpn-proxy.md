# Docker 构建阶段的网络访问路径

> 环境：Docker build + 宿主机代理/VPN
> 验证：未复核（2026-09-19 仅做仓库整理，未在本机重跑步骤）
> 相关：[docker-install-ubuntu.md](docker-install-ubuntu.md)


- 宿主机能翻墙 ≠ Docker 构建阶段一定能走 VPN

    原因：
    ```te
    docker build 默认不走你桌面/终端的代理

    Docker 构建时：

    apt-get

    git clone github.com

    wget isaac.download.nvidia.com

    pip install

    ```
    这些全部在 Docker daemon 的网络命名空间里

    👉 Docker daemon 不知道你的 VPN 存在

## 让 Docker 显式走你的 VPN 代理

1. 第一步：确认你的 VPN 代理端口: `echo $http_proxy`，或是 `ss -tunlp | grep 789`

2. 配置 Docker daemon 走代理

- 编辑（不存在就新建）
    ```te
    sudo mkdir -p /etc/systemd/system/docker.service.d
    sudo vim /etc/systemd/system/docker.service.d/proxy.conf
    ```

- 内容如下（按你的端口改）：

    ```te
    [Service]
    Environment="HTTP_PROXY=http://127.0.0.1:7897"
    Environment="HTTPS_PROXY=http://127.0.0.1:7897"
    Environment="NO_PROXY=localhost,127.0.0.1"
    ```

- 重载并重启 Docker

    ```te
    sudo systemctl daemon-reexec
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    ```

- 确认 Docker 已经“吃到代理”

    `docker info | grep -i proxy`，正确情况应该能看到类似:
    ```te
    HTTP Proxy: http://127.0.0.1:7897
    TTPS Proxy: http://127.0.0.1:7897
    ```
- 在 Docker 里测试 GitHub / NVIDIA 访问：
    ```te
    docker run --rm alpine \
    sh -c "apk add --no-cache curl && curl -I https://github.com"
    ```
    如果返回 HTTP/2 200 或 301，说明 代理完全 OK。


## 
1. GitHub“单仓库超时”问题：
`fatal: unable to access 'https://github.com/ros-planning/moveit2_tutorials.git/':
Failed to connect to github.com port 443 after 132422 ms: Connection timed out`，Docker 能走 VPN，但 GitHub 对大仓库的 HTTPS 长连接仍然会“随机超时”

- 对 Git 使用 ghproxy，不改 Docker 网络，只把 GitHub clone 走一个“加速中转”

    如：`git clone https://github.com/ros-planning/moveit2_tutorials.git -b humble`，

    改成：`git clone https://ghproxy.com/https://github.com/ros-planning/moveit2_tutorials.git -b humble`

    或是`git clone https://mirror.ghproxy.com/https://github.com/ros-planning/moveit2_tutorials.git -b humble`

    ghproxy 的特点：

    不需要额外配置

    对 Docker / Git 都透明

    专门解决 GitHub clone 超时

2. 如下报错提醒：`32.65 error: RPC failed; curl 16 Error in the HTTP2 framing layer
32.65 fatal: expected flush after ref listing`

    Git 在 Docker build 中使用 HTTP/2 + 长连接 + GitHub + VPN 时的已知问题

    这是 Git + curl + HTTP2 的经典 bug 场景，在 CI / Docker / 国内网络下非常常见。Git 的 HTTP/2 实现 + 代理 + Docker build = 极易触发 curl 16

- 强制 Git 禁用 HTTP/2

    在Dockerfile（在 clone 之前加一行）`RUN git config --global http.version HTTP/1.1`
    然后保持原 clone 不变:
    ```te
    RUN mkdir -p /opt/ros/humble && cd /opt/ros/humble \
        && git clone https://github.com/andrewbest-tri/vcstool.git -b andrewbest/delay \
        && echo 'source /opt/ros/humble/vcstool/setup.sh' | tee --append /etc/bash.bashrc
    ```
