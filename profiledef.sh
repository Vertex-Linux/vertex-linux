#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="vertex-linux"
iso_label="VERTEX_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="Vertex Linux <https://vertex.arc360hub.com>"
iso_application="Vertex Linux Live"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="vertex"
buildmodes=('iso')
bootmodes=(
    'bios.syslinux'
    'uefi.systemd-boot'
)
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
    ["/etc/shadow"]="0:0:400"
    ["/etc/gshadow"]="0:0:400"
    ["/root"]="0:0:750"
    ["/root/customize_airootfs.sh"]="0:0:755"
    ["/usr/local/bin/vertex-install"]="0:0:755"
    ["/usr/local/bin/vertex-grubfix"]="0:0:755"
    ["/usr/local/bin/vertex-bootsetup"]="0:0:755"
    ["/usr/local/bin/vertex-bootsetup-host"]="0:0:755"
    ["/usr/local/bin/vertex-squashfs-check"]="0:0:755"
    ["/usr/local/bin/vertex-grubcfg"]="0:0:755"
    ["/usr/local/bin/vertex-grubmkconfig-noop"]="0:0:755"
    ["/usr/local/bin/vertex-postinstall"]="0:0:755"
    ["/usr/local/bin/vertex-firstrun"]="0:0:755"
    ["/usr/local/bin/vpkg"]="0:0:755"
    ["/usr/local/bin/vertex-drivers"]="0:0:755"
    ["/usr/local/bin/vertex-update"]="0:0:755"
)
