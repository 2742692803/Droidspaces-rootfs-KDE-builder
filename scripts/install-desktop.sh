#!/usr/bin/env bash
set -euo pipefail

desktop="${1:-}"
profile_dir="${DROIDSPACES_DESKTOP_PROFILE_DIR:-/usr/local/lib/droidspaces/desktops}"

case "$desktop" in
    none)
        echo "--> 桌面配置：none"
        exit 0
        ;;
esac

if [[ ! "$desktop" =~ ^[a-z][a-z0-9-]*$ ]]; then
    echo "不支持的桌面配置：$desktop" >&2
    exit 1
fi

profile="$profile_dir/$desktop.sh"
if [[ ! -x "$profile" ]]; then
    echo "桌面配置脚本不存在或不可执行：$profile" >&2
    exit 1
fi

echo "--> 正在安装桌面配置：$desktop"
exec "$profile"
