#!/bin/bash

CC="arm-linux-gnueabihf-"
VERSION="v2021.01"
#DTB="am335x-sg4000.dtb"
CFG="am335x_boneblack_vboot_defconfig"
#CFG="am335x_evm_defconfig"
PATH_BUILD="../_build/u-boot-${VERSION}"

IMG="u-boot.img"
PATH_MLO="${PATH_BUILD}/MLO"
PATH_IMG="${PATH_BUILD}/${IMG}"

PATH_BOOT="/media/pi/boot"
PATH_ROOT="/media/pi/root/boot"


if [ $1 == "config" ] ; then

echo "[make ARCH=arm -j4 CROSS_COMPILE=\"${CC}\" $CFG]"
make ARCH=arm -j4 CROSS_COMPILE="${CC}" O="${PATH_BUILD}" $CFG
if [ ! -f ${PATH_BUILD}/.config ] ; then
        echo "failed: [${PATH_BUILD}/$CFG]"
        exit 1
fi

elif [ $1 == "build" ] ; then

echo "[make ARCH=arm -j4 CROSS_COMPILE=\"${CC}\" ]"
make ARCH=arm -j4 CROSS_COMPILE="${CC}" O="${PATH_BUILD}" 
if [ ! -f ${PATH_BUILD}/u-boot ] ; then
        echo "failed: [${PATH_BUILD}/u-boot]"
        exit 1
fi

elif [ $1 == "copy" ] ; then

echo "copy to ${PATH_BOOT}"
sudo cp ${PATH_MLO} ${PATH_BOOT}
sudo cp ${PATH_IMG} ${PATH_BOOT}

echo "copy to ${PATH_ROOT}"
sudo cp "${PATH_ROOT}/MLO" "${PATH_ROOT}/MLO.old"
sudo cp ${PATH_MLO} ${PATH_ROOT}
sudo cp ${PATH_MLO} "${PATH_ROOT}/MLO-${VERSION}"

sudo cp "${PATH_ROOT}/${IMG}" "${PATH_ROOT}/${IMG}.old"
sudo cp ${PATH_IMG} ${PATH_ROOT}
sudo cp ${PATH_IMG} "${PATH_ROOT}/${IMG}-${VERSION}"

echo "copy end."
sync

else

echo "[make ARCH=arm -j4 CROSS_COMPILE=\"${CC}\" $1]"
make ARCH=arm -j4 CROSS_COMPILE="${CC}" O="${PATH_BUILD}" $1

fi
