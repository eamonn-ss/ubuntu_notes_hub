# 卡住系统

> 环境：Linux GRUB 恢复（示例含 HP 机器）
> 验证：未复核（2026-09-19 仅做仓库整理，未在本机重跑步骤）


## 进入 GRUB 启动菜单

- 关机再开机，在出现 HP | ZHAN 画面时 快速连续按 Esc 键 或 Shift 键（推荐多按几次），直到出现 GRUB 菜单界面。

- 如果看到如下内容，说明成功进入 GRUB：

```bash
Ubuntu
Advanced options for Ubuntu
System setup
```

## 进入“恢复模式（Recovery Mode）”

-用方向键选择 Advanced options for Ubuntu；

在里面选择带有 (recovery mode) 字样的选项；

进入恢复菜单后，依次执行以下内容：在 GRUB 菜单中选中第一项（不要按 Enter）

`Ubuntu, with Linux 6.8.0-60-generic`

- 按下 e 键 进入编辑模式

- 找到这一行（用方向键移动）`linux   /boot/vmlinuz-xxx ... quiet splash`

- 把 quiet splash 替换为`nomodeset`

- 按下 Ctrl + X 或 F10 启动系统；

- `linux   /boot/vmlinuz-6.8.0-60-generic root=UUID=xxxxxxx ro quiet splash $vt_handoff`

- 将其中的`quiet splash $vt_handoff`替换为`nomodeset`

## 

- 前使用的是 按需切换模式（on-demand），即系统默认使用集成显卡（Intel），只有当某些程序请求时才会启用独立显卡（NVIDIA）
```bash
prime-select query
→on-demand
```

- 始终使用 NVIDIA 显卡`sudo prime-select nvidia`,`sudo reboot`
