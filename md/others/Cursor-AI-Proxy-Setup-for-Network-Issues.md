# Cursor 编辑器配置本地代理解决 AI 联网失败方案

## 一、适用场景

当 Cursor 出现以下问题时，可以尝试配置本地代理：

1. Cursor AI 无法联网
2. Chat / Composer / Agent 请求失败
3. AI 回复一直加载但无响应
4. 出现网络超时、连接失败、代理错误
5. 系统代理已经开启，但 Cursor 仍然无法正常访问外网
6. 使用 Clash、V2Ray、Surge、Clash Verge、Clash Meta 等代理工具后，浏览器可以访问外网，但 Cursor AI 不能访问

本文方案主要通过修改 Cursor 用户配置文件 `settings.json`，让 Cursor 明确使用本地代理端口。

## 二、前置准备

在配置 Cursor 之前，需要先确认本地代理工具已经正常运行。

常见代理工具包括：

- Clash
- Clash Verge
- Clash Meta
- V2Ray
- V2RayN
- Surge
- Shadowrocket
- Quantumult X

需要确认以下信息：

1. 代理工具已经启动
2. 代理节点可正常访问外网
3. 代理工具提供了本地 HTTP 代理端口
4. Cursor 所在电脑可以访问该本地代理端口

常见本地代理地址示例：

```bash
http://127.0.0.1:7890
```

其中：

```bash
127.0.0.1
```

表示本机地址。

```bash
7890
```

表示代理工具提供的 HTTP 代理端口。

不同代理工具的端口可能不同，需要以你自己的代理工具设置为准。

## 三、确认代理端口类型

配置 Cursor 时，建议填写代理工具的 **HTTP 代理端口** 或 **Mixed 混合端口**。

不要误填 SOCKS5 端口。

常见端口示例：

```bash
Clash HTTP 端口：7890
Clash Mixed 混合端口：7890
Clash SOCKS5 端口：7891
V2RayN HTTP 端口：10809
V2RayN SOCKS5 端口：10808
Surge HTTP 端口：6152
```

如果你的代理工具中显示：

```bash
HTTP: 7890
SOCKS: 7891
Mixed: 7890
```

则 Cursor 中建议填写：

```json
"http.proxy": "http://127.0.0.1:7890"
```

不建议写成：

```json
"http.proxy": "http://127.0.0.1:7891"
```

也不建议写成：

```json
"http.proxy": "socks5://127.0.0.1:7891"
```

## 四、先测试本地代理是否可用

在配置 Cursor 之前，建议先用终端测试代理端口是否可用。

## 1. macOS / Linux 测试命令

```bash
curl -I --proxy http://127.0.0.1:7890 https://www.google.com
```

或者测试 Cursor 相关访问：

```bash
curl -I --proxy http://127.0.0.1:7890 https://api2.cursor.sh
```

## 2. Windows PowerShell 测试命令

```powershell
curl.exe -I --proxy http://127.0.0.1:7890 https://www.google.com
```

或者：

```powershell
curl.exe -I --proxy http://127.0.0.1:7890 https://api2.cursor.sh
```

如果能看到类似结果，说明代理端口基本可用：

```bash
HTTP/1.1 200 Connection established
```

或：

```bash
HTTP/2 200
```

如果出现以下错误，说明代理端口可能不正确或代理工具没有正常运行：

```bash
Connection refused
```

```bash
Could not connect to proxy
```

```bash
Failed to connect to 127.0.0.1 port 7890
```

此时需要先检查代理工具端口，而不是直接修改 Cursor 配置。

## 五、打开 Cursor 用户配置 JSON 文件

1. 打开 Cursor 编辑器。

2. 使用快捷键打开命令面板：

```bash
Command / Ctrl + Shift + P
```

macOS 使用：

```bash
Command + Shift + P
```

Windows / Linux 使用：

```bash
Ctrl + Shift + P
```

3. 搜索：

```bash
settings.json
```

4. 选择：

```bash
Preferences: Open User Settings (JSON)
```

如果是中文界面，选择：

```bash
首选项: 打开用户设置(JSON)
```

