#!/bin/bash
#
# Installer for debian-nspawn-64's host-support package.
#
# Takes a single argument, which must be one of:
# * preinst: stop relevant services for upgrade of package
# * install: install scripts, units and config files to $DESTDIR
# * postinst: enables all host-side services (but does not start them)
# * prerm: stop relevant services for removal of package
# * uninstall: remove scripts and units from $DESTDIR
# * purge: uninstall + remove any configuration files
# * postrm: remove created app launchers etc. from $DESTDIR
#
# Installation requires you to define $DESTDIR (the root of the target
# filesystem tree, defaults to "/" if not specified) and $SRCDIR (the
# root of the source tarball tree, defaults to "$PWD" if not specified).
#
# AUTHOR
# ------
#
# Copyright (c) 2019 sakaki <sakaki@deciban.com>
#
# License (GPL v3.0)
# ------------------
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#

set -e
set -u
shopt -s nullglob

SRCDIR="${SRCDIR:-${PWD}}"
DESTDIR="${DESTDIR:-/}"
# strip trailing slashes
SRCDIR="${SRCDIR%/}"
DESTDIR="${DESTDIR%/}"

DS64_NAME="debian-buster-64"
DS64_DIR="/var/lib/machines/${DS64_NAME}"

HSRC="${SRCDIR%/}/host-image"
CSRC="${HSRC}/usr/share/ds64/container-image"
SYSD="/lib/systemd/system"
SBIN="/usr/sbin"

SCRIPT_NAME="$(basename -- "${0}")"

if pidof -o %PPID -x "${SCRIPT_NAME}" &>/dev/null; then
    # already running
    exit 0
fi

print_usage() {
    cat << EOF
Usage: ${SCRIPT_NAME} command

Commands:
  preinst: stop relevant services for upgrade of package
  install: install scripts, units and config files to ${DESTDIR}
  postinst: enables all host-side services (but does not start them)
  prerm: stop relevant services for removal of package
  uninstall: remove scripts and units from ${DESTDIR}
  purge: uninstall + remove any configuration files
  postrm: remove created app launchers etc. from ${DESTDIR}
EOF
}

print_help() {
    cat << EOF
${SCRIPT_NAME} - {,un}install helper for ds64 host-side package
EOF
    print_usage
}

SERVICES=(
    "init-container@${DS64_NAME}.service"
    "reflect-timezone@${DS64_NAME}.path"
    "reflect-locale@${DS64_NAME}.path"
    "reflect-passwd@${DS64_NAME}.path"
    "reflect-apps@${DS64_NAME}.path"
)

preinst() {
    machinectl stop "${DS64_NAME}" &>/dev/null || true
    local S
    for S in "${SERVICES[@]}"; do
        systemctl stop "${S}" &>/dev/null || true
    done
}

