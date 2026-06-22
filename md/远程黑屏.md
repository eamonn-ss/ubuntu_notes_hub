# Todesk远程黑屏问题

## 在 Linux 系统中，如果没有连接显示器，X11 或 Wayland 图形界面有时不会自动启动，这会导致远程工具（如 ToDesk、VNC、xrdp 等）黑屏。

- 判断你用的是 X11 还是 Wayland
    `echo $XDG_SESSION_TYPE`

    输出为 x11：你使用的是 X11

    输出为 wayland：你使用的是 Wayland

    没有输出：当前没有图形会话

- 使用虚拟显示器驱动（无物理显示器时）

    如果你没有连接任何显示器，可以借助 xserver-xorg-video-dummy 驱动创建虚拟屏幕。

    1. 安装 dummy 驱动

        `sudo apt install xserver-xorg-video-dummy`

    2. 创建虚拟显示配置文件

    `sudo vim /etc/X11/xorg.conf`

    3. 内容如下

        ```bash
        Section "Device"
            Identifier  "Configured Video Device"
            Driver      "dummy"
            VideoRam    256000
        EndSection

        Section "Monitor"
            Identifier  "Configured Monitor"
            HorizSync   31.5-48.5
            VertRefresh 50-70
        EndSection

        Section "Screen"
            Identifier  "Default Screen"
            Monitor     "Configured Monitor"
            Device      "Configured Video Device"
            DefaultDepth 24
            SubSection "Display"
                Depth   24
                Modes   "1920x1200"
            EndSubSection
        EndSection
        ```