打开后会看到 Cursor 的用户配置文件。

文件名通常是：

```bash
settings.json
```

## 六、配置方案一：普通推荐版

建议优先尝试这个版本。

该方案会让 Cursor 使用本地代理，同时保留本地地址不走代理，比较适合日常开发。

```json
{
  "http.proxy": "http://127.0.0.1:7890",
  "http.proxySupport": "override",
  "http.noProxy": [
    "localhost",
    "127.0.0.1",
    "::1"
  ]
}
```

如果你的代理端口不是 `7890`，需要把端口改成你自己的代理端口。

例如你的 HTTP 代理端口是 `10809`，则写成：

```json
{
  "http.proxy": "http://127.0.0.1:10809",
  "http.proxySupport": "override",
  "http.noProxy": [
    "localhost",
    "127.0.0.1",
    "::1"
  ]
}
```

## 七、配置方案二：强制兜底版

如果普通推荐版配置后，Cursor AI 仍然无法联网，可以尝试强制兜底版。

```json
{
  "http.proxy": "http://127.0.0.1:7890",
  "http.proxySupport": "override",
  "http.proxyStrictSSL": false,
  "http.noProxy": [],
  "cursor.general.disableHttp2": true
}
```

该方案适合以下情况：

1. Cursor AI 仍然无法联网
2. 出现 SSL 证书校验错误
3. 出现 HTTP/2 相关错误
4. 代理连接不稳定
5. 请求经常超时
6. Composer / Agent 请求一直卡住

注意：

```json
"http.proxyStrictSSL": false
```

会关闭严格 SSL 证书校验。它可以规避部分代理证书问题，但不建议作为长期默认配置。

如果没有 SSL 证书错误，建议优先使用普通推荐版。

如果开启下面配置后，Cursor 的某些 Agent 功能出现异常，可以尝试改回 `false` 或删除该项：

```json
"cursor.general.disableHttp2": true
```

## 八、已有配置时如何合并

如果你的 `settings.json` 是空的，可以直接使用完整配置。

例如：

```json
{
  "http.proxy": "http://127.0.0.1:7890",
  "http.proxySupport": "override",
  "http.noProxy": [
    "localhost",
    "127.0.0.1",
    "::1"
  ]
}
```

如果你的 `settings.json` 已经有其他配置，例如：

```json
{
  "editor.fontSize": 14,
  "editor.tabSize": 4
}
```

不要再新建一组 `{}`。

应该把代理配置合并进去：

```json
{
  "editor.fontSize": 14,
  "editor.tabSize": 4,
  "http.proxy": "http://127.0.0.1:7890",
  "http.proxySupport": "override",
  "http.noProxy": [
    "localhost",
    "127.0.0.1",
    "::1"
  ]
}
```

如果你要使用强制兜底版，则合并为：

```json
{
  "editor.fontSize": 14,
  "editor.tabSize": 4,
  "http.proxy": "http://127.0.0.1:7890",
  "http.proxySupport": "override",
  "http.proxyStrictSSL": false,
  "http.noProxy": [],
  "cursor.general.disableHttp2": true
}
```

## 九、JSON 语法注意事项

`settings.json` 必须符合 JSON 语法。

常见错误如下。

## 1. 少写逗号

错误写法：

```json
{
  "editor.fontSize": 14
  "http.proxy": "http://127.0.0.1:7890"
}
```

正确写法：

```json
{
  "editor.fontSize": 14,
  "http.proxy": "http://127.0.0.1:7890"
}
```

## 2. 最后一项后面多写逗号

错误写法：

```json
{
  "http.proxy": "http://127.0.0.1:7890",
}
```

正确写法：

```json
{
  "http.proxy": "http://127.0.0.1:7890"
}
```

## 3. 使用中文引号

错误写法：

```json
{
  “http.proxy”: “http://127.0.0.1:7890”
}
```

正确写法：

```json
{
  "http.proxy": "http://127.0.0.1:7890"
}
```

## 4. 重复写外层大括号

错误写法：

```json
{
  "editor.fontSize": 14
}

{
  "http.proxy": "http://127.0.0.1:7890"
}
```

