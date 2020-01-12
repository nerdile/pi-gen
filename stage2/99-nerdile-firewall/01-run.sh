#!/bin/bash -e

install -m 644 files/iptables.rules "${ROOTFS_DIR}/etc/iptables/rules.v4"
install -m 644 files/iptables.rules "${ROOTFS_DIR}/etc/iptables/rules.v6"


