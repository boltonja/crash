#!/usr/bin/env bash
IMG=bionic-server-cloudimg-arm64.img
USER=`whoami`
sudo modprobe nbd max_part=8
sudo qemu-nbd --connect=/dev/nbd0 targets/$IMG
sudo mkdir -p /mnt/virt && sudo mount /dev/nbd0p1 /mnt/virt
sudo cp /mnt/virt/boot/*-generic targets/
sudo chown $USER:$USER targets/*-generic
pushd targets
ln -sf vmlinuz-* vmlinuz
ln -sf initrd.img-* initrd.img
ln -sf *cloudimg*img disk1.img
popd
sudo umount /mnt/virt && sudo rmdir /mnt/virt
sudo qemu-nbd -d /dev/nbd0
