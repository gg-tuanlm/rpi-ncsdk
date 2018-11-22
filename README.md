Intel® Movidius™ Neural Compute software developer kit (NCSDK) setup for Raspberry Pi
-------------------------------------------------------------------------------------

## Prerequisites

1. Movidius Neural Compute Stick
2. Raspberry Pi
3. SD card reader
4. A linux computer, of couse ; )

### Installation

1. Fisrt, download and burn [Raspbian Stretch](https://www.raspberrypi.org/downloads/raspbian/) image to your SD card. ([instructions](https://www.raspberrypi.org/documentation/installation/installing-images/README.md))
2. Insert SD card into Raspberry Pi and power on
3. Install NCSDK, follow the instructions below
```bash
git clone https://github.com/gg-tuanlm/rpi-ncsdk
cd rpi-ncsdk

bash ./install.sh
```

### Verify

To verify if the installation process is succeed do the following :
1. Open a terminal and change directory to the `ncsdk-${NCSDK_VER}/examples/apps/hello_ncs_py` base directory
2. Type the following command in the terminal: `make run`

When the application runs normally and is able to connect to the NCS device the output will be similar to this:

~~~
Hello NCS! Device opened normally.
Goodbye NCS! Device closed normally.
NCS device working.
~~~

### Install OpenCV from source (optional)

```bash
bash ./install_opencv_from_source.sh
```

### Resize `rootfs` partition (optional)

1. Turn off your Raspberry and insert SD card into a linux machine
2. Use Gparted to resize your rootfs partition
3. I use `dd` command for backup and restore tasks
```bash
# Replace ${sdX} by your SD card
# Backup
sudo dd if=/dev/${sdX} bs=1M count=${number_of_megabytes} | pv | gzip -9 > path_to_backup_file.gzip

# restore
gunzip -c path_to_backup_file.gzip | pv | sudo dd of=/dev/${sdX}
```

### Enable auto-expand `rootfs` at first boot (optional)

1. Mount your SD card `boot` and `rootfs` partitions
2. Execute command bellow to enable expand `rootfs` at first boot once
```bash
bash ./resize_bootfs_once.sh
```
