#!/usr/bin/env bash
IMG=bionic-server-cloudimg-arm64.img
pushd targets
qemu-system-aarch64 \
    -machine type=virt -cpu cortex-a57 -smp 1 -m 2048 -nographic \
    -rtc driftfix=slew -kernel vmlinuz \
    -append "console=ttyAMA0 root=LABEL=cloudimg-rootfs rw init=/bin/sh" \
    -initrd initrd.img -device virtio-scsi-device,id=scsi \
    -device scsi-hd,drive=hd -drive if=none,id=hd,file=$IMG
popd
