# Ubuntu 软件源（APT Source）笔记

---

# 1. Ubuntu 官方软件源

Ubuntu 软件源根据 CPU 架构不同，分为：

| 架构 | 官方源 |
|---|---|
| x86 / x86_64 | archive.ubuntu.com |
| ARM / aarch64 | ports.ubuntu.com |

例如：

- PC、笔记本（Intel/AMD CPU）：

```bash
http://archive.ubuntu.com/ubuntu
```

- Jetson、RK3588、树莓派等 ARM 设备：

```bash
http://ports.ubuntu.com/ubuntu-ports
```

---

# 2. Ubuntu 22.04+ 新版源配置

以前 Ubuntu 常用：

```bash
/etc/apt/sources.list
```

现在 Ubuntu 22.04 后期开始，尤其：

- Ubuntu 23.xx
- Ubuntu 24.xx

很多系统已经逐渐改成：

```bash
/etc/apt/sources.list.d/*.sources
```

例如：

```bash
/etc/apt/sources.list.d/ubuntu.sources
```

---

# 3. Deb822 新格式

新版 `.sources` 文件采用：

```text
Deb822 格式
```

不像传统：

```bash
deb http://xxx jammy main
```

而是键值对形式：

```text
Types: deb
URIs: http://ports.ubuntu.com/ubuntu-ports
Suites: jammy jammy-updates
Components: main restricted
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
```

---

# 4. Deb822 各字段含义

| 字段 | 含义 |
|---|---|
| Types | 软件源类型 |
| URIs | 软件源地址 |
| Suites | Ubuntu 版本分支 |
| Components | 软件仓库组件 |
| Signed-By | GPG 密钥 |

---

# 5. Ubuntu 常见 Suites

| Suites | 含义 |
|---|---|
| jammy | Ubuntu 22.04 主仓库 |
| jammy-updates | 官方更新 |
| jammy-security | 安全更新 |
| jammy-backports | 回移植新版本软件 |

---

# 6. Ubuntu 常见 Components

| Component | 含义 |
|---|---|
| main | 官方维护核心软件 |
| restricted | 闭源驱动等 |
| universe | 社区维护软件 |
| multiverse | 有版权/限制的软件 |

---

# 7. 为什么 Ubuntu 使用 Deb822

Ubuntu/Debian 正在逐步从：

```bash
/etc/apt/sources.list
```

迁移到：

```bash
/etc/apt/sources.list.d/*.sources
```

原因：

- 更结构化
- 更容易扩展
- 更适合自动化
- 更适合 cloud-init / Docker / ARM 镜像

---

# 8. 查看当前系统架构

查看 Ubuntu 版本：

```bash
cat /etc/os-release
```

查看 CPU 架构：

```bash
uname -m
```

输出：

```text
x86_64
```

表示：

```text
Intel / AMD PC
```

输出：

```text
aarch64
```

表示：

```text
ARM64
```

---

# 9. 查看当前系统使用的软件源

## 查看传统 sources.list

```bash
grep -r ^deb /etc/apt/
```

---

## 查看 Deb822 格式源

```bash
grep -r ^URIs /etc/apt/
```

---

## 查看详细源信息

```bash
grep -r "URIs\|Suites\|Components" /etc/apt/sources.list /etc/apt/sources.list.d/
```

---

# 10. APT 配置文件位置

APT 默认读取：

```bash
/etc/apt/sources.list
/etc/apt/sources.list.d/*.sources
```

因此：

- 直接修改原文件最简单
- 不容易出现多个源冲突
- 适合脚本自动化

---

# 11. 备份 Ubuntu 软件源

修改前建议备份：

```bash
sudo cp /etc/apt/sources.list.d/ubuntu.sources \
/etc/apt/sources.list.d/ubuntu.sources.bak
```

结果：

```text
ubuntu.sources        -> 当前使用
ubuntu.sources.bak    -> 原始备份
```

---

# 12. 使用 sed 修改软件源

## sed 基本格式

```bash
sed -i 's|旧内容|新内容|g' 文件
```

