---
---

# Raspberry Pi 4 Model B

Requires:

- USB Type-C cable.
- Ethernet cable.
- SD card.

## Downloading Required Softwares

1. From the official [raspberrypi.org](https://www.raspberrypi.org/downloads/) download the operating system
2. Also, download the [Raspberry Pi Imager](https://www.raspberrypi.org/downloads/) from the same website, this is for writing the image file onto the SD card.

### Writing OS to SD Card

Note: enable required functionalities.

- Install a 64 bit version: PyTorch only provides pip packages for Arm 64bit (aarch64)
- Hostname, default: `raspberrypi.local`
- SSH: use password authentication
- (optional) WiFi

### Creating "ssh" File

(not sure, it's removed automatically after ssh login) Open the boot folder, create a new document named “ssh” without any extensions, save and then unmount the drive.

## Power Up Pi

Connect the pi to the laptop with the type-C cable (for power) and ethernet cable (for ssh).

### Entering Pi Terminal Through SSH

- host: `pi@raspberrypi.local:22`
- default password: `raspberry`

### Updating the Pi

[Raspbian 源@USTC](https://mirrors.ustc.edu.cn/help/raspbian.html)

```sh
sudo sed -i 's|raspbian.raspberrypi.org|mirrors.ustc.edu.cn/raspbian|g' /etc/apt/sources.list
# Raspberry Pi OS (64-bit): use Debian sources
sudo sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
sudo sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list

sudo apt update && sudo apt -y upgrade
```

### Other config

```sh
sudo raspi-config
```

- Setup WiFi, then SSH could establish without ethernet cable.

## Accessing Pi Desktop Remotely

This should generate **ip address**:

```sh
vncserver
```
