on_chroot <<EOF
perl -pi -e 's/# ${LOCALE_DEFAULT} UTF-8/${LOCALE_DEFAULT} UTF-8/g' /etc/locale.gen
locale-gen ${LOCALE_DEFAULT}
update-locale ${LOCALE_DEFAULT}
EOF
