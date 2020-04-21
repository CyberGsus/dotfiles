#!/bin/sh

# dmenumount.sh
# Use : sudo dmenumount.sh
# Description: Gives user option to mount devices
#              where they want, creating directories if 
#              needed and gives the choice to add the 
#              device to /etc/fstab.

available_mounts=`lsblk -lpo NAME,TYPE,MOUNTPOINT | awk '/part/ && !/\[SWAP\]/ && /\s$/ {print $1}'`
[ -z "$available_mounts" ] && exit 1
disk=`echo "$available_mounts" | dmenu -p "Which one? :" -i`
[ -z "$disk" ] && exit 1
mount "$disk" 2> /dev/null && exit 0 # If in fstab, no need to specify where
where=`find /home /mnt /media/$USER 2> /dev/null | dmenu -p 'Mount? : ' -i`
[ -z "$where" ] && exit 1
if ! [ -d "$where" ]; then
  ans=`echo -e "No\nYes" | dmenu -p "'$where' does not exist. Create it?"`
  [ -z "$ans" ] || [[ "$ans" =~ 'N' ]] && exit 1
  mkdir -p "$where" || exit 2
fi
mount "$disk" "$where" 2>/dev/null || exit 1

ans=`echo -e "No\nYes" | dmenu -p "Add to fstab?"`
[ -z "$ans"] || [[ "$ans" =~ 'N' ]] && exit 0
UUID=`lsblk -lpo NAME,UUID | grep "$disk" | awk '{print $2}'`
FSTYPE=`lsblk -lpo NAME,FSTYPE | grep "$disk" | awk '{print $2}'`
echo "# UUID=$UUID NAME=$disk FSTYPE=$FSTYPE `date '+%D %h %H:%M:%S'`"
echo -e "UUID=$UUID\t$where\t$FSTYPE\tdefaults 0 0"
exit 0
