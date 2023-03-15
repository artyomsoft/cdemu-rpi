#! /bin/bash
partitions=( $(kpartx -al *-raspios-bullseye-armhf-lite.img | cut -f1 -d " ") )
kpartx -avs *-raspios-bullseye-armhf-lite.img
mkdir -p /mnt/cdrom-emu/boot
mkdir -p /mnt/cdrom-emu/root/usr/lib
mount /dev/mapper/${partitions[0]} /mnt/cdrom-emu/boot
mount /dev/mapper/${partitions[1]} /mnt/cdrom-emu/root
mkdir -p /mnt/cdrom-emu/root/etc/systemd/system/usb-gadget.target.wants
mkdir -p /mnt/cdrom-emu/root/usr/share/cdemu
ln -s /etc/systemd/system/cdemu-bluetooth-ui.service /mnt/cdrom-emu/root/etc/systemd/system/multi-user.target.wants/cdemu-bluetooth-ui.service
ln -s /usr/lib/systemd/system/firstboot.service /mnt/cdrom-emu/root/etc/systemd/system/multi-user.target.wants/firstboot.service

cp -rvb files/boot/ /mnt/cdrom-emu/
cp -rvb files/root/ /mnt/cdrom-emu/
cp -rv /app/linux/root/lib /mnt/cdrom-emu/root/usr/
cp -rv /app/linux/boot/ /mnt/cdrom-emu/

kpartx -dv *-raspios-bullseye-armhf-lite.img

umount /mnt/cdrom-emu/boot
umount /mnt/cdrom-emu/root

cp *-raspios-bullseye-armhf-lite.img /build/cdemu-raspios.img
