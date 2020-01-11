#!/bin/bash -e

pi_passwd=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-8})
user_passwd=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-8})
root_passwd=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-8})

# Write passwords to a file.
cat <<EOF > ${DEPLOY_DIR}/users
${FIRST_USER_NAME}=${pi_passwd}
${ADMIN_USER_NAME}=${user_passwd}
root=${root_passwd}
EOF

on_chroot <<EOF
if ! id -u ${ADMIN_USER_NAME} >/dev/null 2>&1; then
	adduser --disabled-password --gecos "" ${ADMIN_USER_NAME}
fi
echo "${FIRST_USER_NAME}:${pi_passwd}" | chpasswd
echo "${ADMIN_USER_NAME}:${user_passwd}" | chpasswd
echo "root:${root_passwd}" | chpasswd
usermod -G users,input,video ${FIRST_USER_NAME} 
usermod -a -G users,input,video,adm,sudo ${ADMIN_USER_NAME}
if [ ! -e ~${ADMIN_USER_NAME}/.ssh ]; then
	mkdir ~${ADMIN_USER_NAME}/.ssh
fi
echo "${ADMIN_SSHKEY}" >~${ADMIN_USER_NAME}/.ssh/authorized_keys
echo "PasswordAuthentication no">>/etc/ssh/sshd_config
chown ${ADMIN_USER_NAME}:${ADMIN_USER_NAME} ~${ADMIN_USER_NAME}/.ssh
chmod go-rwx ~${ADMIN_USER_NAME}/.ssh
groupadd -f sshusers
usermod -a -G sshusers ${ADMIN_USER_NAME}
echo "AllowGroups sshusers">>/etc/ssh/sshd_config
rm /etc/sudoers.d/010_*-nopasswd
echo "%sudo ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/010_sudo-nopasswd
chmod 0440 /etc/sudoers.d/010_sudo-nopasswd
EOF

if [ -n "${AUTOLOGON_USER}" ]; then
on_chroot <<EOF
sed -i -e 's/--autologin pi/--autologin ${AUTOLOGON_USER}/g' /etc/systemd/system/autologin@.service
rm /etc/systemd/system/getty.target.wants/getty@tty1.service
ln -s /etc/systemd/system/autologin@.service /etc/systemd/system/getty.target.wants/getty@tty1.service
EOF
fi

