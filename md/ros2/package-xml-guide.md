# package.xml

> 环境：ROS 2 package.xml
> 验证：未复核（2026-09-19 仅做仓库整理，未在本机重跑步骤）
> 相关：[ros2-package-and-commands.md](ros2-package-and-commands.md)


ROS 2（以及 ROS 1）中每个包的元信息文件，它告诉构建系统（ament / colcon）——这个包是谁、依赖谁、怎么安装、怎么发布。

## 基本结构

一个标准的 ROS 2 package.xml 文件大致如下：
```te
<?xml version="1.0"?>
<package format="3">
  <name>polygon_plugins</name>
  <version>0.1.0</version>
  <description>
    This package implements polygon plugin classes for polygon_base.
  </description>

  <maintainer email="ss@example.com">ss</maintainer>
  <license>Apache-2.0</license>

  <author email="ss@example.com">ss</author>

  <buildtool_depend>ament_cmake</buildtool_depend>

  <build_depend>pluginlib</build_depend>
  <build_depend>polygon_base</build_depend>

  <exec_depend>pluginlib</exec_depend>
  <exec_depend>polygon_base</exec_depend>

  <test_depend>ament_lint_auto</test_depend>

  <export>
    <build_type>ament_cmake</build_type>
  </export>
</package>

```

## 标签（语法）详解

| 标签                      | 说明                                  | 示例                                                             |
| ----------------------- | ----------------------------------- | -------------------------------------------------------------- |
| `<?xml version="1.0"?>` | XML 声明                              | 固定写法                                                           |
| `<package format="3">`  | ROS 包声明，format 可为 2 或 3（ROS 2 推荐 3） | `<package format="3">`                                         |
| `<name>`                | 包名（必须唯一）                            | `<name>polygon_base</name>`                                    |
| `<version>`             | 版本号                                 | `<version>0.1.0</version>`                                     |
| `<description>`         | 包的描述                                | `<description>基类接口</description>`                              |
| `<maintainer>`          | 维护者姓名和邮箱（必填）                        | `<maintainer email="ss@example.com">ss</maintainer>`           |
| `<license>`             | 软件许可协议                              | `<license>Apache-2.0</license>`                                |
| `<author>`              | 作者信息（可多个）                           | `<author email="ss@example.com">ss</author>`                   |
| `<url>`                 | 项目或文档网址（可选）                         | `<url type="website">https://github.com/ss/polygon_base</url>` |
| `<buildtool_depend>`    | 构建系统依赖（通常为 ament_cmake）             | `<buildtool_depend>ament_cmake</buildtool_depend>`             |
| `<build_depend>`        | 构建时依赖（编译需要）                         | `<build_depend>pluginlib</build_depend>`                       |
| `<exec_depend>`         | 运行时依赖（执行时需要）                        | `<exec_depend>rclcpp</exec_depend>`                            |
| `<test_depend>`         | 测试依赖                                | `<test_depend>ament_lint_auto</test_depend>`                   |
| `<doc_depend>`          | 文档生成依赖                              | `<doc_depend>doxygen</doc_depend>`                             |
| `<export>`              | 特殊信息导出（构建类型、插件描述等）                  | `<export><build_type>ament_cmake</build_type></export>`        |

## 依赖标签（dependency tags）

1. <buildtool_depend> 

    声明构建系统本身所依赖的包。这是最底层的依赖——没有它就无法运行 colcon build 去编译当前包。

    `<buildtool_depend>ament_cmake</buildtool_depend>`

    ROS 2 C++ 包：通常是 ament_cmake

    ROS 2 Python 包：通常是 ament_python

    如果你使用自定义构建系统，比如 cmake 或 ament_cmake_ros，这里也要换成对应的名字。

2. <build_depend>

    声明在编译阶段需要的依赖。这些依赖提供头文件、库、消息类型等，供 CMake 链接和编译使用。

    ```te
    <build_depend>pluginlib</build_depend>
    <build_depend>polygon_base</build_depend>
    ```

    通常与 find_package() 在 CMakeLists.txt 中对应。不安装这些依赖时，#include 头文件或 target_link_libraries() 会失败。

