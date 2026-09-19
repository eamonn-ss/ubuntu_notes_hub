# systemd

> 环境：Linux systemd（通用）
> 验证：未复核（2026-09-19 仅做仓库整理，未在本机重跑步骤）


- systemd = 管理系统（system）的后台守护进程（d），核心就是 Linux 系统的「后台总管家」。

- system：代表它是管理整个 Linux 系统的核心程序；
- d：是 Linux 后台守护进程（daemon）的通用后缀（比如sshd、nginx、resolved都是后台服务，尾缀均为d）；
额外的小设计：systemd 中的d也暗合Unix/Linux 中/dev、/etc这类目录的尾缀风格，同时与传统SysVinit形成区分，读为「system D」即可。

## 用最通俗的话理解systemd：Linux 系统的「总管家 + 启动器 + 监控器」
- 把 Linux 系统比作一栋写字楼，systemd就是这栋楼的总经理，其他所有程序 / 服务（sshd、nginx、docker、resolved等）都是写字楼里的「公司 / 员工」，systemd的工作就是：
- 开机启动（写字楼开门）：采用并行启动所有服务（所有公司同时开门），大幅提升开机速度，替代传统的串行排队；
- 服务管理（公司日常运营）：通过统一的systemctl命令，管理所有后台服务的启动 / 停止 / 重启 / 开机自启，跨发行版通用；
- 进程监控（员工考勤 + 异常处理）：实时监控所有后台服务，若服务意外崩溃（员工旷工），可自动重启（重新招人），保证系统稳定；
- 集成管理（写字楼配套设施）：内置日志（journald，写字楼监控）、网络（networkd，写字楼网线）、DNS（resolved，写字楼导航）、定时任务（timers，写字楼打卡机）等功能，替代传统零散工具，一站式管理；
- 进程守护（写字楼安全）：作为 Linux 的PID=1 进程（开机后第一个运行的程序），所有其他进程都是它的子进程，若systemd崩溃，整个 Linux 系统会直接重启，是系统的「根进程」。

## 验证命令
- 查看PID=1的进程，必为systemd
`ps -ef | grep PID=1`
- 或更简单的命令
`systemctl --version`  # 查看systemd版本，同时验证其存在

## 核心命令
```te
# 管理服务（核心）
systemctl start 服务名    # 启动服务
systemctl stop 服务名     # 停止服务
systemctl restart 服务名  # 重启服务
systemctl enable 服务名   # 设置开机自启
systemctl disable 服务名  # 关闭开机自启
systemctl status 服务名   # 查看服务运行状态（最常用，排查故障）

# 查看系统日志（替代传统 tail -f /var/log/messages）
journalctl -u 服务名      # 查看指定服务的日志
journalctl -f             # 实时滚动查看日志
journalctl --since "10min ago"  # 查看最近10分钟日志
```

## 修 DNS

1. 编辑 resolved 配置

`sudo nano /etc/systemd/resolved.conf`

2. 找到（或新增）下面内容：

```te
[Resolve]
DNS=8.8.8.8 223.5.5.5
FallbackDNS=1.1.1.1
DNSStubListener=yes
```

3. 重启 DNS 服务

`sudo systemctl restart systemd-resolved`

4. 确认 resolv.conf 正确指向

`sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf`

5. 验证 DNS

`resolvectl status`

能看到`DNS Servers: 8.8.8.8 223.5.5.5`

6. 测试
```te
sudo apt clean
sudo apt update
sudo apt upgrade
```
