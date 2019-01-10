# Intel® Movidius™ Neural Compute software developer kit (NCSDK) setup for Raspberry Pi

## Prerequisites

1. Movidius Neural Compute Stick
2. Raspberry Pi
3. SD card reader
4. A linux computer, of couse ; )

## Installation

1. Fisrt, download and burn [Raspbian Stretch](http://director.downloads.raspberrypi.org/raspbian/images/raspbian-2018-11-15/2018-11-13-raspbian-stretch.zip) image to your SD card. ([instructions](https://www.raspberrypi.org/documentation/installation/installing-images/README.md))
2. Insert SD card into Raspberry Pi and power on
3. Install NCSDK, follow the instructions below

```bash
git clone git://gitlab.com/ggml/rpi-ncsdk
cd rpi-ncsdk

bash ./install.sh
```

## Verify

To verify if the installation process is succeed do the following :

1. Open a terminal and change directory to the `ncsdk-${NCSDK_VER}/examples/apps/hello_ncs_py` base directory
2. Type the following command in the terminal: `make run`

When the application runs normally and is able to connect to the NCS device the output will be similar to this:

```bash
Hello NCS! Device opened normally.
Goodbye NCS! Device closed normally.
NCS device working.
```

## Install OpenCV from source (optional)

```bash
bash ./install_opencv_from_source.sh
```

## Enable auto-expand `rootfs` at first boot (optional)

1. Mount your SD card `boot` and `rootfs` partitions
2. Execute command bellow to enable expand `rootfs` at first boot once

```bash
bash ./resize_bootfs_once.sh
```

## Configure Raspbian Firmware (optional)

1. Mount your SD card `boot` partition
2. Execute command bellow configure Raspbian Firmware

```bash
➜ bash ./config_fw.sh

Firmware configuration Tool

Disable Wireless LAN? ([Y], n): y
Disable Bluetooth? ([Y], n): y
Disable Audio? ([Y], n): y
GPU memory in megabytes (defaults to 64): 128
Done!
```

## Resize `rootfs` partition (optional)

1. Turn off your Raspberry and insert SD card into a linux machine
2. Use Gparted to resize your rootfs partition to minimum size report of `resize2fs -P`: 1360M

```bash
$ sudo e2fsck -f /dev/sdc2
✹ ✭
e2fsck 1.44.1 (24-Mar-2018)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
rootfs: 142488/360448 files (0.2% non-contiguous), 1022661/1435648 blocks

# Estimate minimum size
$ sudo resize2fs -P /dev/sdc2
✹ ✭
resize2fs 1.44.1 (24-Mar-2018)
Estimated minimum size of the filesystem: 1393468
# 1393468 blocks * 512 bytes/1024/1024
# => Minimum required 680M * 2 = 1360M

# Resize partition to as minimum as posible
$ sudo resize2fs -M /dev/sdc2
✹ ✭
resize2fs 1.44.1 (24-Mar-2018)
Resizing the filesystem on /dev/sdc2 to 1393468 (4k) blocks.
The filesystem on /dev/sdc2 is now 1393468 (4k) blocks long.

# Get SD card information
$ sudo fdisk -l /dev/sdc
✹ ✭
Disk /dev/sdc: 29.7 GiB, 31914983424 bytes, 62333952 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x25948bd0

Device     Boot Start      End  Sectors  Size Id Type
/dev/sdc1        8192    98045    89854 43.9M  c W95 FAT32 (LBA)
/dev/sdc2       98304 11249663 11151360  5.3G 83 Linux
# => dd's bs=512 count=11249663

# Check partition again
sudo e2fsck -f /dev/sdc2                                             ✹ ✭
e2fsck 1.44.1 (24-Mar-2018)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
rootfs: 142103/352256 files (0.2% non-contiguous), 1012224/1393920 blocks
```

## Backup image

I use `dd`<sup>[1]</sup> command for backup and restore tasks and Pipe Viewer <sup>[2]</sup> for stats.

```bash
# Replace ${sdX} by your SD card
# Backup
sudo dd if=/dev/${sdX} bs=1M count=${number_of_megabytes} | pv --rate --timer --progress --size xxxM | gzip -9 > path_to_backup_file.gzip
# 4862 ± sudo dd if=/dev/sdc bs=512 count=11249663 | pv --rate --timer --progress --size=5493M  | gzip -9 > /workspace/Backup/rpi-ncsdk/2.05.00.02_11249663_5493M.gz                                 ✹ ✭
# 11249663+0 records in============================================================>  ] 99%
# 11249663+0 records out
# 5759827456 bytes (5.8 GB, 5.4 GiB) copied, 541.752 s, 10.6 MB/s
# 0:09:01 [10.1MiB/s] [============================================================>  ] 99%

# restore
gunzip -c path_to_backup_file.gzip | pv | sudo dd of=/dev/${sdX}
# dd if=5656M.img | pv --rate --timer --progress --size 5656M | sudo dd of=/dev/sdc
```

[1]: https://en.wikipedia.org/wiki/Dd_(Unix)
[2]: https://www.ivarch.com/programs/pv.shtml