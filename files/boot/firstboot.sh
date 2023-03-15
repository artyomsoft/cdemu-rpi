#!/bin/bash

image_file=/usr/local/share/cdemu/hdd-image.img

mount_point=/mnt/data

mkdir -p /usr/local/share/cdemu

#file_size must be 3/4 from the free space on the partition
file_size=$( expr $(df -B1 --output=avail,source | grep /dev/root | cut -d " " -f 1) / 2048 \* 1536 ) 

fallocate -l $file_size $image_file

echo "type=7" | sfdisk $image_file

losetup -D

loop_device=$(losetup -f)

losetup -o $(expr 512 \* 2048) $loop_device $image_file

mkfs.exfat $loop_device

mkdir -p $mount_point

mount -t auto $loop_device $mount_point

cp /usr/local/share/cdemu/Readme.txt $mount_point/Readme.txt

umount $mount_point

losetup -D

systemctl enable cdemu.service

systemctl start cdemu.service