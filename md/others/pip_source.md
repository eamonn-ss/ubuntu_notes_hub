# pip 软件源（PyPI 镜像源）笔记

---

# 1. 什么是 pip 软件源

pip 默认从：

```text
https://pypi.org
```

下载 Python 软件包。

但国内访问：

- 速度慢
- 容易超时
- 经常 SSL 失败

因此通常会切换到：

```text
国内 PyPI 镜像源
```

例如：

- 清华
- 阿里云
- 中科大
- 华为云

---

# 2. pip 与 apt 的区别

| 工具 | 管理对象 |
|---|---|
| apt | Ubuntu/Linux 系统软件 |
| pip | Python 软件包 |

例如：

```bash
sudo apt install python3-pip
```

是：

```text
安装 pip 工具本身
```

而：

```bash
pip install numpy
```

是：

```text
安装 Python 的 numpy 包
```

---

# 3. pip 默认官方源

官方源：

```text
https://pypi.org/simple
```

很多时候：

```text
pip install xxx
```

本质就是：

```text
pip -> pypi.org -> 下载 wheel/tar.gz
```

---

# 4. 常见国内 pip 镜像源

| 镜像站 | URL |
|---|---|
| 清华 | https://pypi.tuna.tsinghua.edu.cn/simple |
| 阿里云 | https://mirrors.aliyun.com/pypi/simple |
| 中科大 | https://pypi.mirrors.ustc.edu.cn/simple |
| 华为云 | https://repo.huaweicloud.com/repository/pypi/simple |
| 豆瓣 | https://pypi.douban.com/simple |

---

# 5. pip 临时换源（推荐最常用）

临时换源：

```bash
pip install numpy -i https://pypi.tuna.tsinghua.edu.cn/simple
```

含义：

| 参数 | 含义 |
|---|---|
| -i | index-url，指定 PyPI 镜像源 |

特点：

- 仅当前命令生效
- 不修改系统配置
- 最安全
- 最常用

---

# 6. 临时换源示例

## 安装 torch

```bash
pip install torch -i https://pypi.tuna.tsinghua.edu.cn/simple
```

---

## 安装 ultralytics

```bash
pip install ultralytics -i https://pypi.tuna.tsinghua.edu.cn/simple
```

---

## 安装 requirements.txt

```bash
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

---

# 7. pip 永久换源（配置方式）

永久换源：

```text
修改 pip 配置文件
```

之后：

```bash
pip install xxx
```

会自动使用国内源。

---

# 8. Linux pip 配置文件位置

用户级：

```bash
~/.pip/pip.conf
```

或者：

```bash
~/.config/pip/pip.conf
```

---

# 9. 创建 pip 配置目录

```bash
mkdir -p ~/.pip
```

---

# 10. 创建 pip.conf

```bash
nano ~/.pip/pip.conf
```

内容：

```ini
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
```

---

# 11. 推荐配置（完整版）

```ini
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
trusted-host = pypi.tuna.tsinghua.edu.cn
timeout = 120
```

字段说明：

| 字段 | 含义 |
|---|---|
| index-url | 默认 PyPI 镜像 |
| trusted-host | 信任该主机 |
| timeout | 超时时间 |

---

# 12. 查看当前 pip 配置

```bash
pip config list
```

---

# 13. 查看 pip 当前使用的源

```bash
pip config get global.index-url
```

---

# 14. 删除 pip 配置

删除配置文件：

```bash
rm ~/.pip/pip.conf
```

---

# 15. 临时换源 vs 永久换源

| 方式 | 特点 |
|---|---|
| 临时换源 | 当前命令有效 |
| 永久换源 | 全局默认使用 |

---

# 16. 推荐使用方式

## 开发环境推荐：

```text
永久换源
```

因为：

- 经常安装包
- 更方便
- 不用每次加 -i

---

## 临时测试推荐：

```text
临时换源
```

因为：

- 不污染系统
- 更灵活
- 适合 Docker

---

# 17. pip 常见安装方式

## 普通安装

```bash
pip install numpy
```

---

## 指定版本

```bash
pip install numpy==1.26.4
```

---

## 安装 wheel 文件

```bash
pip install xxx.whl
```

---

## 使用国内源安装

```bash
pip install xxx -i https://pypi.tuna.tsinghua.edu.cn/simple
```

---

# 18. 推荐使用 python -m pip

推荐：

```bash
python3 -m pip install numpy
```

不推荐：

```bash
pip install numpy
```

原因：

```text
python -m pip
能确保 pip 与当前 Python 版本一致
```

尤其：

- Conda
- 多 Python 环境
- 虚拟环境
- RKNN
- ROS2

非常重要。

---

# 19. 查看 pip 版本

```bash
pip --version
```

或者：

```bash
python3 -m pip --version
```

---

# 20. 升级 pip

```bash
python3 -m pip install --upgrade pip
```

国内源：

```bash
python3 -m pip install --upgrade pip \
-i https://pypi.tuna.tsinghua.edu.cn/simple
```

---

# 21. pip 下载流程

pip 安装本质：

```text
pip
 ↓
读取 pip.conf
 ↓
访问 PyPI 镜像源
 ↓
下载 wheel / tar.gz
 ↓
安装 Python 包
```

---

# 22. 常见 pip 问题

---

## （1）下载超时

错误：

```text
ReadTimeoutError
```

原因：

```text
访问官方 PyPI 太慢
```

解决：

```bash
pip install xxx -i https://pypi.tuna.tsinghua.edu.cn/simple
```

---

## （2）SSL 错误

错误：

```text
SSL: CERTIFICATE_VERIFY_FAILED
```

解决：

```ini
trusted-host = pypi.tuna.tsinghua.edu.cn
```

---

## （3）找不到包

错误：

```text
No matching distribution found
```

原因：

- Python 版本不兼容
- ARM 架构无 wheel
- 包名错误

---

# 23. ARM 平台注意事项

Jetson / RK3588 / 树莓派：

很多 Python 包：

```text
没有 aarch64 wheel
```

因此：

pip 可能：

```text
自动源码编译
```

会导致：

- 编译很慢
- 缺少 gcc/g++
- 缺少 cmake
- 缺少依赖库

尤其：

- torch
- onnxruntime
- opencv
- tensorflow

经常出现。

---

# 24. pip 与 wheel

pip 优先下载：

```text
.whl
```

wheel 本质：

```text
Python 预编译二进制包
```

优点：

- 安装快
- 不需要编译

---

# 25. pip 与 requirements.txt

安装依赖：

```bash
pip install -r requirements.txt
```

配合国内源：

```bash
pip install -r requirements.txt \
-i https://pypi.tuna.tsinghua.edu.cn/simple
```

---

# 26. pip 软件源整体逻辑

pip 安装流程：

```text
pip
 ↓
读取 pip.conf
 ↓
访问 PyPI 镜像
 ↓
下载 Python 包
 ↓
安装到 site-packages
```

因此：

```text
pip 源 = Python 包下载服务器
```