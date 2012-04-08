#!/bin/bash

[[ `diff arch/arm/configs/tuna_defconfig .config ` ]] && \
	{ echo "Unmatched defconfig!"; exit -1; } 

sed -i s/CONFIG_LOCALVERSION=\".*\"/CONFIG_LOCALVERSION=\"-cna-${1}\"/ .config
sed -i /UNLOCK_180/d .config

make -j32

cp arch/arm/boot/zImage mkboot/
sed -i s/CONFIG_LOCALVERSION=\".*\"/CONFIG_LOCALVERSION=\"\"/ .config
sed -i /UNLOCK_180/d .config
cp .config arch/arm/configs/tuna_defconfig

cd mkboot
chmod 744 boot.img-ramdisk/sbin/lkflash
chmod 744 boot.img-ramdisk/sbin/checkv
chmod 744 boot.img-ramdisk/sbin/checkt
echo "making boot image"
./img.sh

zipfile="cna_Gnex_v${1}.zip"
if [ ! $4 ]; then
	rm -f /tmp/*.img
	echo "making zip file"
	cp boot.img ../zip
	cp boot.img /tmp
	cd ../zip
	rm -f *.zip
	zip -r $zipfile *
	rm -f /tmp/*.zip
	cp *.zip /tmp
fi
[[ $1 == *dev* ]] && exit
[[ $1 == *rc* ]] && exit
md5=`md5sum /tmp/boot.img | awk '{ print \$1 }'`
cp /tmp/boot.img /tmp/boot-${1}.img
  mf="latest"
  edir=""
echo "http://imoseyon.host4droid.com${edir}/boot-${1}.img $md5 ${1}" > /tmp/$mf
