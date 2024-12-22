#!/bin/bash
set -e

install_opencv () {
  # 获取系统架构信息
  arch=$(uname -m)

  # 函数：自动检测 CUDA 架构
  detect_arch() {
    if command -v nvcc >/dev/null 2>&1; then
        # 获取架构列表并检查输出
        gpu_arch=$(nvcc --list-gpu-arch | grep -Eo "compute_[0-9]+" | tail -1)
        
        # 提取并格式化架构号（将 'compute_' 替换为 'sm_'）
        gpu_arch_number=$(echo $gpu_arch | sed 's/compute_/sm_/')  # 替换 'compute_' 为 'sm_'
        
        # 返回格式化后的架构号
        echo $gpu_arch_number
    else
        echo "错误：未安装 'nvcc'，无法检测 GPU 架构。"
        exit 1
    fi
  }

  # 仅处理 x86_64 架构
  if [[ $arch == "x86_64" ]]; then
      echo "检测到 x86_64 架构，正在运行 Ubuntu。"
      NO_JOB=$(nproc) # 使用所有可用核心进行编译
      ARCH=$(detect_arch)
      PTX="${ARCH}" # PTX 对应于 GPU 计算能力（compute capability），格式为 sm_XX
  else
      echo "不支持的架构：$arch"
      exit 1
  fi

  echo ""
  echo "配置："
  echo "  - 架构：$arch"
  echo "  - PTX：$PTX"
  echo "  - 编译核心数：$NO_JOB"
  echo ""
  
  echo "即将安装 OpenCV"
  echo "大约需要 0.5 小时！"
  
  # 安装依赖项
  sudo apt-get install -y build-essential git unzip pkg-config zlib1g-dev
  sudo apt-get install -y python3-dev python3-numpy python3-pip
  sudo apt-get install -y gstreamer1.0-tools libgstreamer-plugins-base1.0-dev
  sudo apt-get install -y libgstreamer-plugins-good1.0-dev
  sudo apt-get install -y libtbb2 libgtk-3-dev v4l-utils libxine2-dev

  # 确定系统版本
  if [ -f /etc/os-release ]; then
      . /etc/os-release
      VERSION_MAJOR=$(echo "$VERSION_ID" | cut -d'.' -f1)
      if [ "$VERSION_MAJOR" = "22" ]; then
          sudo apt-get install -y libswresample-dev libdc1394-dev
      else
          sudo apt-get install -y libavresample-dev libdc1394-22-dev
      fi
  else
      sudo apt-get install -y libavresample-dev libdc1394-22-dev
  fi

  # 安装常见依赖项
  sudo apt-get install -y cmake libjpeg-dev libjpeg8-dev libjpeg-turbo8-dev
  sudo apt-get install -y libpng-dev libtiff-dev libglew-dev
  sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev
  sudo apt-get install -y libgtk-3-dev libcanberra-gtk*
  sudo apt-get install -y libxvidcore-dev libx264-dev
  sudo apt-get install -y libv4l-dev v4l-utils qv4l2 libva-dev libtbb-dev ffmpeg
  sudo apt-get install -y libopencv-dev libtesseract-dev libpostproc-dev
  sudo apt-get install -y libvorbis-dev libfaac-dev libmp3lame-dev libtheora-dev
  sudo apt-get install -y libopencore-amrnb-dev libopencore-amrwb-dev
  sudo apt-get install -y libopenblas-dev libatlas-base-dev libblas-dev
  sudo apt-get install -y liblapack-dev liblapacke-dev libeigen3-dev gfortran
  sudo apt-get install -y libhdf5-dev libprotobuf-dev protobuf-compiler
  sudo apt-get install -y libgoogle-glog-dev libgflags-dev
  sudo apt-get install -y libboost-all-dev

  # 删除旧版本或先前的构建
  cd ~ 
  sudo rm -rf opencv*

  # 获取 OpenCV 版本
  read -p "请输入 OpenCV 版本（例如：4.x）： " OPENCV_VERSION
  OPENCV_VERSION=${OPENCV_VERSION:-"4.x"}
  echo "使用的 OpenCV 版本：$OPENCV_VERSION"

  wget -O opencv.zip https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip 
  wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/$OPENCV_VERSION.zip
   
  # 解压文件
  unzip opencv.zip 
  unzip opencv_contrib.zip  
  mv opencv-$OPENCV_VERSION opencv
  mv opencv_contrib-$OPENCV_VERSION opencv_contrib

  # 设置安装目录
  cd ~/opencv
  mkdir build
  echo "当前构建目录：$(pwd)/build"  # 输出当前目录路径
  cd build

  # 输入用户的 home 目录前缀，默认是当前用户名
  read -p "请输入 home 目录前缀（默认是当前用户名）： " HOME_PREFIX
  HOME_PREFIX=${HOME_PREFIX:-$(whoami)}

  # 系统级别的安装目录，默认路径为 /usr/local或/home/usr_name/miniconda3/envs/env_name
  read -p "请输入安装目录（默认是 /usr/local）： " INSTALL_PATH
  INSTALL_PATH=${INSTALL_PATH:-"/usr/local"}

  # 输入 CUDA toolkit 的安装路径，默认是 /usr/local/cuda-12.4
  read -p "请输入 CUDA toolkit 路径（默认是 /usr/local/cuda-12.4）： " CUDA_PATH
  CUDA_PATH=${CUDA_PATH:-"/usr/local/cuda-12.4"}

  # 输入 Python 版本
  read -p "请输入 Python 版本（例如：3.8, 3.9，默认是 3.8）： " PYTHON_VERSION
  PYTHON_VERSION=${PYTHON_VERSION:-"3.8"}

  # 输入 CUDA 架构版本
  read -p "请输入 CUDA 架构版本（默认是 8.9）： " CUDA_ARCH_BIN
  CUDA_ARCH_BIN=${CUDA_ARCH_BIN:-"8.9"}

  # 显示用户选择的路径和 Python 版本
  echo "使用以下路径："
  echo "Miniconda 环境：$INSTALL_PATH"
  echo "CUDA toolkit 路径：$CUDA_PATH"
  echo "Python 可执行文件路径：$PYTHON_EXEC_PATH"
  echo "Python 版本：$PYTHON_VERSION"
  
  # 执行 cmake
  cmake -D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_INSTALL_PREFIX=$INSTALL_PATH \
  -D OPENCV_EXTRA_MODULES_PATH=/home/$HOME_PREFIX/opencv_contrib/modules \
  -D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
  -D WITH_OPENCL=OFF \
  -D CUDA_ARCH_BIN=$CUDA_ARCH_BIN \
  -D WITH_CUDA=ON \
  -D CUDA_TOOLKIT_ROOT_DIR=$CUDA_PATH \
  -D CUDNN_INCLUDE_DIR=$CUDA_PATH/include \
  -D CUDNN_LIBRARY=$CUDA_PATH/lib64/libcudnn.so \
  -D WITH_CUDNN=ON \
  -D WITH_CUBLAS=ON \
  -D ENABLE_FAST_MATH=ON \
  -D CUDA_FAST_MATH=ON \
  -D OPENCV_DNN_CUDA=ON \
  -D ENABLE_NEON=OFF \
  -D WITH_QT=OFF \
  -D WITH_PYTHON2=OFF \
  -D WITH_OPENMP=ON \
  -D BUILD_JPEG=ON \
  -D BUILD_TIFF=ON \
  -D WITH_FFMPEG=ON \
  -D WITH_GSTREAMER=ON \
  -D WITH_TBB=ON \
  -D BUILD_TBB=ON \
  -D BUILD_TESTS=OFF \
  -D WITH_EIGEN=ON \
  -D WITH_V4L=ON \
  -D WITH_PROTOBUF=ON \
  -D OPENCV_ENABLE_NONFREE=ON \
  -D INSTALL_C_EXAMPLES=OFF \
  -D INSTALL_PYTHON_EXAMPLES=OFF \
  -D CMAKE_VERBOSE_MAKEFILE=ON \
  -D BUILD_opencv_python3=ON \
  -D BUILD_opencv_python2=OFF \
  -D PYTHON3_EXECUTABLE=$INSTALL_PATH/bin/python3 \
  -D PYTHON3_LIBRARY=$INSTALL_PATH/lib/libpython${PYTHON_VERSION}.so \
  -D PYTHON3_INCLUDE_DIR=$INSTALL_PATH/include/python${PYTHON_VERSION} \
  -D PYTHON3_PACKAGES_PATH=$INSTALL_PATH/lib/python${PYTHON_VERSION}/site-packages \
  -D OPENCV_GENERATE_PKGCONFIG=ON \
  -D BUILD_EXAMPLES=OFF \
  -D CMAKE_CXX_FLAGS="-march=native -mtune=native" \
  -D CMAKE_C_FLAGS="-march=native -mtune=native" ..

  make -j ${NO_JOB} 
  # 判断目录是否存在
  if [ -d "$directory" ]; then
      # 输出目录内容，确认是否是旧版 OpenCV 头文件
      echo "目录 '$directory' 存在，以下是目录内容："
      ls -l "$directory"

      # 确认是否删除
      read -p "确定要删除此目录及其内容吗？(y/n): " confirm
      if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
          # 删除目录
          echo "正在删除目录 '$directory' ..."
          sudo rm -rf "$directory"
          echo "目录 '$directory' 已删除。"
      else
          echo "操作已取消，未删除目录。"
      fi
  else
      echo "目录 '$directory' 不存在，跳过删除操作。"
  fi
  
  sudo make install
  sudo ldconfig
  
  # cleaning
  make clean
  sudo apt-get update
  
  echo "Congratulations!"
  echo "You've successfully installed OpenCV '$OPENCV_VERSION' on your PC"
}

cd ~
# 检查是否存在名为 ~/opencv/build 的目录，并根据该目录的存在情况决定是否继续安装过程
if [ -d ~/opencv/build ]; then
  echo " "
  echo "You have a directory ~/opencv/build on your disk."
  echo "Continuing the installation will replace this folder."
  echo " "
  
  printf "Do you wish to continue (Y/n)?"
  read answer

  if [ "$answer" != "${answer#[Nn]}" ] ;then 
      echo "Leaving without installing OpenCV"
  else
      install_opencv
  fi
else
    install_opencv
fi