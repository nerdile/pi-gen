#!/bin/bash

install -m 755 files/autostart "${ROOTFS_DIR}/etc/xdg/openbox/autostart"
install -m 755 files/.bash_profile "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.bash_profile"