正确写法：

```json
{
  "editor.fontSize": 14,
  "http.proxy": "http://127.0.0.1:7890"
}
```

## 十、配置项说明

## 1. http.proxy

```json
"http.proxy": "http://127.0.0.1:7890"
```

作用：

指定 Cursor 使用本地 HTTP 代理。

其中：

```bash
127.0.0.1
```

表示本机。

```bash
7890
```

表示代理工具的 HTTP 代理端口。

如果你的代理工具端口不是 `7890`，需要替换为自己的端口。

例如：

```json
"http.proxy": "http://127.0.0.1:10809"
```

## 2. http.proxySupport

```json
"http.proxySupport": "override"
```

作用：

让 Cursor 优先使用手动配置的代理，覆盖默认代理策略。

一般建议保留该配置。

## 3. http.proxyStrictSSL

```json
"http.proxyStrictSSL": false
```

作用：

关闭严格 SSL 证书校验。

适用情况：

1. 出现证书校验失败
2. 出现 `certificate verify failed`
3. 出现 `unable to verify the first certificate`
4. 公司网络、校园网、代理工具对 HTTPS 证书进行了中间处理

注意：

该配置不是必须项。

如果普通配置可以正常使用，不建议一开始就关闭严格 SSL 校验。

## 4. http.noProxy

### 保留本地地址不走代理

```json
"http.noProxy": [
  "localhost",
  "127.0.0.1",
  "::1"
]
```

适合日常开发。

这样可以避免本地服务被代理影响，例如：

```bash
http://localhost:3000
```

```bash
http://127.0.0.1:8000
```

### 所有请求都走代理

```json
"http.noProxy": []
```

适合 Cursor AI 无法联网时的强制兜底方案。

但它可能影响本地开发服务，因此不建议作为普通默认配置。

## 5. cursor.general.disableHttp2

```json
"cursor.general.disableHttp2": true
```

作用：

禁用 HTTP/2，让 Cursor 网络请求回退到 HTTP/1.1。

适用情况：

1. 代理环境下 Cursor AI 请求超时
2. 连接不稳定
3. 出现 HTTP/2 相关错误
4. 使用 VPN、公司网络、校园网时 AI 请求失败

注意：

该项属于兼容性修复配置，不一定所有环境都需要。

如果开启后 Cursor Agent、Composer 或其他功能出现异常，可以尝试删除该项，或改为：

```json
"cursor.general.disableHttp2": false
```

## 十一、保存并重启 Cursor

配置完成后，保存文件：

```bash
Command / Ctrl + S
```

保存后，建议完全重启 Cursor。

macOS：

```bash
Command + Q
```

然后重新打开 Cursor。

Windows / Linux：

关闭所有 Cursor 窗口，然后重新打开。

如果只是关闭当前窗口，Cursor 后台进程可能仍然存在，配置不一定完全生效。

## 十二、验证 Cursor 是否已经走代理

## 1. 直接测试 Cursor AI

打开 Cursor，尝试使用：

1. Chat
2. Composer
3. Agent
4. Inline Edit
5. Codebase 问答

如果可以正常返回结果，说明代理配置基本生效。

## 2. 查看开发者工具错误

如果仍然失败，可以打开开发者工具排查。

快捷键打开命令面板：

```bash
Command / Ctrl + Shift + P
```

搜索：

```bash
Developer: Toggle Developer Tools
```

打开后查看：

```bash
Console
```

或：

```bash
Network
```

常见错误包括：

```bash
ERR_PROXY_CONNECTION_FAILED
```

```bash
ERR_CONNECTION_TIMED_OUT
```

```bash
CERTIFICATE_VERIFY_FAILED
```

```bash
ERR_HTTP2_PROTOCOL_ERROR
```

```bash
fetch failed
```

不同错误对应不同处理方式：

