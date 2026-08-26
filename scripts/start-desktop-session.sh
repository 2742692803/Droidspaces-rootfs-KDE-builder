#!/usr/bin/env bash
set -euo pipefail

config="${DROIDSPACES_DESKTOP_CONFIG:-/etc/droidspaces-desktop.conf}"
[[ -r "$config" ]] || { echo "Desktop configuration is missing: $config" >&2; exit 1; }
source "$config"

case "${DESKTOP:-}:${DISPLAY_BACKEND:-}" in
    none:x11) command_line='exit 0' ;;
    kde:x11) command_line='export DISPLAY="${DISPLAY:-:5}"; exec startplasma-x11' ;;
    kde:anland-wayland) command_line='exec startplasma-wayland' ;;
    kde-mobile:anland-wayland) command_line='exec startplasmamobile' ;;
    *)
        echo "Unsupported desktop session: ${DESKTOP:-unset}/${DISPLAY_BACKEND:-unset}" >&2
        exit 1
        ;;
esac

if [[ "${DROIDSPACES_SESSION_DRY_RUN:-false}" == true ]]; then
    printf '%s\n' "$command_line"
    exit 0
fi

exec /bin/bash -lc "$command_line"
