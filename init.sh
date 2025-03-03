#!/bin/bash

ssh-keygen -t ed25519 -f ./id_ed25519
sed -i "s:\[ssh-ed25519\]:$(cat ./id_ed25519.pub):g" ./pxe/user-data
sed -i "s:\[password\]:$(openssl passwd -1 -stdin <<< $2):g" ./pxe/user-data
cp ./pxe $1 && cd $1/pxe
wget https://cdimage.ubuntu.com/ubuntu-server/jammy/daily-live/current/jammy-live-server-amd64.iso
mkdir /tmp/iso && mount -t iso9660 -o loop $1/pxe/jammy-live-server-amd64.iso /tmp/iso
cp /tmp/iso/casper/vmlinuz /tftpboot/bios/ && cp /tmp/iso/casper/initrd /tftpboot/bios/
cp /tmp/iso/casper/vmlinuz /tftpboot/uefi/ && cp /tmp/iso/casper/initrd /tftpboot/uefi/
wget http://archive.ubuntu.com/ubuntu/dists/jammy/main/uefi/grub2-amd64/current/grubnetx64.efi.signed
mv ./grubnetx64.efi.signed /tftpboot/grub/pxelinux.0
cd /tmp
wget --no-check-certificate https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.gz
tar -xzf syslinux-6.03.tar.gz && cd ./syslinux-6.03/bios/
cp core/pxelinux.0 com32/elflink/ldlinux/ldlinux.c32 com32/menu/vesamenu.c32 com32/lib/libcom32.c32 com32/libutil/libutil.c32 /tftpboot/bios/