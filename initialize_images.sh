#!/usr/bin/env bash
pushd targets
wget https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-arm64.img
dd if=/dev/zero of=flash0.img bs=1M count=64
dd if=/usr/share/qemu-efi/QEMU_EFI.fd of=flash0.img conv=notrunc
dd if=/dev/zero of=flash1.img bs=1M count=64
popd

