# VS Code Server 下载阶段的网络访问失败

> 环境：VS Code Remote-SSH + 受限网络
> 验证：未复核（2026-09-19 仅做仓库整理，未在本机重跑步骤）


- 问题现象：

    ```te
    Trigger local server download
    Downloading VS Code server locally...
    server download URL:
    https://update.code.visualstudio.com/commit:994fd12f8d3a5aa16f17d42c041e5809167e845a/cli-alpine-x64/stable
    ```
    但随后：
        ```te
        Failed to download VS Code Server (Failed to fetch)
        LocalDownloadFailed
        ```
    说明：你这台本地主机也访问不到 update.code.visualstudio.com，或被代理 / 防火墙 / DNS / HTTPS 劫持阻断

- 解决方案

1. 在“能翻墙/能访问外网”的机器上下载

- 版本必须 完全一致（日志里给了 commit id）：`commit id: 994fd12f8d3a5aa16f17d42c041e5809167e845a`
访问（浏览器即可）：`https://update.code.visualstudio.com/commit:994fd12f8d3a5aa16f17d42c041e5809167e845a/server-linux-x64/stable`,得到文件（示例）：`vscode-server-linux-x64.tar.gz`
- 拷贝到远端服务器:`scp vscode-server-linux-x64.tar.gz botler@192.168.31.185:/home/botler/`
- 在远端手动解压到正确目录:
    ```te
    ssh botler@192.168.31.185

    mkdir -p ~/.vscode-server/bin/994fd12f8d3a5aa16f17d42c041e5809167e845a

    tar -xzf vscode-server-linux-x64.tar.gz \
        -C ~/.vscode-server/bin/994fd12f8d3a5aa16f17d42c041e5809167e845a \
        --strip-components=1
    ```
- 重新连接 Remote-SSH
