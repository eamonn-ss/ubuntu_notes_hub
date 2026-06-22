##  方法 1：临时添加（命令行）

1. 假设你的网口叫 enp3s0，要添加两个地址：

```python
# 先查看当前网口名称
ip link show

# 添加第一个地址（如果还没添加的话）
sudo ip addr add 192.168.90.188/24 dev enp3s0

# 添加第二个地址
sudo ip addr add 168.168.168.117/24 dev enp3s0

# 查看结果
ip addr show dev enp3s0
```

## 方法 2：永久添加

1. 编辑 /etc/netplan/ 目录下的 .yaml 文件（比如 01-netcfg.yaml 或 50-cloud-init.yaml）：

```python
# /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd    # 或 NetworkManager，取决于你的环境
  ethernets:
    enp3s0:
      dhcp4: no
      addresses:
        - 192.168.90.188/24    # 主 IP
        - 168.168.168.117/24   # 辅助 IP
      gateway4: 192.168.90.1
      nameservers:
        addresses:
          - 114.114.114.114
          - 8.8.8.8
```

2. 应用配置： `sudo netplan apply`

3. 验证： `ip addr show enp3s0`