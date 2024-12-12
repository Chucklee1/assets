#!/bin/bash

# get disk name
echo "enter the disk name (eg: sdx, nvme): "
read DISK

echo "creating partitions on /dev/$DISK"
BOOT_SIZE="500MB"
parted /dev/${DISK} -- mklabel gpt
parted /dev/${DISK} -- mkpart ESP 1MB ${BOOT_SIZE}
parted /dev/${DISK} -- set 1 esp on
parted /dev/${DISK} -- mklabel root ${BOOT_SIZE} 100%

echo "formatting partitions on /dev/$DISK"
if [ "$DISK" == "nvme" ]; then
    mkfs.fat -F32 -n BOOT ${DISK}p1
    mkfs.ext4 -L NIXOS-ROOT ${DISK}p2  
else then
    mkfs.fat -F32 -n BOOT ${DISK}1
    mkfs.ext4 -L NIXOS-ROOT ${DISK}2 
fi


echo "mounting partitions on /dev/$DISK"
mount /dev/disk/by-label/NIXOS-ROOT /mnt
mkdir /mnt/boot
mount -o umask=077 /dev/disk/by-label/BOOT /mnt/boot

echo "generating config files"
nixos-generate-config --root /mnt


echo "copying nix config to root"
cp g /mnt/etc/configuration.nix

echo "installing nixos"
nixos-install


echo "set the user password"
nixos-enter --root /mnt -c 'passwd goat'

