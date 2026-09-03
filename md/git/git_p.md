# 解决Git连接失败：Failed to connect to github.com port 443 after 2125 ms: Couldn't connect to server

## 背景分析

当你在使用Git与GitHub交互时，可能会遇到这样的错误信息：“Failed to connect to github.com port 443 after 2125 ms: Couldn't connect to server”。这通常发生在使用VPN后，系统端口号与Git端口号不一致时。

## 解决步骤详解

### 1. 问题定位

首先，确认你是否在使用VPN。VPN的使用可能会改变本机的系统端口号，从而影响到Git的正常连接。

### 2. 操作指南

#### a. VPN使用环境下的解决方案

**查看系统端口号**:

- 打开“设置 -> 网络和Internet -> 代理”，记录下当前的端口号。

**设置Git端口号**:
使用命令：

```te
git config --global http.proxy 127.0.0.1:<你的端口号>
git config --global https.proxy 127.0.0.1:<你的端口号>
```

例如：

``` te
git config --global http.proxy 127.0.0.1:10506
git config --global https.proxy 127.0.0.1:10506
```

验证设置：

""""
git config --global -l 或是 git config --global --list
"""

检查输出，确认代理设置已正确配置。

重试Git操作:
在执行git push或git pull前，建议在命令行中运行ipconfig/flushdns以刷新DNS缓存

b. 未使用VPN时的解决方案
如果你并未使用VPN，但依然遇到端口443连接失败的问题，尝试取消Git的代理设置：

```te
git config --global --unset http.proxy
git config --global --unset https.proxy
```

之后重试Git操作，并刷新DNS缓存。

---

### 总结

查看当前的 HTTP 代理配置：

`git config --global http.proxy`

这将输出当前全局配置的 HTTP 代理（如果已经设置）。如果没有设置代理，命令不会返回任何内容。

 设置 HTTP 或 HTTPS 代理:

 ```te
 git config --global http.proxy http://<proxy-server>:<port>
git config --global https.proxy https://<proxy-server>:<port>
```

这里的 `proxy-server` 是代理服务器的地址，`port` 是代理服务器的端口

如果你的 VPN 网络环境需要动态调整代理设置，可以临时设置代理，而不是修改全局配置：

`git -c http.proxy=http://<proxy-server>:<port> clone https://github.com/your/repository.git
`

如果你不再需要使用代理，可以通过以下命令取消代理设置:

```te
git config --global --unset http.proxy
git config --global --unset https.proxy
```

验证设置：

```te
git config --global -l 或是 git config --global 
--list
```
