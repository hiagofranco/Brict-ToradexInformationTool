#!/bin/sh

## Script to get useful info about Toradex hardware.
# Date: may-02-2022
# Author: Hiago De Franco <hiago.franco@toradex.com>

if [ "`id -u`" != "0" ]; then
	echo "Please, run as root."
	exit
fi

echo "Software info:"
echo "-----------------"
echo "kernel:[`uname -r`]"
echo "kernel-version:[`uname -v`]"
echo "kernel:[`uname -r`]"
echo "-----------------"
echo "os-release:\n`cat /etc/os-release`"
echo "-----------------"
echo "\nHardware info:"
echo "-----------------"
echo "processor:[`uname -m`]"
echo "-----------------"
echo "all devices:\n`ls -lh /dev`"
echo "-----------------"
echo "END"
