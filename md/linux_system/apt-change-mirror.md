# 更改 apt 下载源

> 环境：Ubuntu apt（示例含 jammy/22.04）
> 验证：未复核（2026-09-19 仅做仓库整理，未在本机重跑步骤）

## 步骤

1. 备份：

```bash
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
```

2. 确认发行版代号：

```bash
lsb_release -a
# 20.04 → focal · 22.04 → jammy · 18.04 → bionic
```

3. 编辑 `/etc/apt/sources.list`，替换为镜像源（以阿里云 + jammy 为例）：

```bash
sudo vim /etc/apt/sources.list
```

```text
deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse
```

4. 刷新并升级：

```bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get clean   # 可选：清理缓存
```

5. （可选）防止脚本再次改写 sources：

```bash
sudo chattr +i /etc/apt/sources.list
# 以后要改源先：
sudo chattr -i /etc/apt/sources.list
```
