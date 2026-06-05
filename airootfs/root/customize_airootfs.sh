#!/usr/bin/env bash
set -euo pipefail

# Suppress the vpkg shim tip for all pacman/flatpak/yay calls in this script
export _VPKG_INTERNAL=1

# ── Live user ─────────────────────────────────────────────────────────────────
if ! id liveuser &>/dev/null; then
    useradd -m -G wheel,audio,video,storage,optical,network -s /bin/bash liveuser
fi
passwd -d liveuser

echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/liveuser
chmod 440 /etc/sudoers.d/liveuser

passwd -d root

# ── System services ───────────────────────────────────────────────────────────
systemctl set-default graphical.target
systemctl enable sddm.service
systemctl enable NetworkManager.service
systemctl enable bluetooth.service
systemctl enable cups.service
systemctl mask systemd-firstboot.service

# ── Build AUR packages and install Calla DE ───────────────────────────────────
# Requires internet access during ISO build. Creates a temporary build user
# because makepkg refuses to run as root.
BUILDUSER="vertexbuild"
BUILD_HOME="/home/$BUILDUSER"

if ! id "$BUILDUSER" &>/dev/null; then
    useradd -m -s /bin/bash "$BUILDUSER"
fi
echo "$BUILDUSER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vertexbuild

# Pass _VPKG_INTERNAL so our yay/pacman/flatpak shims pass through transparently
_as_build() { sudo -u "$BUILDUSER" env _VPKG_INTERNAL=1 "$@"; }

# Ensure the chroot has a working mirrorlist — the airootfs overlay can leave
# it empty, which prevents pacman from reaching repos during AUR builds.
if ! grep -q '^Server' /etc/pacman.d/mirrorlist 2>/dev/null; then
    echo 'Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch' \
        > /etc/pacman.d/mirrorlist
fi

# Initialize the pacman keyring — required before pacman can verify signatures.
# Must happen before any yay/pacman install calls.
pacman-key --init
pacman-key --populate archlinux

pacman -Syy --noconfirm

# archiso 88 doesn't fully mount /proc when running customize_airootfs.sh, so
# pacman can't determine mount points and falsely fails the disk-space check.
# Disable it for the build, restore it after.
sed -i 's/^CheckSpace/#CheckSpace/' /etc/pacman.conf

# Bootstrap yay-bin (skip if already installed from a previous retry)
# Check the real binary path — our /usr/local/bin/yay shim would fool command -v
if [ ! -x /usr/bin/yay ]; then
    rm -rf "$BUILD_HOME/yay-bin"
    _as_build git clone https://aur.archlinux.org/yay-bin.git "$BUILD_HOME/yay-bin"
    (cd "$BUILD_HOME/yay-bin" && _as_build makepkg -si --noconfirm --needed)
fi

# AUR dependencies required by Calla
# awesome-git must come before Calla (Calla's PKGBUILD depends on it)
_as_build /usr/bin/yay -S --noconfirm --needed \
    awesome-git \
    noto-color-emoji-fontconfig \
    lua-pam-git

# Clone and install Calla from its PKGBUILD
rm -rf "$BUILD_HOME/Calla"
_as_build git clone https://github.com/Vertex-Linux/Calla.git "$BUILD_HOME/Calla"
cd "$BUILD_HOME/Calla" && _as_build makepkg -si --noconfirm && cd /

# ── Install SilentSDDM theme ──────────────────────────────────────────────────
git clone -b main --depth=1 https://github.com/uiriansan/SilentSDDM \
    "$BUILD_HOME/SilentSDDM"
# Run install.sh from inside the repo directory; we're already root in the chroot
(cd "$BUILD_HOME/SilentSDDM" && bash ./install.sh)
rm -rf "$BUILD_HOME/SilentSDDM"

# Remove bare awesome session entry — only Calla should appear in the login screen
rm -f /usr/share/xsessions/awesome.desktop

# ── Fix polkit-gnome agent path ───────────────────────────────────────────────
# Calla's rc.lua starts the polkit agent at the old Debian/Ubuntu path.
# On Arch the binary is at /usr/lib/polkit-gnome/; create a compat symlink.
mkdir -p /usr/lib/policykit-1-gnome
ln -sf /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 \
    /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1
echo "polkit-gnome compat symlink created"

# Cleanup temporary build user
userdel -r "$BUILDUSER" 2>/dev/null || true
rm -f /etc/sudoers.d/vertexbuild

# Restore CheckSpace so the installed system has a normal pacman.conf
sed -i 's/^#CheckSpace/CheckSpace/' /etc/pacman.conf
