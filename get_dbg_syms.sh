#!/usr/bin/env bash
RELEASE=4.15.0-55-generic
ARCH=arm64
sudo dpkg --add-architecture $ARCH
sudo apt-get update
sudo apt-get install linux-image-$RELEASE-dbgsym:$ARCH
