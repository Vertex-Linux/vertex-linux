#!/usr/bin/env bash
set -euo pipefail

# Create live user with no password
useradd -m -G wheel,audio,video,storage,optical,network -s /bin/bash liveuser
passwd -d liveuser

# Allow wheel group to use sudo without password (for installer etc.)
echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/liveuser
chmod 440 /etc/sudoers.d/liveuser

# Set root password to empty (allows su without password in live session)
passwd -d root

# Enable graphical target
systemctl set-default graphical.target

# Enable display manager
systemctl enable sddm.service

# Enable NetworkManager
systemctl enable NetworkManager.service

# Enable bluetooth
systemctl enable bluetooth.service

# Enable cups (printing)
systemctl enable cups.service
