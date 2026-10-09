#!/bin/sh
set -eu

# 无参数安装到当前用户；测试时可传入一个独立的暂存目录。
task_home=${1:-$HOME}
task_source_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
task_launcher="$task_home/.local/bin/chatgpt-clash"
task_desktop="$task_home/.local/share/applications/chatgpt-clash.desktop"
task_tmp=$(mktemp -d)
trap 'rm -rf "$task_tmp"' EXIT HUP INT TERM

sh -n "$task_source_dir/chatgpt-clash"
sed "s|@LAUNCHER@|$task_launcher|g" "$task_source_dir/chatgpt-clash.desktop.in" > "$task_tmp/chatgpt-clash.desktop"
if command -v desktop-file-validate >/dev/null 2>&1; then
    desktop-file-validate "$task_tmp/chatgpt-clash.desktop"
fi

# 可重复安装相同内容；遇到不同的现有文件时保留它们，先人工比较。
if [ -e "$task_launcher" ] && ! cmp -s "$task_source_dir/chatgpt-clash" "$task_launcher"; then
    printf '已有不同的启动器，停止覆盖：%s\n' "$task_launcher" >&2
    exit 1
fi
if [ -e "$task_desktop" ] && ! cmp -s "$task_tmp/chatgpt-clash.desktop" "$task_desktop"; then
    printf '已有不同的菜单入口，停止覆盖：%s\n' "$task_desktop" >&2
    exit 1
fi

mkdir -p "$task_home/.local/bin" "$task_home/.local/share/applications"
install -m 0755 "$task_source_dir/chatgpt-clash" "$task_launcher"
install -m 0644 "$task_tmp/chatgpt-clash.desktop" "$task_desktop"
if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$task_home/.local/share/applications"
fi
printf '已安装独立菜单入口：ChatGPT Clash\n启动器：%s\n' "$task_launcher"
