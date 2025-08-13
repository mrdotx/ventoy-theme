#!/bin/sh

# path:   /home/klassiker/.local/share/repos/ventoy-theme/install.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/ventoy-theme
# date:   2025-08-13T03:24:17+0200

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"
label="Ventoy"

# color variables
reset="\033[0m"
bold="\033[1m"
blue="\033[94m"
cyan="\033[96m"

# mount ventoy partition
[ -h "/dev/disk/by-label/$label" ] \
    && mnt="/mnt/$label" \
    && printf "%b%b::%b %bcreate and mount ventoy folder%b %b%s%b\n" \
        "$bold" "$blue" "$reset" "$bold" "$reset" \
        "$cyan" "$mnt" "$reset" \
    && $auth mkdir --parents "$mnt" \
    && $auth mount --options rw,umask=0000 "/dev/disk/by-label/$label" "$mnt"

# copy klassiker theme files
[ -d "$mnt/ventoy" ] \
    && printf "%b%b::%b %bremove theme files from%b %b%s%b\n" \
        "$bold" "$blue" "$reset" "$bold" "$reset" "$cyan" "$mnt" "$reset" \
    && rm --recursive --force "$mnt/ventoy"
[ -d "$mnt" ] \
    && printf "%b%b::%b %bcopy klassiker theme files to%b %b%s%b\n" \
        "$bold" "$blue" "$reset" "$bold" "$reset" "$cyan" "$mnt" "$reset" \
    && ! [ -d "$mnt/ventoy" ] \
    && cp --recursive "ventoy" "$mnt/ventoy"

# create folder structure for klassiker theme
[ -d "$mnt" ] \
    && printf "%b%b::%b %bcreate folder structure for klassiker theme in%b %b%s%b\n" \
        "$bold" "$blue" "$reset" "$bold" "$reset" "$cyan" "$mnt" "$reset" \
    && mkdir --parents \
        "$mnt/data" \
        "$mnt/isos/diagnostic" \
        "$mnt/isos/firmware" \
        "$mnt/isos/linux" \
        "$mnt/isos/pentest" \
        "$mnt/isos/rescue" \
        "$mnt/isos/security" \
        "$mnt/isos/windows"

# create checksum file with example iso
[ -d "$mnt" ] \
    && ! [ -e "$mnt/ventoy_checksum" ] \
    && printf "%b%b::%b %bcreate ventoy checksum file in%b %b%s%b\n" \
        "$bold" "$blue" "$reset" "$bold" "$reset" "$cyan" "$mnt" "$reset" \
    && printf "%b" \
        "# diagnostic\n\n" \
        "# firmware\n\n" \
        "# linux\n" \
        "52aea58f88c9a80afe64f0536da868251ef4878de5a5e0227fcada9f132bd7ab  " \
        "isos/linux/archlinux-2024.04.01-x86_64.iso\n\n" \
        "# pentest\n\n" \
        "# rescue\n\n" \
        "# security\n\n" \
        "# windows" > "$mnt/ventoy_checksum"

# unmount ventoy partition
[ -d "$mnt" ] \
    && printf "%b%b::%b %bunmount and delete ventoy folder%b %b%s%b\n" \
        "$bold" "$blue" "$reset" "$bold" "$reset" \
        "$cyan" "$mnt" "$reset" \
    && $auth umount "$mnt" \
    && $auth find "$mnt" -empty -type d -delete
