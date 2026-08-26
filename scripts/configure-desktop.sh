#!/usr/bin/env bash
set -euo pipefail

desktop="${1:-}"
backend="${2:-}"
autostart="${3:-}"
username="${4:-}"
rootfs="${ROOTFS_DIR:-}"
templates="${START_TEMPLATES_DIR:-/tmp/droidspaces-start}"
# Droidspaces importers require /etc/droidspaces to remain a regular marker file.
config="$rootfs/etc/droidspaces-desktop.conf"

[[ "$desktop" =~ ^(none|[a-z][a-z0-9-]*)$ ]] || { echo "Invalid desktop: $desktop" >&2; exit 1; }
case "$backend" in x11|anland-wayland) ;; *) echo "Invalid display backend: $backend" >&2; exit 1 ;; esac
case "$autostart" in true|false) ;; *) echo "Invalid desktop autostart value: $autostart" >&2; exit 1 ;; esac
[[ -n "$username" ]] || { echo "A desktop username is required" >&2; exit 1; }

if [[ "$desktop" == none && "$backend" != x11 ]]; then
    echo "Unsupported desktop/backend pair: $desktop/$backend" >&2
    exit 1
fi
if [[ "$desktop" == kde-mobile && "$backend" != anland-wayland ]]; then
    echo "Unsupported desktop/backend pair: $desktop/$backend" >&2
    exit 1
fi

cat > "$config" <<EOF
DESKTOP=$desktop
DISPLAY_BACKEND=$backend
EOF
chmod 0644 "$config"

if [[ "$desktop" == kde ]]; then
    install -d -m 0755 "$rootfs/home/$username/.config"
    cat > "$rootfs/home/$username/.config/kwinrc" <<'EOF'
[Compositing]
Enabled=false
EOF
fi

if [[ -z "$rootfs" ]]; then
    chown -R "$username:$username" "/home/$username"
fi

if [[ "$desktop" == none ]]; then
    [[ "$autostart" == false ]] || { echo "Desktop autostart cannot be enabled for none" >&2; exit 1; }
    exit 0
fi

if [[ "$autostart" == true ]]; then
    install -Dm0644 "$templates/desktop-session.service" \
        "$rootfs/etc/systemd/system/desktop-session.service"
    install -d -m 0755 "$rootfs/etc/systemd/system/multi-user.target.wants"
    ln -sfn /etc/systemd/system/desktop-session.service \
        "$rootfs/etc/systemd/system/multi-user.target.wants/desktop-session.service"
fi
