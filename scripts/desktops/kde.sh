#!/usr/bin/env bash
set -euo pipefail

source /etc/os-release

install_apt() {
    sed -i 's|^path-exclude=/usr/share/locale/\*/LC_MESSAGES/\*.mo|#&|' \
        /etc/dpkg/dpkg.cfg.d/excludes 2>/dev/null || true

    case "$ID:$VERSION_ID" in
        debian:13)
            apt-get install -y --no-install-recommends \
                dbus-x11 x11-xserver-utils fonts-noto-cjk fonts-noto-color-emoji kde-plasma-desktop pipewire pipewire-pulse wireplumber powerdevil kscreen plasma-pa ark kwin-x11 upower konsole \
                dolphin kate kinfocenter mesa-utils pulseaudio-utils vulkan-tools desktop-base dbus-user-session aha clinfo dmidecode libdisplay-info-bin wayland-utils xserver-xorg \
                kfind plasma-systemmonitor filelight glmark2 vkmark systemsettings kde-config-screenlocker kio-extras xdg-user-dirs dolphin-plugins ffmpegthumbs kdegraphics-thumbnailers \
                kimageformat6-plugins webext-plasma-browser-integration libcanberra-pulse gstreamer1.0-plugins-base gstreamer1.0-plugins-good sound-theme-freedesktop
            ;;
        ubuntu:24.04)
            apt-get install -y --no-install-recommends \
                dbus-x11 x11-xserver-utils fonts-noto-cjk fonts-noto-color-emoji kde-plasma-desktop kubuntu-settings-desktop kubuntu-wallpapers \
                pipewire pipewire-pulse wireplumber powerdevil kscreen plasma-pa ark kwin-x11 upower konsole \
                dolphin kate kinfocenter mesa-utils pulseaudio-utils vulkan-tools dbus-user-session aha clinfo dmidecode libdisplay-info-bin wayland-utils xserver-xorg \
                kfind plasma-systemmonitor filelight glmark2 systemsettings kde-config-screenlocker kio-extras xdg-user-dirs dolphin-plugins ffmpegthumbs kdegraphics-thumbnailers \
                kimageformat-plugins plasma-browser-integration libcanberra-pulse gstreamer1.0-plugins-base gstreamer1.0-plugins-good sound-theme-freedesktop \
                polkit-kde-agent-1 libpam-systemd libpam-modules libpam-kwallet5 language-pack-kde-zh-hans language-pack-zh-hans qt6-translations-l10n
            ;;
        ubuntu:25.10|ubuntu:26.04)
            apt-get install -y --no-install-recommends \
                dbus-x11 x11-xserver-utils fonts-noto-cjk fonts-noto-color-emoji kde-plasma-desktop kubuntu-settings-desktop kubuntu-wallpapers \
                pipewire pipewire-pulse wireplumber powerdevil kscreen plasma-pa ark kwin-x11 upower konsole \
                dolphin kate kinfocenter mesa-utils pulseaudio-utils vulkan-tools dbus-user-session aha clinfo dmidecode libdisplay-info-bin wayland-utils xserver-xorg \
                kfind plasma-systemmonitor filelight glmark2 vkmark systemsettings kde-config-screenlocker kio-extras xdg-user-dirs dolphin-plugins ffmpegthumbs kdegraphics-thumbnailers \
                kimageformat6-plugins plasma-browser-integration libcanberra-pulse gstreamer1.0-plugins-base gstreamer1.0-plugins-good sound-theme-freedesktop \
                polkit-kde-agent-1 libpam-systemd libpam-modules libpam-kwallet5 plasma-session-x11 language-pack-kde-zh-hans language-pack-zh-hans qt6-translations-l10n
            ;;
        *)
            echo "KDE is not supported on $ID $VERSION_ID" >&2
            return 1
            ;;
    esac
}

install_fedora() {
    case "$VERSION_ID" in
        43|44) ;;
        *) echo "KDE is not supported on Fedora $VERSION_ID" >&2; return 1 ;;
    esac

    echo '%_install_langs all' > /etc/rpm/macros.image-language-conf
    dnf install -y --setopt=install_weak_deps=False \
        dbus-x11 xrandr xset xrdb xhost google-noto-cjk-fonts google-noto-emoji-color-fonts plasma-desktop pipewire pipewire-pulseaudio wireplumber powerdevil kscreen plasma-pa ark kwin upower konsole \
        dolphin kate kinfocenter glx-utils pulseaudio-utils vulkan-tools fedora-logos aha clinfo dmidecode libdisplay-info wayland-utils xorg-x11-server-Xorg \
        kfind plasma-systemmonitor filelight glmark2 vkmark systemsettings kscreenlocker kio-extras xdg-user-dirs dolphin-plugins ffmpegthumbs kdegraphics-thumbnailers \
        kf6-kimageformats plasma-browser-integration libcanberra-gtk3 gstreamer1-plugins-base gstreamer1-plugins-good sound-theme-freedesktop plasma-milou plasma-workspace plasma-workspace-x11 kwin-x11
}

install_arch() {
    pacman -S --noconfirm --needed \
        xorg-xrandr noto-fonts-cjk noto-fonts-emoji plasma-desktop pipewire pipewire-pulse wireplumber powerdevil kscreen plasma-pa ark kwin kwin-x11 upower konsole \
        dolphin kate kinfocenter mesa-utils libpulse vulkan-tools aha clinfo dmidecode wayland-utils xorg-server \
        kfind plasma-systemmonitor filelight glmark2 vkmark systemsettings kscreenlocker kio-extras xdg-user-dirs dolphin-plugins ffmpegthumbs kdegraphics-thumbnailers \
        kimageformats plasma-browser-integration libcanberra gstreamer gst-plugins-base gst-plugins-good sound-theme-freedesktop

    [[ ! -e /usr/lib/xdg-desktop-portal ]] || mv /usr/lib/xdg-desktop-portal /usr/lib/xdg-desktop-portal.bak
    [[ ! -e /usr/lib/xdg-desktop-portal-kde ]] || mv /usr/lib/xdg-desktop-portal-kde /usr/lib/xdg-desktop-portal-kde.bak
}

case "$ID" in
    debian|ubuntu) install_apt ;;
    fedora) install_fedora ;;
    arch) install_arch ;;
    *) echo "Unsupported distribution for KDE: $ID" >&2; exit 1 ;;
esac
