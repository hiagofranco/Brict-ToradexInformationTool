#!/bin/sh

## Script to get useful info about Toradex hardware.
# Date: may-02-2022
# Author: Hiago De Franco <hiago.franco@toradex.com>

if [ "`id -u`" != "0" ]; then
	echo "Please, run as root."
	exit
fi

software_info ()
{
    echo "Software info:"
    echo "-----------------"
    echo "uname-all:[`uname -a`]"
    echo "kernel:[`uname -r`]"
    echo "kernel-version:[`uname -v`]"
    echo "-----------------"
    echo "/etc/os-release:\n`cat /etc/os-release`"
    echo "-----------------"
    echo "/etc/issue:`cat /etc/issue`"
    echo "-----------------"
    echo "uboot-version:"
}

hardware_info ()
{
    echo "\nHardware info:"
    echo "-----------------"
    echo "processor:[`uname -m`]"
    echo "device-tree-overlays:[]"
    echo "fdtfile:[]"
    echo "fdt_board:[]"
    echo "-----------------"
}

devices_info ()
{
    echo "\nAll devices:\n`ls -lh /dev`"
    echo "-----------------"
    echo "END"
}

case $1 in
    "--software" | "-s")
        software_info
        ;;
    "--hardware" | "-h")
        hardware_info
        ;;
    "--devices" | "-d")
        devices_info
        ;;
    "--no-devices" | "-nd")
        software_info
        hardware_info
        ;;
    *)
        software_info
        hardware_info
        devices_info
        ;;
esac
