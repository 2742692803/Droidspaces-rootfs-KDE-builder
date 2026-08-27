#!/usr/bin/env bash
set -euo pipefail

source /etc/os-release

install_apt() {
    local -a packages=(
        dbus-x11 dbus-user-session fonts-noto-cjk fonts-noto-color-emoji
        gnome-shell gnome-session gnome-control-center gnome-settings-daemon mutter
        gnome-terminal nautilus gnome-system-monitor gnome-tweaks
        gnome-keyring libpam-gnome-keyring polkitd upower
        pipewire pipewire-pulse wireplumber pulseaudio-utils
        mesa-utils vulkan-tools wayland-utils xwayland xdg-user-dirs xdg-desktop-portal-gnome
        file-roller evince eog gstreamer1.0-plugins-base gstreamer1.0-plugins-good
        libcanberra-pulse sound-theme-freedesktop
    )

    sed -i 's|^path-exclude=/usr/share/locale/\*/LC_MESSAGES/\*.mo|#&|' \
        /etc/dpkg/dpkg.cfg.d/excludes 2>/dev/null || true

    case "$ID:$VERSION_ID" in
        debian:13) ;;
        ubuntu:26.04)
            packages+=(language-pack-gnome-zh-hans language-pack-zh-hans)
            ;;
        *)
            echo "GNOME 不支持当前系统：$ID $VERSION_ID" >&2
            return 1
            ;;
    esac

    apt-get install -y --no-install-recommends "${packages[@]}"
}

case "$ID" in
    debian|ubuntu) install_apt ;;
    *) echo "GNOME 不支持当前发行版：$ID" >&2; exit 1 ;;
esac
