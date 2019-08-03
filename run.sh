#!/usr/bin/env bash
BASE=$PWD/targets; HOST=bandicoot; mac=21:12:12:21:21:12; sshport=2112
qemu-system-aarch64 \
    -machine type=virt -cpu cortex-a57 -smp 1 -m 2048 -nographic \
    -rtc driftfix=slew -kernel "$BASE"/vmlinuz \
    -append "console=ttyAMA0 root=LABEL=cloudimg-rootfs rw crashkernel=512M-4G:368M" \
    -initrd "$BASE"/initrd.img \
    -device virtio-scsi-device,id=scsi -device scsi-hd,drive=hd \
    -drive if=none,id=hd,file="$BASE"/disk1.img \
    -netdev user,hostfwd=tcp::${sshport}-:22,hostname=$HOST,id=net0 \
    -device virtio-net-device,mac=$mac,netdev=net0 \
    -net nic -net tap,ifname=tap0,script=no

##qemu console via net:
#    -serial telnet:0.0.0.0:1221,server,nowait \
#    -monitor telnet:0.0.0.0:24000,server,nowait
##shared folders
# -fsdev local,id=vdisk0,path="$BASE"/shared,security_model=none \
# -device virtio-9p-device,fsdev=vdisk0,mount_tag=lvdisk0 \
