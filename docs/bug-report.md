# Linux 桌面版在 Clash 系统代理下无法回复，CLI 正常

已于 2026-10-09 提交至官方：[openai/codex #52378](https://github.com/openai/codex/issues/52378)。以下记录 2026-10-08 的验证情况；桌面版本来自安装包元数据，没有声称已经验证后续版本。

## 环境

- 系统：Ubuntu 24.04.5 LTS，原生 Linux。
- 桌面程序：ChatGPT 26.930.61225（安装包元数据），使用 Codex 本地桌面对话。
- 桌面自带 Codex：0.160.1。
- 代理：Clash Verge，HTTP/mixed 端口为 `127.0.0.1:7897`。
- 订阅类型：Pro（用户确认）。
- 平台详细信息：`Linux 7.0.0-34-generic x86_64 x86_64`（2026-10-09 读取 `uname -mprs`）。

## 实际情况

我这边 CLI 在 Clash 系统代理下可以正常使用，但桌面版关掉 TUN 后一直不输出；开 TUN 才能收到回复。有时从原版菜单启动还会出现登录界面。因为还需要使用内网 VPN，不希望一直开着 TUN。

## 复现步骤

1. 开启 Clash Verge 系统代理，关闭 TUN。
2. 完全退出桌面程序，再从原版菜单启动。
3. 在桌面的本地 Codex 对话里发送一条消息，观察是否一直等待、没有回复。
4. 在同一网络状态下检查 CLI；我这边 CLI 可以正常回复。
5. 打开 TUN 再试；我这边桌面对话恢复。
6. 完全退出桌面程序，关闭 TUN，再用本项目的启动器启动；我这边本地桌面对话也恢复。

## 预期行为

桌面版能够使用系统代理，或者提供明确的代理配置入口，不需要依赖 TUN 才能完成本地对话。

## 补充

目前有效的临时办法是同时给桌面程序传入大小写两套 `HTTP_PROXY`、`HTTPS_PROXY`、`ALL_PROXY`，并添加 Chromium 的 `--proxy-server=http://127.0.0.1:7897`。只设置系统代理似乎没有覆盖所有桌面网络请求。完整配置见项目中的 `chatgpt-clash`。

在 TUN 关闭时，命令重启后的真实本地桌面对话已成功，后台 TCP 连接经过 `127.0.0.1:7897`。但独立菜单冷启动登录状态尚未完整验证，云端 durable 连接仍有 `ETIMEDOUT` / `1006`；这两部分不声称已经修复，也不能由临时办法有效就断定准确根因。

完整配置：[chatgpt-clash-linux](https://github.com/ZXCYFR/chatgpt-clash-linux)。相关讨论：[Linux CLI 代理问题](https://github.com/openai/codex/issues/16079)、[macOS 后台代理问题](https://github.com/openai/codex/issues/49921)、[macOS 界面代理问题](https://github.com/openai/codex/issues/34955)、[durable 连接问题](https://github.com/openai/codex/issues/49829)。它们涉及不同平台或网络路径，本报告补充原生 Linux 的本地桌面对话对照结果。

## 官方反馈

报告链接：[openai/codex #52378](https://github.com/openai/codex/issues/52378)。这里保存复现说明，后续讨论与处理状态以官方 Issue 为准。

新反馈入口为 [Codex App Bug 表单](https://github.com/openai/codex/issues/new?template=1-codex-app.yml)。官方模板要求先检查重复问题。此次只附公开项目和必要的错误信息，没有上传账号文件、Cookie 或整个日志目录。
