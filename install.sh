#!/bin/sh

# path:   /home/klassiker/.local/share/repos/ventoy-theme/install.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/ventoy-theme
# date:   2024-04-27T17:43:07+0200

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"
label="Ventoy"

# mount ventoy partition
[ -h "/dev/disk/by-label/$label" ] \
    && mnt="/mnt/$label" \
    && printf ":: create and mount ventoy folder %s\n" "$mnt" \
    && $auth mkdir --parents "$mnt" \
    && $auth mount --options rw,umask=0000 "/dev/disk/by-label/$label" "$mnt"

# copy klassiker theme files
[ -d "$mnt/ventoy" ] \
    && printf ":: remove theme files from %s\n" "$mnt" \
    && rm --recursive --force "$mnt/ventoy"
[ -d "$mnt" ] \
    && printf ":: copy klassiker theme files to %s\n" "$mnt" \
    && ! [ -d "$mnt/ventoy" ] \
    && cp --recursive "ventoy" "$mnt/ventoy"

# create folder structure for klassiker theme
[ -d "$mnt" ] \
    && printf ":: create folder structure for klassiker theme in %s\n" "$mnt" \
    && mkdir --parents \
        "$mnt/data" \
        "$mnt/isos/diagnostic" \
        "$mnt/isos/firmware" \
        "$mnt/isos/linux" \
        "$mnt/isos/pentest" \
        "$mnt/isos/rescue" \
        "$mnt/isos/windows"

# create checksum file with example iso
[ -d "$mnt" ] \
    && ! [ -e "$mnt/ventoy_checksum" ] \
    && printf ":: create ventoy checksum file in %s\n" "$mnt" \
    && printf "%b" \
        "# diagnostic\n\n" \
        "# firmware\n\n" \
        "# linux\n" \
        "52aea58f88c9a80afe64f0536da868251ef4878de5a5e0227fcada9f132bd7ab  " \
        "isos/linux/archlinux-2024.04.01-x86_64.iso\n\n" \
        "# pentest\n\n" \
        "# rescue\n\n" \
        "# windows" > "$mnt/ventoy_checksum"

# unmount ventoy partition
[ -d "$mnt" ] \
    && printf ":: unmount and delete ventoy folder %s\n" "$mnt" \
    && $auth umount "$mnt" \
    && $auth find "$mnt" -empty -type d -delete
