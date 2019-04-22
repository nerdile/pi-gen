#!/bin/bash

install -m 755 files/autostart "${ROOTFS_DIR}/etc/xdg/openbox/autostart"
install -m 755 files/.bash_profile "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.bash_profile"
install -m 755 files/startx_nocursor "${ROOTFS_DIR}/usr/local/bin/startx_nocursor"

on_chroot <<EOF
	usermod -s /usr/local/bin/startx_nocursor ${FIRST_USER_NAME}
EOF

