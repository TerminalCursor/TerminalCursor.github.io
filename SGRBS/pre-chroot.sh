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
	printf "o\nn\np\n1\n\n+1M\nn\np\n2\n\n+16G\nn\np\n3\n\n\na\n1\np\nw\nq"
	echo
	printf "| fdisk /dev/${BLK_DEV}"
	echo
	printf "mkswap /dev/${BLK_DEV}2"
	echo
	printf "swapon /dev/${BLK_DEV}2"
	echo
	printf "mkfs.ext4 /dev/${BLK_DEV}3"
	echo
	printf "mount /dev/${BLK_DEV}3 /mnt/gentoo"
	echo
	if [ "$?" == "0" ]; then
		printf "cd /mnt/gentoo"
		echo
		AUTOBUILD_ISO=$(curl "https://gentoo.osuosl.org/releases/amd64/autobuilds/latest-stage3-amd64.txt" | grep "^[1-9]" | awk '{print $1}')
		AUTOBUILD_DIR=$(printf "https://gentoo.osuosl.org/releases/amd64/autobuilds/${AUTOBUILD_ISO}")
		echo $AUTOBUILD_DIR
		echo tar xpvf $(basename ${AUTOBUILD_ISO}) --xattrs-include='*.*' --numeric-owner
		printf "What architecture? "
		read ARCH
		echo COMMON_FLAGS="-march=$ARCH -O2 -pipe"
		echo CFLAGS="$${COMMON_FLAGS}"
		echo CXXFLAGS="$${COMMON_FLAGS}"
		NUM_CORE=$(lscpu | grep "^Core" | awk '{print $NF}')
		echo MAKE_OPTS="-j$(($NUM_CORE + 1))"
	fi
else
	echo "NETWORK DISCONNECTED"
fi
