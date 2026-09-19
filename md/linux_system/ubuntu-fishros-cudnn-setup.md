# 流程如下

- `wget http://fishros.com/install -O fishros && . fishros`
- `sudo apt update`,`sudo apt upgrade`
- `dpkg -l | grep ssh`
- `sudo apt-get install openssh-server`
- `dpkg -l | grep ssh`
- `ps -e | grep ssh`
  
- `conda deactivate`
- `sudo apt install build-essential`
- `sudo sh cuda_11.8.0_520.61.05_linux.run`
```te
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-11.8/lib64
export PATH=$PATH:/usr/local/cuda-11.8/bin
export CUDA_HOME=$CUDA_HOME:/usr/local/cuda-11.8 
```
- `nvcc -V`

- `tar -xvf cudnn-linux-x86_64-8.9.7.29_cuda11-archive.tar.xz`

- 
```te

sudo cp include/cudnn.h /usr/local/cuda-11.8/include
sudo cp lib/libcudnn* /usr/local/cuda-11.8/lib64
sudo chmod a+r /usr/local/cuda-11.8/include/cudnn.h
sudo chmod a+r /usr/local/cuda-11.8/lib64/libcudnn*

```
`cd cudnn-linux-x86_64-8.9.7.29_cuda11-archive`
`sudo cp include/cudnn_version.h /usr/local/cuda/include`
`cat /usr/local/cuda/include/cudnn_version.h | grep CUDNN_MAJOR -A 2`

`pip install ultralytics==8.3.85 -i https://pypi.mirrors.ustc.edu.cn/simple`


列出所有已安装的linux-image包，即内核版本
dpkg --list | grep linux-image
查看当前运行的内核版本
uname -r

## 安装cudnn
dpkg -l | grep cudnn

sudo apt update
sudo apt install -y libfreeimage-dev
cp -r /usr/src/cudnn_samples_v9 $HOME/
cd $HOME/cudnn_samples_v9/mnistCUDNN
make clean
make
./mnistCUDNN

