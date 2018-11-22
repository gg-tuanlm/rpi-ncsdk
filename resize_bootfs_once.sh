#!/bin/bash
read -n 1 -p "Do you want to expand rootfs at first boot? [y, [N]]:" doit_resize
case $doit_resize in
    y|Y)
        sed -i 's/quiet/& init=\/usr\/lib\/raspi-config\/init_resize.sh/g' /media/${USER}/boot/cmdline.txt;
        sudo cp -r resize_bootfs_once/rootfs/* /media/${USER}/rootfs;
        sudo chmod a+x /media/${USER}/rootfs/etc/init.d/resize2fs_once;
        sudo chmod a+x /media/${USER}/rootfs/etc/rc3.d/S01resize2fs_once;
        echo "Resize done.";;
    *) echo "Skip expand rootfs.";;
esac