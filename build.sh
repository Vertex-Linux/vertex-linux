#!/usr/bin/env bash
# Build the Vertex Linux ISO.
# Run as root or with sudo.
set -euo pipefail

PROFILE_DIR="$(dirname "$(realpath "$0")")"
WORK_DIR="${PROFILE_DIR}/work"
OUT_DIR="${PROFILE_DIR}/out"
LOCAL_REPO="/var/cache/vertex-linux/local-repo"

if [[ $EUID -ne 0 ]]; then
    echo "Re-running with sudo..."
    exec sudo "$0" "$@"
fi

# ── Build calamares from AUR into a local pacman repo ────────────────────────
build_calamares() {
    mkdir -p "$LOCAL_REPO"

    if compgen -G "${LOCAL_REPO}/calamares-[0-9]*.pkg.tar.*" &>/dev/null; then
        echo "[calamares] Cached package found — skipping rebuild."
        return
    fi

    echo "[calamares] Building from AUR (first time only, ~10-20 min)..."

    pacman -S --needed --noconfirm \
        base-devel git cmake extra-cmake-modules \
        boost qt6-base qt6-declarative qt6-svg qt6-tools \
        kpmcore kconfig kcoreaddons ki18n kiconthemes \
        kparts kservice kwidgetsaddons yaml-cpp libpwquality

    local builduser="vertexbuild"
    useradd -m "$builduser" 2>/dev/null || true
    echo "$builduser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vertexbuild
    chmod 440 /etc/sudoers.d/vertexbuild

    local tmpdir
    tmpdir=$(mktemp -d)
    chown "$builduser:$builduser" "$tmpdir"

    sudo -u "$builduser" bash -c "
        set -e
        cd '$tmpdir'
        git clone https://aur.archlinux.org/calamares.git
        cd calamares
        MAKEFLAGS='-j\$(nproc)' makepkg -sr --noconfirm
    "

    find "$tmpdir" -name 'calamares-[0-9]*.pkg.tar.*' -exec cp {} "$LOCAL_REPO/" \;
    repo-add "${LOCAL_REPO}/vertex-local.db.tar.zst" "${LOCAL_REPO}"/calamares-[0-9]*.pkg.tar.*

    rm -rf "$tmpdir"
    rm -f /etc/sudoers.d/vertexbuild
    userdel -r "$builduser" 2>/dev/null || true

    echo "[calamares] Build complete."
}
build_calamares

# ── Unmount any bind mounts left in the work airootfs ────────────────────────
clear_work_mounts() {
    local airootfs="${WORK_DIR}/x86_64/airootfs"
    grep -F "$WORK_DIR" /proc/mounts \
        | awk '{print $2}' \
        | sed 's/\\040/ /g' \
        | sort -r \
        | while IFS= read -r mnt; do
            umount -lf "$mnt" 2>/dev/null || true
          done \
        || true
}

# Clean stale work directory.
if [[ -d "$WORK_DIR" ]]; then
    echo "[build] Unmounting any leftover bind mounts in work dir..."
    clear_work_mounts
    echo "[build] Cleaning stale work directory..."
    rm -rf "$WORK_DIR"
fi

mkdir -p "$WORK_DIR" "$OUT_DIR"

echo "──────────────────────────────────────────"
echo "  Building Vertex Linux ISO"
echo "  Profile : $PROFILE_DIR"
echo "  Work    : $WORK_DIR"
echo "  Output  : $OUT_DIR"
echo "──────────────────────────────────────────"

# Run mkarchiso. If it exits non-zero, it is often due to find(1) hitting
# stale /proc network-namespace entries during the cleanup step — a cosmetic
# error that does not affect the squashfs or ISO.  In that case, unmount the
# stale pseudo-filesystems and retry; mkarchiso will see its completion markers
# and skip straight to the remaining steps.
run_mkarchiso() {
    local sentinel
    sentinel=$(mktemp)

    set +e
    mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" "$PROFILE_DIR"
    local _rc=$?
    set -e

    local new_iso
    new_iso=$(find "$OUT_DIR" -maxdepth 1 -name '*.iso' -newer "$sentinel" | head -1)
    rm -f "$sentinel"

    if [[ -n "$new_iso" ]]; then
        echo ""
        echo "Build complete!"
        echo "ISO: $new_iso"
        ls -lh "$new_iso"
        return 0
    fi

    return "$_rc"
}

if ! run_mkarchiso; then
    echo "[build] First attempt failed — clearing stale pseudo-mounts and retrying..."
    clear_work_mounts

    if ! run_mkarchiso; then
        echo ""
        echo "ERROR: mkarchiso failed on retry. Check the output above."
        exit 1
    fi
fi
