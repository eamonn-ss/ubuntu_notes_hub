# 代理环境下的 pip / Git 网络问题

> 环境：代理环境 + pip / Git
> 验证：未复核（2026-09-19 仅做仓库整理，未在本机重跑步骤）
> 相关：[../git/github-443-proxy-fix.md](../git/github-443-proxy-fix.md)

## 典型报错

```text
pip._vendor.urllib3.exceptions.ReadTimeoutError:
HTTPSConnectionPool(host='files.pythonhosted.org', port=443): Read timed out.
```

常见原因：未走代理、代理端口错误、或 pip 超时过短。

## 先核对代理端口

系统代理端口（示例）与工具配置必须一致。查看监听端口：

```bash
ss -tuln
# 或
netstat -tuln | grep ':10506'
```

## Git 代理

```bash
git config --global http.proxy  http://127.0.0.1:<端口>
git config --global https.proxy http://127.0.0.1:<端口>
git config --global --get http.proxy
git config --global --get https.proxy

# 取消
git config --global --unset http.proxy
git config --global --unset https.proxy
```

## 终端环境变量（对 pip/curl 等生效）

编辑 `~/.bashrc` 或 `~/.zshrc`：

```bash
export http_proxy="http://127.0.0.1:<端口>"
export https_proxy="http://127.0.0.1:<端口>"
export HTTP_PROXY="$http_proxy"
export HTTPS_PROXY="$https_proxy"
```

然后 `source ~/.bashrc`。

## pip 本身

```bash
# 临时加长超时
pip install <pkg> --default-timeout=100

# 或显式走代理
pip install <pkg> --proxy http://127.0.0.1:<端口>
```

若仅 pip 失败而浏览器正常，优先查环境变量与 `--proxy`，不要只改 Git 配置。
