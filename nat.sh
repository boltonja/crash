#!/usr/bin/env bash
USER=`whoami`
SUBNET=192.168.100
sudo tunctl -u $USER -t tap0
sudo ifconfig tap0 $SUBNET.1 up
