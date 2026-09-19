# 创建新镜像，持久化修改

## 步骤如下

- 如果你希望修复后的 libstdc++ 不丢失（即每次重启容器后不用重复安装），可以基于 已拉取的镜像 重新构建新镜像：
  1. 先运行原始容器，并修复 libstdc++，进入容器，并执行 libstdc++ 的安装和替换。
  2. 提交修改后的容器，如果能成功运行，你可以提交这个修改过的容器，然后创建一个新的镜像：`docker commit <你的容器ID> my_fixed_image`，这样你就创建了一个包含 libstdc++ 更新的镜像，命名为 my_fixed_image。
  3. 下次直接使用这个新镜像运行：`docker run -it --rm my_fixed_image /bin/bash`
- 如何保存和分享新镜像
  1. 导出镜像到 .tar 文件`docker save -o my_fixed_image.tar my_fixed_image`
  2. 拷贝 .tar 文件到另一台机器
  3. 在另一台机器上导入镜像`docker load -i my_fixed_image.tar`