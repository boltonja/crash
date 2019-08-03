#!/usr/bin/env bash
RELEASE=4.15.0-55-generic
ARCH=arm64
~/bin/crash-arm64 --mod /usr/lib/debug/lib/modules/$RELEASE/ /usr/lib/debug/boot/vmlinux-$RELEASE targets/dump.201908041117