| 错误信息 | 可能原因 | 处理方式 |
|---|---|---|
| `ERR_PROXY_CONNECTION_FAILED` | 代理端口错误或代理工具未启动 | 检查代理端口和代理工具状态 |
| `ERR_CONNECTION_TIMED_OUT` | 节点不可用或规则未命中 | 切换节点或改为全局模式 |
| `CERTIFICATE_VERIFY_FAILED` | SSL 证书校验失败 | 尝试 `http.proxyStrictSSL: false` |
| `ERR_HTTP2_PROTOCOL_ERROR` | HTTP/2 兼容性问题 | 尝试 `cursor.general.disableHttp2: true` |
| `fetch failed` | 网络请求失败，原因较泛 | 检查代理、DNS、证书和 HTTP/2 |

## 十三、代理模式建议

代理工具中一般有以下模式：

```bash
全局模式
规则模式
直连模式
```

建议：

1. 优先使用规则模式
2. 如果 Cursor AI 无法联网，临时切换到全局模式测试
3. 不建议使用直连模式
4. 不建议使用仅国内分流且未覆盖 Cursor 相关域名的规则

更准确地说：

Cursor 不一定必须使用全局模式。

关键是 Cursor AI 相关请求必须能够走代理。

如果规则模式配置不完善，Cursor 相关请求可能仍然直连，导致 AI 联网失败。

## 十四、命令行启动兜底方案

如果修改 `settings.json` 后仍然无效，可以尝试通过命令行参数启动 Cursor。

## 1. macOS / Linux

```bash
cursor --proxy-server=http://127.0.0.1:7890
```

如果需要禁用 HTTP/2：

```bash
cursor --disable-http2
```

也可以组合使用：

```bash
cursor --proxy-server=http://127.0.0.1:7890 --disable-http2
```

## 2. Windows PowerShell

```powershell
cursor --proxy-server=http://127.0.0.1:7890
```

如果命令无法识别，需要确认 Cursor 是否已经加入系统环境变量 `PATH`。

## 十五、常见问题排查

## 1. 浏览器可以访问外网，但 Cursor AI 不能访问

可能原因：

1. Cursor 没有读取系统代理
2. Cursor AI 请求没有命中代理规则
3. 代理工具规则没有覆盖 Cursor 相关域名
4. Cursor 使用 HTTP/2 时代理不稳定
5. SSL 证书校验失败

解决方式：

1. 在 `settings.json` 中手动配置 `http.proxy`
2. 设置 `http.proxySupport: "override"`
3. 临时切换代理工具为全局模式
4. 尝试 `cursor.general.disableHttp2: true`
5. 如果是证书问题，再尝试 `http.proxyStrictSSL: false`

## 2. 配置后 Cursor 仍然不能联网

按下面顺序排查：

1. 确认代理工具已启动
2. 确认代理节点可用
3. 确认代理端口是 HTTP 端口
4. 使用 `curl` 测试代理端口
5. 检查 `settings.json` 是否有 JSON 语法错误
6. 完全退出 Cursor 后重新打开
7. 尝试强制兜底版配置
8. 打开开发者工具查看具体错误

## 3. 配置后本地项目访问异常

例如访问以下地址异常：

```bash
http://localhost:3000
```

```bash
http://127.0.0.1:8000
```

可能是因为使用了：

```json
"http.noProxy": []
```

这会让本地请求也走代理。

可以改成：

```json
"http.noProxy": [
  "localhost",
  "127.0.0.1",
  "::1"
]
```

## 4. 出现 SSL 证书错误

如果错误中包含：

```bash
certificate
```

```bash
SSL
```

```bash
unable to verify
```

可以尝试加入：

```json
"http.proxyStrictSSL": false
```

完整示例：

```json
{
  "http.proxy": "http://127.0.0.1:7890",
  "http.proxySupport": "override",
  "http.proxyStrictSSL": false,
  "http.noProxy": [
    "localhost",
    "127.0.0.1",
    "::1"
  ]
}
```

如果仍然失败，再尝试强制兜底版：

```json
{
  "http.proxy": "http://127.0.0.1:7890",
  "http.proxySupport": "override",
  "http.proxyStrictSSL": false,
  "http.noProxy": [],
  "cursor.general.disableHttp2": true
}
```

## 5. 出现 HTTP/2 相关错误

如果开发者工具中出现：

```bash
ERR_HTTP2_PROTOCOL_ERROR
```

