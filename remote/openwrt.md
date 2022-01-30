---
...

## Install in PVE

1. install PVE on a bare metal, or a USB stick

https://pve.proxmox.com/wiki/Downloads
https://rufus.ie/en/

2. build openwrt (Lean's source)

https://github.com/coolsnowwolf/lede

Note: needs ladder. Best: create a Ubuntu VM in PVE.

```sh
sudo apt-get update
sudo apt-get -y install build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch python3 python2.7 unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler g++-multilib antlr3 gperf wget curl swig rsync

cd projects
git clone https://github.com/coolsnowwolf/lede
cd lede

./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig

# run multiple times and make sure everything is downloaded
make -j8 download V=s
# if using root:
# export FORCE_UNSAFE_CONFIGURE=1
make -j1 V=s
```

Rebuild:

```sh
cd lede
git pull
./scripts/feeds update -a && ./scripts/feeds install -a
make defconfig
make -j8 download
make -j$(($(nproc) + 1)) V=s
```

Reconfig:

```sh
rm -rf ./tmp && rm -rf .config
make menuconfig
make -j$(($(nproc) + 1)) V=s
```

Output: `bin/targets`.

Should use: `openwrt-x86-64-generic-squashfs-combined-efi.img`.

3. config openwrt VM

Create a VM for openwrt, then `Detach` & `Remove` the hard disk.

Upload the openwrt image to PVE storage, and remember the path by checking the log or this path: `/var/lib/vz/template/iso/`.

Create a hard disk using openwrt image:

```sh
qm importdisk VM_ID IMAGE_PATH local-lvm
qm importdisk 202 /var/lib/vz/template/iso/openwrt-x86-64-generic-squashfs-combined-efi.img local-lvm
```

Then allocate a SATA (SCSI seems also fine) disk for the image; check `Start at boot`; change `Boot order`.

4. boot into openwrt

hit `Enter` and:

```sh
cp /etc/config/network /etc/config/network.bak
vi /etc/config/network
####
option proto 'static' --> option proto 'dhcp'
####

reboot

ip a # remember allocated IP
cp /etc/config/network.bak /etc/config/network
vi /etc/config/network

passwd # change the password of management dashboard
```

5. openwrt basic config

Network > Interface > Lan: cancel DHCP service.

## Install in docker

1. pull image

```sh
docker pull openwrtorg/rootfs:x86-64
docker pull sulinggg/openwrt:x86_64
```

2. promiscuous mode on the host card

混杂模式（Promiscuous Mode）是指一台机器能够接收所有经过它的数据流，而不论其目的地址是否是他。

```sh
sudo ip link set enp4s0 promisc on
```

3. switching stream via macvlan

macvlan并不创建网络，只创建虚拟网卡；macvlan会共享物理网卡所链接的外部网络，实现的效果跟桥接模式是一样的。

macvlan技术就是在物理网卡下，添加另一张虚拟网卡，其实就是在物理网卡下添加了一个条件分支。我们可以认为报文从物理网卡进入之后，会做一个switch判断，如果该报文mac属于macvlan，则直接发往macvlan后面的网络，否则就发往原host的网络。

```sh
docker network create --driver macvlan --subnet=218.199.0.0/21 --gateway=218.199.7.254 --opt parent=enp4s0 macvlan
```

4. boot docker image in the background

```sh
docker run --restart always --name openwrt --detach --network macvlan --privileged openwrtorg/rootfs:x86-64 /sbin/init
docker run --restart always --name openwrt --detach --network macvlan --privileged sulinggg/openwrt:x86_64 /sbin/init

5. config IP

docker exec -ti openwrt bash

vi /etc/config/network
config interface 'lan'
    option type 'bridge'
    option ifname 'eth0'
    option proto 'static'
    option ip6assign '60'
    option netmask '255.255.248.0'
    option ipaddr '218.199.0.207'
    option gateway '218.199.7.254'
    option dns '218.199.7.254'
    option dns '211.67.48.8 114.114.114.114'
    option dns '114.114.114.114, 208.67.222.222, 208.67.220.220'

/etc/init.d/network restart
```

### USTC source

https://mirrors.ustc.edu.cn/openwrt/releases

```sh
cat /etc/openwrt_version
vi /etc/opkg/distfeeds.conf
```

### line speed dayly update

https://www.duyaoss.com/

### Find free IPs in the LAN

```sh
fping -g 218.199.7.2 218.199.7.253 2>/dev/null | grep 'is unreachable' | cut -d ' ' -f 1 | sort -t '.' -k 4 -n | less > /tmp/fip
```
