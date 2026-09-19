# 创建新镜像，持久化容器内修改（libstdc++ 示例）

> 环境：Docker 容器 / libstdc++
> 验证：未复核（2026-09-19 仅做仓库整理，未在本机重跑步骤）
> 相关：[upgrade-libstdcxx-gcc11.md](../linux_system/upgrade-libstdcxx-gcc11.md) · [docker-commands-cheatsheet.md](docker-commands-cheatsheet.md)

## 适用场景

容器内临时修好了依赖（常见：升级 `libstdc++`），但不想每次 `docker run` 都重做一遍。可用 `docker commit` 把当前容器文件系统固化成新镜像。

> 更可维护的做法通常是改 Dockerfile 后 `docker build`；`commit` 适合应急固化。

## 步骤

1. 启动原始镜像并进入容器，完成修复（例如安装/替换 libstdc++，参见相关笔记）。
2. 另开终端查看容器 ID：

```bash
docker ps
```

3. 提交为新镜像：

```bash
docker commit <容器ID> my_fixed_image
```

4. 用新镜像运行：

```bash
docker run -it --rm my_fixed_image /bin/bash
```

## 导出 / 迁移镜像

```bash
# 导出
docker save -o my_fixed_image.tar my_fixed_image

# 另一台机器导入
docker load -i my_fixed_image.tar
```