或 Cursor AI 请求长时间卡住，可以尝试：

```json
"cursor.general.disableHttp2": true
```

完整配置：

```json
{
  "http.proxy": "http://127.0.0.1:7890",
  "http.proxySupport": "override",
  "http.noProxy": [
    "localhost",
    "127.0.0.1",
    "::1"
  ],
  "cursor.general.disableHttp2": true
}
```

如果开启后 Cursor 某些功能异常，可以删除该项或改为：

```json
"cursor.general.disableHttp2": false
```

## 6. 使用规则模式时仍然失败

可以临时把代理工具切换为：

```bash
全局模式
```

然后重新测试 Cursor AI。

如果全局模式可用，规则模式不可用，说明代理规则没有覆盖 Cursor 相关请求。

此时可以：

1. 继续使用全局模式
2. 修改代理规则
3. 对 Cursor 相关域名添加代理规则

## 十六、推荐最终使用流程

建议按照下面顺序操作：

1. 启动代理工具
2. 确认 HTTP 代理端口
3. 使用 `curl` 测试代理端口
4. 打开 Cursor 的 `settings.json`
5. 先使用普通推荐版配置
6. 保存并完全重启 Cursor
7. 测试 Cursor AI
8. 如果失败，再使用强制兜底版配置
9. 如果仍然失败，打开开发者工具查看错误

## 十七、推荐配置汇总

## 1. 普通推荐版

优先使用：

```json
{
  "http.proxy": "http://127.0.0.1:7890",
  "http.proxySupport": "override",
  "http.noProxy": [
    "localhost",
    "127.0.0.1",
    "::1"
  ]
}
```

## 2. 强制兜底版

Cursor AI 仍然无法联网时使用：

```json
{
  "http.proxy": "http://127.0.0.1:7890",
  "http.proxySupport": "override",
  "http.proxyStrictSSL": false,
  "http.noProxy": [],
  "cursor.general.disableHttp2": true
}
```

## 3. SSL 问题专用版

出现证书校验错误时使用：

```json
{
  "http.proxy": "http://127.0.0.1:7890",
  "http.proxySupport": "override",
  "http.proxyStrictSSL": false,
  "http.noProxy": [
    "localhost",
    "127.0.0.1",
    "::1"
  ]
}
```

## 4. HTTP/2 问题专用版

出现 HTTP/2 协议错误或代理连接不稳定时使用：

```json
{
  "http.proxy": "http://127.0.0.1:7890",
  "http.proxySupport": "override",
  "http.noProxy": [
    "localhost",
    "127.0.0.1",
    "::1"
  ],
  "cursor.general.disableHttp2": true
}
```

## 十八、恢复默认配置

如果配置后出现异常，可以删除以下配置项：

```json
"http.proxy": "http://127.0.0.1:7890",
"http.proxySupport": "override",
"http.proxyStrictSSL": false,
"http.noProxy": [],
"cursor.general.disableHttp2": true
```

如果你的配置是普通推荐版，则删除：

```json
"http.proxy": "http://127.0.0.1:7890",
"http.proxySupport": "override",
"http.noProxy": [
  "localhost",
  "127.0.0.1",
  "::1"
]
```

删除后保存 `settings.json`，然后完全重启 Cursor。

## 十九、最终建议

建议优先使用普通推荐版：

```json
{
  "http.proxy": "http://127.0.0.1:7890",
  "http.proxySupport": "override",
  "http.noProxy": [
    "localhost",
    "127.0.0.1",
    "::1"
  ]
}
```

如果 Cursor AI 仍然无法联网，再使用强制兜底版：

```json
{
  "http.proxy": "http://127.0.0.1:7890",
  "http.proxySupport": "override",
  "http.proxyStrictSSL": false,
  "http.noProxy": [],
  "cursor.general.disableHttp2": true
}
```

其中 `7890` 需要替换为你自己代理工具的 HTTP 代理端口。

如果不确定端口是否正确，先用下面命令测试：

```bash
curl -I --proxy http://127.0.0.1:7890 https://www.google.com
```

确认代理端口可用后，再修改 Cursor 配置。