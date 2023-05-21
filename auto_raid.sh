#!/bin/bash
sudo su
lsblk 
mdadm --zero-superblock --force /dev/sd{b,c,d,e}
mdadm --create --verbose /dev/md0 -l 5 -n 4 /dev/sd{b,c,d,e}
cat /proc/mdstat
mkdir /etc/mdadm
mdadm /dev/md0 --fail /dev/sde
mdadm /dev/md0 --remove /dev/sde
mdadm /dev/md0 --add /dev/sde
sleep 15
parted /dev/md0 mkpart primary ext4 0% 20%
parted /dev/md0 mkpart primary ext4 20% 40%
parted /dev/md0 mkpart primary ext4 40% 60%
parted /dev/md0 mkpart primary ext4 60% 80%
parted /dev/md0 mkpart primary ext4 80% 100%
for i in $(seq 1 5); do mkfs.ext4 /dev/md0p$i; done
mkdir -p /raid/part{1,2,3,4,5}
for i in $(seq 1 5); do mount /dev/md0p$i /raid/part$i; done
