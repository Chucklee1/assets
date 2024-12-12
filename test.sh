# get disk name
echo "enter the disk name (eg: sdx, nvme): "
read DISK

echo "creating partitions on /dev/$DISK"
BOOT_SIZE="500MB"
parted /dev/${DISK} -- mklabel gpt
parted /dev/${DISK} -- mkpart ESP 1MB ${BOOT_SIZE}
parted /dev/${DISK} -- set 1 esp on
parted /dev/${DISK} -- mkpart root ${BOOT_SIZE} 100%