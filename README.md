# ChatGPT Clash Linux

一个 Linux 桌面代理启动器，用来处理「Clash 系统代理下 CLI 正常，ChatGPT/Codex 桌面版却要开 TUN 才能聊天」的情况。

思路很简单：启动桌面程序时，同时传入代理环境变量和 Chromium 的 `--proxy-server` 参数。安装后会多一个 **ChatGPT Clash** 菜单入口，原版入口保留。

## 使用

下载本项目，先检查 `chatgpt-clash` 中的配置：

- 默认代理是 `http://127.0.0.1:7897`，按 Clash 的 HTTP/mixed 端口修改。
- 默认安装路径是 `/usr/bin/chatgpt`、`/usr/lib/chatgpt/ChatGPT` 和 `/usr/lib/chatgpt/resources/codex`，其他安装包需要调整。
- 默认本机地址和私有网段直连。有内网 VPN 时，按实际网段和内部域名调整 `NO_PROXY` 与 `--proxy-bypass-list`。

然后在本项目目录执行：

```sh
sh ./install.sh
```

不需要 sudo。安装器只写入当前用户的两个文件：

```text
~/.local/bin/chatgpt-clash
~/.local/share/applications/chatgpt-clash.desktop
```

如果同名文件内容不同，安装器会停止覆盖；相同内容可重复安装。

保存正在进行的任务，**完全退出旧的桌面进程**，再从应用菜单打开 **ChatGPT Clash**。已有进程可能接管启动请求，让新配置没有生效。两个入口共用应用数据。

也可以从终端重启：

```sh
~/.local/bin/chatgpt-clash --restart
```

这会关闭当前桌面主进程；正在运行的桌面任务可能被中断。后台启动后可以关闭终端，启动器不会额外追加日志文件。

需要 shell、`nohup`；重启功能还使用 `pgrep`、`readlink`、`tr`、`grep` 和 `zenity`。Ubuntu 通常已有这些工具。`desktop-file-validate` 和 `update-desktop-database` 可用于检查、刷新菜单，安装器会在它们存在时使用。

## 验证与限制

关闭 TUN、保留 Clash 系统代理，实际发送消息检查是否收到回复。再完全退出并从独立菜单重新打开，检查登录状态。有 VPN 时也检查内网服务是否可访问。

支持 `doctor` 的桌面后台还可以做网络检查：

```sh
~/.local/bin/chatgpt-clash --check-proxy
```

2026-10-08 的验证环境是 Ubuntu 24.04.5 LTS、ChatGPT 桌面 26.930.61225、自带 Codex 0.160.1、Clash 端口 7897。关闭 TUN 后，通过启动器命令重启的本地桌面对话已恢复，实际后台连接经过 Clash。

**独立菜单冷启动的登录稳定性尚未完整验证；云端 durable WebSocket 仍有超时。** 这是一个临时绕过方法，不能代表桌面版所有网络问题都已解决。

## 移除

完全退出桌面程序后，删除下面两个文件，再使用原版入口：

```sh
rm -- "$HOME/.local/bin/chatgpt-clash" \
  "$HOME/.local/share/applications/chatgpt-clash.desktop"
```

如已安装 `update-desktop-database`，执行 `update-desktop-database "$HOME/.local/share/applications"` 刷新菜单。

## 反馈

[复现步骤与官方 Bug 反馈草稿](docs/bug-report.md)记录了现象、对照结果和已知限制。也可以参考已发布的[桌面代理经验](https://github.com/openai/codex/issues/16079#issuecomment-6060269712)和[云端连接补充](https://github.com/openai/codex/issues/49829#issuecomment-6060300596)。

本项目只包含启动脚本、菜单模板和说明，不包含桌面应用本身。使用 MIT 许可证。
