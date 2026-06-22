# 更改 apt-get 下载源

##  步骤如下
- 备份现有的源配置文件，以防需要恢复：`sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak`
- 修改 /etc/apt/sources.list 文件,APT 的主要源配置文件是 /etc/apt/sources.list。你需要编辑这个文件并替换为新的镜像源，`sudo vim /etc/apt/sources.list`
- 更换国内源，要将源文件的注释，然后使用国内源。
- 检查：`echo $(lsb_release -c | awk '{print $2}')` 或是 `lsb_release -a`，从而确定版本20.04 → focal 22.04 → jammy 18.04 → bionic。
    ```bash
    deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse
    deb http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse
    deb http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse
    deb http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse
    ```
- 修改源配置文件后，运行以下命令更新软件包列表：`sudo apt-get update`
- 升级软件包`sudo apt-get upgrade`
- 清理本地缓存（可选），为了避免冗余的缓存文件，你可以清理本地的 apt 缓存：`sudo apt-get clean`
- 锁死 sources.list 权限（防止再次被脚本写坏）`sudo chattr +i /etc/apt/sources.list`,（以后如果要改源，先 `sudo chattr -i /etc/apt/sources.list`）(optional)
