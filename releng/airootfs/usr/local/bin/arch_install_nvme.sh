#!/bin/bash

##
## Arch installation script for NVMe boot up
## Author: Zhixing.chen
## Date: 2023-04-21
## Copyright � 2023 Zhixing.chen. All rights reserved.
##

DISK=$1
SITE=$2

timezone=Singapore
locale="en_US.UTF-8 UTF-8"

parted -s ${DISK}
parted -s ${DISK} mklabel gpt
parted -s ${DISK} mkpart ESP fat32 1MiB 513MiB
parted -s ${DISK} set 1 boot on

parted -s ${DISK} mkpart primary ext4 513MiB 2GiB  
parted -s ${DISK} mkpart primary ext4 2GiB 62GiB                       # root  disk2
parted -s ${DISK} mkpart primary linux-swap 62GiB 78GiB                # swap  disk3
parted -s ${DISK} mkpart primary ext4 78GiB 100%                       # home  disk4

#make file system
mkfs.fat -F32 ${DISK}p1
echo "y" | mkfs.ext4 ${DISK}p2  # boot
echo "y" | mkfs.ext4 ${DISK}p3  # root
echo "y" | mkfs.ext4 ${DISK}p5  # home
mkswap ${DISK}p4     # swap
swapon ${DISK}p4

#mount the file system
mount ${DISK}p3 /mnt 
mkdir /mnt/home
mkdir -p /mnt/boot
mount ${DISK}p2 /mnt/boot
mkdir -p /mnt/boot/efi
mount ${DISK}p1 /mnt/boot/efi
mount ${DISK}p5 /mnt/home

#pacstrap /mnt $packages 
time cp -vax /run/archiso/airootfs/* /mnt
time cp -va /dev /mnt
cp -va /run/archiso/bootmnt/arch/boot/$(uname -m)/vmlinuz-linux /mnt/boot/vmlinuz-linux
genfstab -U -p /mnt >> /mnt/etc/fstab


arch-chroot /mnt sed -i 's/Storage=volatile/#Storage=auto/' /etc/systemd/journald.conf
arch-chroot /mnt rm -r /etc/systemd/system/{choose-mirror.service,pacman-init.service,etc-pacman.d-gnupg.mount,getty@tty1.service.d}
arch-chroot /mnt rm -rf /etc/systemd/system/getty@tty1.service.d/autologin.conf
arch-chroot /mnt rm -rf /etc/systemd/system/getty@tty1.service.d/autoinstall.conf
arch-chroot /mnt rm -rf /root/{.automated_script.sh,.zlogin}
arch-chroot /mnt rm -rf /etc/mkinitcpio-archiso.conf
arch-chroot /mnt rm -rf /etc/initcpio
arch-chroot /mnt rm -rf /var/lock
arch-chroot /mnt sed -i '52s/.*/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/' /etc/mkinitcpio.conf
arch-chroot /mnt mkinitcpio -p linux

ln -sf /usr/share/zoneinfo/$timezone /mnt/etc/localtime

arch-chroot /mnt /bin/bash << EOF
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

#Install Boot Loader
pacman-key --init
pacman-key --populate archlinux
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "change root passwd.. "
echo "root:admin123" | chpasswd

# Enable SSHD and DHCP-Client for remote access
systemctl enable sshd
systemctl enable dhcpcd

rm -rf /usr/local/bin/arch_install.sh
rm -rf /usr/local/bin/arch_install_uefi.sh
rm -rf /usr/local/bin/arch_install_nvme.sh
rm -rf /usr/local/bin/image_install_gui
rm -rf /etc/xdg/autostart/install.desktop

EOF
sync
reboot
