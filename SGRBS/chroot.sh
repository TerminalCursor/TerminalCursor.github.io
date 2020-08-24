#!/bin/sh
echo "Syncing Portage"
emerge --sync
echo "Updating @world"
read CONTINUE
emerge --ask --verbose --update --deep --newuse @world
printf "\nUSE=\"X pdf png jpeg alsa imlib latex pulseaudio luajit -qtwebengine\"\n" >> /etc/portage/make.conf
printf "" >> /etc/portage/package.license
emerge neovim
emerge neofetch
emerge w3m
emerge fvwm
emerge calcurse
emerge dev-vcs/git
emerge zsh
printf "What timezone? Ex: America/Phoenix"
read TIMEZONE
echo "${TIMEZONE}" > /etc/timezone
printf "\nen_US ISO-8859-1\nen_US.UTF-8 UTF-8\n"
locale-gen
printf "LANG=\"en_US.UTF-8\"\nLC_COLLATE=\"C\"" > /etc/env.d/02locale
env-update && source /etc/profile
#emerge --ask sys-kernel/gentoo-sources
emerge --ask sys-kernel/genkernel
nvim /etc/fstab
printf "Generating the kernel"
genkernel all
printf "Installing additional linux firmware"
emerge --ask sys-kernel/linux-firmware
nvim /etc/fstab
printf "\nhostname=\"mountain\"\n" >> /etc/conf.d/hostname
printf "\ndns_domain_lo=\"forest\"\n" >> /etc/conf.d/net
printf "\nconfig_eth0=\"dhcp\"\n" >> /etc/conf.d/net
cd /etc/init.d
ln -s net.lo net.eth0
rc-update add net.eth0 default
printf "\n127.0.0.1 mountain.forest mountain localhost\n" > /etc/hosts
echo "ADD  clock=\"local\"  if this PC will be booted with Windows as well"
read TEST
nvim /etc/conf.d/hwclock
emerge --ask sys-process/cronie
rc-update add cronie default
emerge --ask net-misc/dhcpcd
rc-update add dhcpcd default
printf "\nGRUB_PLATFORMS=\"pc\"\n" >> /etc/portage/make.conf
emerge --ask --verbose sys-boot/grub:2
BLKS=$(lsblk | grep "^sd[a-z]")
BLKS_NAMES=$(printf "${BLKS}" | sed 's/^\(sd[a-z]\).*/\1/')
printf "$BLKS\n"
printf "Which block device do you want to partition? "
read BLK_DEV
BLK_DEV=$(echo $BLK_DEV | awk '{print $1}')
echo Selected $BLK_DEV
grub-install /dev/${BLK_DEV}
grub-mkconfig -o /boot/grub/grub.cfg
echo "Use (passwd) to set root password"
echo "Use (useradd -m -G users,wheel,audio -s /bin/bash USERNAME) to create a new user"
echo "Use passwd (USERNAME) to set USERNAME's password"
printf "Run the following to finish:\nexit\numount -l /mnt/gentoo/dev{/shm,/pts,}\numount -R /mnt/gentoo\nreboot"
