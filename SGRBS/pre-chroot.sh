#!/bin/sh
PING_RESULTS=$(ping -c 1 terminalcursor.xyz)
PING_SUCCESS=$?
if [ "${PING_SUCCESS}" == "0" ]; then
	echo "NETWORK CONNECTED"
	BLKS=$(lsblk | grep "^sd[a-z]")
	BLKS_NAMES=$(printf "${BLKS}" | sed 's/^\(sd[a-z]\).*/\1/')
	printf "$BLKS\n"
	printf "Which block device do you want to partition? "
	read BLK_DEV
	BLK_DEV=$(echo $BLK_DEV | awk '{print $1}')
	echo Selected $BLK_DEV
	printf "o\nn\np\n1\n\n+1M\nn\np\n2\n\n+16G\nn\np\n3\n\n\na\n1\np\nw\nq" | fdisk /dev/${BLK_DEV}
	mkswap /dev/${BLK_DEV}2
	swapon /dev/${BLK_DEV}2
	mkfs.ext4 /dev/${BLK_DEV}3
	mount /dev/${BLK_DEV}3 /mnt/gentoo
	if [ "$?" == "0" ]; then
		cd /mnt/gentoo
		AUTOBUILD_ISO=$(curl "https://gentoo.osuosl.org/releases/amd64/autobuilds/latest-stage3-amd64.txt" | grep "^[1-9]" | awk '{print $1}')
		AUTOBUILD_DIR=$(printf "https://gentoo.osuosl.org/releases/amd64/autobuilds/${AUTOBUILD_ISO}")
		curl -LO "$AUTOBUILD_DIR"
		echo $AUTOBUILD_DIR
		tar xpvf $(basename ${AUTOBUILD_ISO}) --xattrs-include='*.*' --numeric-owner
		printf "What architecture? "
		read ARCH
		printf "COMMON_FLAGS=\"-march=$ARCH -O2 -pipe\"\nCFLAGS=\"$${COMMON_FLAGS}\"\nCXXFLAGS=\"$${COMMON_FLAGS}\"" >> /mnt/gentoo/etc/portage.conf
		NUM_CORE=$(lscpu | grep "^Core" | awk '{print $NF}')
		printf "MAKE_OPTS="-j$(($NUM_CORE + 1))" >> /mnt/gentoo/etc/portage.conf
		nano /mnt/gentoo/etc/portage.conf
		cp --dereference /etc/resolv.conf /mnt/gentoo/etc
		mount --types proc /proc /mnt/gentoo/proc
		mount --rbind /sys /mnt/gentoo/sys
		mount --make-rslave /mnt/gentoo/sys
		mount --rbind /dev /mnt/gentoo/dev
		mount --make-rslave /mnt/gentoo/dev
	fi
else
	echo "NETWORK DISCONNECTED"
fi
