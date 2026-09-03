# ubuntu安装海康工业相机MVS

1. 安装MVS客户端+SDK

- 进入海康机器人官网 [海康机器人下载中心](https://www.hikrobotics.com/cn/machinevision/service/download/?module=0)，下载 MVS 软件。
- 下载如：机器视觉工业相机客户端MVS V3.0.1 (Linux)，下载目录如：`~/Downloads/MVS_STD_V3.0.1_241128.zip`
- 
    ```bash
    mv ~/Downloads/MVS_STD_V3.0.1_241128.zip ~/mvscamera/
    cd ~/mvscamera/
    mkdir MVS
    unzip MVS_STD_V3.0.1_241128.zip -d ./MVS
    cd MVS
    ```
- 根据提供的readme选择一项安装，这里使用deb的方式安装：
    ```bash
    sudo dpkg -i MVS-3.0.1_x86_64_20241128.deb
    # 删除用以下命令
    sudo dpkg -r mvs
    # 运行MVS
    cd /opt/MVS/bin/
    ./MVS
    ```
2. 运行示例

- 工业相机SDK的示例程序都在：/opt/MVS/Samples/64路径下
- 运行如下命令，显示的是 Find No Devices，表示安装成功，因为的没有连接工业相机，所以显示的是 Find No Devices
    ```bash
    source ~/.bashrc
    cd /opt/MVS/Samples/64/C++/General/GrabImage
    make
    ./GrabImage
    ```
3. 其他设置（开启网络巨帧）
- 命令如下：
    ```bash
    # 查看网卡名
    ifconfig
    # 开启网络巨帧
    sudo ifconfig enp3s0 mtu 9000
    # 再次使用ifconfig查看，mtu等于9000，即设置成功
    ifconfig

    # 永久设置网卡开启巨帧
    sudo vim /etc/network/interfaces
    # 将sudo ifconfig enp3s0 mtu 9000写入文件
    ```
4. 静态IP配置
-  电脑本地IP配置，将 PC 的网口配置成使用静态 IP 地址，路径如下：设置->网络->有线->齿轮，选择IPv4，IPv4方法选择手动，地址：192.168.16.100，网络掩码：255.255.255.0，网关：192.168.16.255，应用。
-  相机 IP 设置，完成相机和客户端的安装后，在设备列表中，若相机为不可达状态 ，则需要手动设 置相机 IP。
-  双击状态为不可达的相机名称，界面将弹出“修改 IP 地址”对话框。
-  在“修改 IP 地址”对话框中，选择“静态 IP”，参照相机可达的网段，设置相机的“IP 地址”、“子网掩码”以及“默认网关”，单击“确定”，
-  IP address	192.168.16.x（92.168.16.10）（确保与你电脑不冲突）
-  Subnet Mask	255.255.255.0
-  Default Gateway	192.168.16.1（或你当前网关，也可以填 0.0.0.0）