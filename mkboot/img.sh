echo "making ramdisk"
#./mkbootfs boot.img-ramdisk | gzip > newramdisk.cpio.gz
cd boot.img-ramdisk
find . | cpio -o -H newc | gzip > ../newramdisk.cpio.gz
cd ..
./mkbootimg --cmdline 'no_console_suspend=1 console=null' --kernel zImage --ramdisk newramdisk.cpio.gz -o boot.img 