3. <exec_depend>

    声明程序运行阶段所需要的依赖。当你运行 ros2 run <package> <node> 时，这些包必须存在。

    ```te
    <exec_depend>pluginlib</exec_depend>
    <exec_depend>rclcpp</exec_depend>
    ```
    它不会影响编译，但会在运行时被 colcon / ament 记录到安装元数据。例如节点动态加载插件、调用消息类型时必须存在。

4. <depend>

    是 <build_depend> + <exec_depend> 的简写。
    表示该依赖包既在编译阶段需要，也在运行时需要。
    ```te
    <depend>std_msgs</depend>
    <depend>rclcpp</depend>
    ```
    相当于：
    ```te
    <build_depend>rclcpp</build_depend>
    <exec_depend>rclcpp</exec_depend>
    ```
5. <build_export_depend>

    声明编译后、导出给下游包使用的依赖。
    也就是说，如果别的包依赖你，而你内部又依赖某个库，它也必须能看到那个库。
    ```te
    <build_export_depend>pluginlib</build_export_depend>
    ```
    常出现在接口库包（如 polygon_base）中。

    保证下游包在 find_package(polygon_base) 时，也能间接拿到 pluginlib 的 include 路径。

6. <exec_export_depend>

导出运行时依赖给下游包使用。
用于让依赖你的包在运行时也能自动带上这些运行时依赖。

`<exec_export_depend>rclcpp</exec_export_depend>`
不常手写，通常由 ament 自动推断。

当你的包是“插件库”或“消息库”时可能需要。

7. <test_depend>

仅在测试阶段使用。
运行 colcon test 时才会安装和加载这些依赖。

```te
<test_depend>ament_lint_auto</test_depend>
<test_depend>ament_cmake_gtest</test_depend>
```

与 CMake 中的 if(BUILD_TESTING) 对应；

不影响正常 build 或 run。

8. <doc_depend>

    用于文档生成工具依赖。
    仅在生成 API 或说明文档时才需要。

    ```te
    <doc_depend>doxygen</doc_depend>
    <doc_depend>rosdoc_lite</doc_depend>
    ```

    不常见，但在大型项目或 CI 文档自动化时很有用。

9. <buildtool_export_depend>

    声明当前包导出的构建工具依赖。
    例如你的包提供新的 CMake 宏或 Python 构建工具。

    `<buildtool_export_depend>ament_cmake</buildtool_export_depend>`

    用于“构建系统插件包”，如 ament_cmake_python。

| 标签                      | 阶段       | 是否导出 | 常见示例              |
| ----------------------- | -------- | ---- | ----------------- |
| `<buildtool_depend>`    | 构建工具     | 否    | ament_cmake       |
| `<build_depend>`        | 编译时      | 否    | pluginlib, rclcpp |
| `<build_export_depend>` | 编译后提供给下游 | ✅    | pluginlib         |
| `<exec_depend>`         | 运行时      | 否    | rclcpp            |
| `<exec_export_depend>`  | 运行时提供给下游 | ✅    | rclcpp            |
| `<test_depend>`         | 测试时      | 否    | ament_lint_auto   |
| `<depend>`              | 编译+运行    | 否    | std_msgs          |

## Group dependency tags（依赖分组标签）

1. Group dependency tags 是用来声明或使用一个“依赖组（dependency group）”的标签。它让你：定义一组常用依赖的集合；让其它包引用这组依赖；避免在多个包里重复写一堆 <depend>。

2. 常见的 Group Dependency Tags

| 标签名                 | 作用                | 典型用途     |
| ------------------- | ----------------- | -------- |
| `<group_depend>`    | 声明当前包依赖于某个**依赖组** | “我需要整个组” |
| `<member_of_group>` | 声明当前包属于某个依赖组      | “我是某组成员” |

3. 语法规则

| 标签                                     | 含义            | 用法位置               |
| -------------------------------------- | ------------- | ------------------ |
| `<group_depend>`                       | 当前包依赖于某个依赖组   | 在 `package.xml` 根级 |
| `<member_of_group>`                    | 当前包属于某个依赖组    | 在 `package.xml` 根级 |
| `<export>`                             | 可与 group 标签共存 | 用于导出构建类型或插件信息      |
| `<group_depend>` 与 `<member_of_group>` | 名称必须一致        | 否则不会被解析为同一组        |