含义：

| 参数 | 含义 |
|---|---|
| s | substitute 替换 |
| \| | 分隔符 |
| g | 全局替换 |
| -i | 直接修改原文件 |

---

# 13. 将 Ubuntu ARM 官方源替换为中科大源

## 修改 ports.ubuntu.com

```bash
sudo sed -i 's|http://ports.ubuntu.com/ubuntu-ports|http://mirrors.ustc.edu.cn/ubuntu-ports|g' /etc/apt/sources.list.d/ubuntu.sources
```

---

## 兼容部分系统的 ports.ubuntu.com

```bash
sudo sed -i 's|http://ports.ubuntu.com|http://mirrors.ustc.edu.cn/ubuntu-ports|g' /etc/apt/sources.list.d/ubuntu.sources
```

---

# 14. 更新软件索引

修改源后：

```bash
sudo apt clean
sudo apt update
```

说明：

| 命令 | 含义 |
|---|---|
| apt clean | 清理旧缓存 |
| apt update | 更新软件索引 |

---

# 15. 检查软件包是否存在

例如检查 pip：

```bash
apt-cache policy python3-pip
```

正常会看到：

```text
Candidate: xxx
```

表示系统已经找到该软件包。

---

# 16. Ubuntu 软件源核心理解

Ubuntu 安装软件本质：

```text
apt -> 软件索引 -> 软件源服务器
```

因此：

- 软件源错误
- 架构不匹配
- 没有 apt update

都会导致：

```text
Package xxx has no installation candidate
```

---

# 17. ARM 平台注意事项

Jetson / RK3588 / 树莓派等 ARM 设备：

必须使用：

```text
ubuntu-ports
```

不能直接使用：

```text
archive.ubuntu.com
```

因为：

```text
archive.ubuntu.com
主要是 x86 软件包
```

ARM 软件包在：

```text
ports.ubuntu.com
```

---

# 18. 推荐排查流程

当 apt 安装失败时：

## 1）查看系统架构

```bash
uname -m
```

---

## 2）查看 Ubuntu 版本

```bash
cat /etc/os-release
```

---

## 3）查看软件源

```bash
cat /etc/apt/sources.list.d/ubuntu.sources
```

---

## 4）更新索引

```bash
sudo apt update
```

---

## 5）检查软件包

```bash
apt-cache policy 软件名
```

---

# 19. python3-pip 找不到问题案例

错误：

```text
Package python3-pip has no installation candidate
```

通常原因：

- 软件源错误
- 没有 apt update
- ARM 使用了 x86 源
- universe 仓库未开启

排查：

```bash
apt-cache policy python3-pip
```

如果出现：

```text
Candidate: 22.0.2+dfsg-1ubuntu0.7
```

说明软件包已经正常存在。

安装：

```bash
sudo apt install python3-pip
```

---

# 20. 常用 APT 命令

## 更新索引

```bash
sudo apt update
```

---

## 升级软件

```bash
sudo apt upgrade
```

---

## 安装软件

```bash
sudo apt install 软件名
```

---

## 删除软件

```bash
sudo apt remove 软件名
```

---

## 搜索软件

```bash
apt search 软件名
```

---

## 查看软件信息

```bash
apt show 软件名
```

---

## 查看软件来源

```bash
apt-cache policy 软件名
```

---

# 21. 推荐国内镜像源

| 镜像站 | 地址 |
|---|---|
| 中科大 | mirrors.ustc.edu.cn |
| 清华 | mirrors.tuna.tsinghua.edu.cn |
| 阿里云 | mirrors.aliyun.com |
| 华为云 | repo.huaweicloud.com |

---

# 22. Ubuntu 软件源整体逻辑

Ubuntu 软件安装流程：

```text
apt
 ↓
读取 sources.list / .sources
 ↓
访问镜像站
 ↓
下载 Packages 索引
 ↓
找到软件包
 ↓
下载并安装
```

因此：

```text
软件源 = 软件仓库入口
```

APT 本身只是管理工具。