install() {
    # install to $DESTDIR root
    mkdir -pv "${DESTDIR}/etc"
    /usr/bin/install -v -m 0644 "${HSRC}/etc"/ds64.conf "${DESTDIR}/etc/"
    mkdir -pv "${DESTDIR}/etc/sudoers.d"
    /usr/bin/install -v -m 0440 "${HSRC}/etc/sudoers.d"/* "${DESTDIR}/etc/sudoers.d/"
    mkdir -pv "${DESTDIR}/etc/X11/Xsession.d"
    /usr/bin/install -v -m 0644 "${HSRC}/etc/X11/Xsession.d"/* "${DESTDIR}/etc/X11/Xsession.d/"
    mkdir -pv "${DESTDIR}/etc/systemd/nspawn"
    /usr/bin/install -v -m 0644 "${HSRC}/etc/systemd/nspawn"/*.nspawn "${DESTDIR}/etc/systemd/nspawn/"
    mkdir -pv "${DESTDIR}/lib/systemd/system"
    /usr/bin/install -v -m 0644 "${HSRC}/lib/systemd/system"/* "${DESTDIR}/lib/systemd/system/"
    mkdir -pv "${DESTDIR}/usr/"{,s}bin
    /usr/bin/install -v "${HSRC}/usr/bin"/* "${DESTDIR}/usr/bin/"
    /usr/bin/install -v "${HSRC}/usr/sbin"/* "${DESTDIR}/usr/sbin/"
    rm -rfv "${DESTDIR}/usr/share/ds64/container-image"
    mkdir -pv "${DESTDIR}/usr/share/ds64"
    cp -rv "${HSRC}/usr/share/ds64/container-image" "${DESTDIR}/usr/share/ds64/"
    # TODO add faux /proc/cpuinfo service for use with 64-bit kernel
    mkdir -pv "${DESTDIR}/usr/share/pixmaps"
    /usr/bin/install -v -m 0644 "${HSRC}/usr/share/pixmaps"/* "${DESTDIR}/usr/share/pixmaps/"
    mkdir -pv "${DESTDIR}/usr/share/applications"
    /usr/bin/install -v -m 0644 "${HSRC}/usr/share/applications"/*.desktop "${DESTDIR}/usr/share/applications/"
}

postinst() {
    # enable host support services / path watchers
    # but do not start them - require reboot (since we may
    # still be under a 32-bit kernel etc. on first
    # install)
    local S
    for S in "${SERVICES[@]}"; do
        systemctl enable "${S}"
    done
    # enable and start Debian sidekick (ds) container itself
    # if possible
    systemctl enable "systemd-nspawn@${DS64_NAME}.service"
    echo "Please reboot your system to start using ${DS64_NAME}" >&2
    # ensure new menu items / icons visible on host
    # assumes default LXDE menu system
    lxpanelctl reload || true
    touch /etc/xdg/menus/lxde-*.menu || true
}

prerm() {
    # first stop the services
    preinst
    # then disable them
    # use following rather than machinectl, as the latter won't
    # work in a non-booted chroot
    systemctl disable "systemd-nspawn@${DS64_NAME}.service" &>/dev/null || true
    local S
    for S in "${SERVICES[@]}"; do
        systemctl disable "${S}" &>/dev/null || true
    done
}

uninstall() {
    # remove from destdir root
    rm -fv "${DESTDIR}/usr/bin"/ds64-{run,runner,running,shell,start,stop}
    rm -fv "${DESTDIR}/usr/bin"/unify-xauth
    rm -fv "${DESTDIR}/usr/sbin"/init-container
    rm -fv "${DESTDIR}/usr/sbin"/reflect-{apps,locale,passwd,timezone}
    rm -fv "${DESTDIR}/lib/systemd/system"/init-container@.service
    rm -fv "${DESTDIR}/lib/systemd/system"/reflect-{apps,locale,passwd,timezone}@.{path,service}
    rm -rfv "${DESTDIR}/usr/share/ds64"
    # following aren't really config files, although in /etc...
    rm -fv "${DESTDIR}/etc/sudoers.d/10_sudo-nopasswd"
    rm -fv "${DESTDIR}/etc/X11/Xsession.d/99unify-xauth"
    rm -fv "${DESTDIR}/etc/systemd/nspawn/${DS64_NAME}.nspawn"
    rm -fv "${DESTDIR}/usr/share/pixmaps"/ds64-{runner,shell,start,stop}.png
    rm -fv "${DESTDIR}/usr/share/pixmaps"/list-machines.{png,LICENSE}
    rm -fv "${DESTDIR}/usr/share/applications"/ds64-{runner,shell,start,stop}.desktop
    rm -fv "${DESTDIR}/usr/share/applications/list-machines.desktop"
}

purge() {
    uninstall
    rm -fv "${DESTDIR}/etc/ds64.conf"
}

postrm() {
    # get rid of any application helpers that may have been installed
    find "${DESTDIR}/usr/share/applications" -type f -name 'ds64-app-*.desktop' -delete
}

process_command_line_args() {
    if [[ ${#} != 1 ]]; then
        print_usage
        exit 1
    fi
    case "${1}" in
        preinst) preinst ;;
        install) install ;;
        postinst) postinst ;;
        prerm) prerm ;;
        uninstall) uninstall ;;
        postrm) postrm ;;
        purge) purge ;;
        *) print_usage ; exit 1 ;;
    esac
}

# *************** start of script proper ***************
process_command_line_args "${@}"
exit 0
# **************** end of script proper ****************
