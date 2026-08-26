#!/usr/bin/env bash
set -euo pipefail

desktop="${1:-}"
profile_dir="${DROIDSPACES_DESKTOP_PROFILE_DIR:-/usr/local/lib/droidspaces/desktops}"

case "$desktop" in
    none)
        echo "--> Desktop profile: none"
        exit 0
        ;;
esac

if [[ ! "$desktop" =~ ^[a-z][a-z0-9-]*$ ]]; then
    echo "Unsupported desktop profile: $desktop" >&2
    exit 1
fi

profile="$profile_dir/$desktop.sh"
if [[ ! -x "$profile" ]]; then
    echo "Desktop profile is missing or not executable: $profile" >&2
    exit 1
fi

echo "--> Installing desktop profile: $desktop"
exec "$profile"
