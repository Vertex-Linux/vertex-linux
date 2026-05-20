#!/usr/bin/env bash
# Vertex Linux OS update script
# This file is fetched by Vertex Updater from:
#   https://raw.githubusercontent.com/arc360alt/vertex-linux/main/update.sh
# and run with root privileges on the installed system.
#
# Runs as root. The updater writes the new commit hash to /etc/vertex-release
# automatically after this script exits 0.
#
# Add your update steps below. Examples:
#   - Install new packages:     pacman -S --noconfirm some-package
#   - Remove old packages:      pacman -Rns --noconfirm old-package
#   - Place a config file:      curl -sL "$RAW_URL/path/to/file" -o /etc/...
#   - Enable a new service:     systemctl enable --now some.service

set -euo pipefail

echo "=== Vertex Linux OS Update ==="
echo "Date: $(date)"

# ── Add your update steps here ────────────────────────────────────────────────

# Example: update system packages as part of OS update
# pacman -Syu --noconfirm

echo "=== Update complete ==="
