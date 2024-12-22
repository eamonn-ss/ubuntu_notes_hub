# 使用代理时，出现的网络问题

## pip._vendor.urllib3.exceptions.ReadTimeoutError: HTTPSConnectionPool(host='files.pythonhosted.org', port=443): Read timed out.

- 检查端口信息：
- 代理配置：git config --global http.proxy http://代理地址:端口 和 git config --global https.proxy http://代理地址:端口
- 检查代理配置：git config --global --get http.proxy 和 git config --global --get https.proxy
- 希望临时取消 Git 代理（即只在当前会话中取消），可以运行以下命令：git config --global --unset http.proxy 和 git config --global --unset https.proxy

## 永久设置（所有会话生效）

- 编辑 ~/.bashrc 或 ~/.zshrc 文件
- nano ~/.bashrc  # 或 ~/.zshrc
- 在文件末尾添加：export http_proxy="http://代理地址:端口" export https_proxy="https.proxy http://代理地址:端口"
- 保存并运行：source ~/.bashrc  # 或 source ~/.zshrc

## 端口号

- 查看所有监听端口：netstat -tuln
- 查看某个特定端口：netstat -tuln | grep ':8080'

