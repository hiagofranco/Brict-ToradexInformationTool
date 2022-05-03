#!/bin/sh

## Script to get useful info about Toradex hardware.
# Date: may-02-2022
# Author: hiagofranco

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
    echo "vendor:[`fw_printenv vendor`]"
    echo "video args:[`fw_printenv vidargs`]"
    echo "secure boot:[`fw_printenv sec_boot`]"
    echo "boot delay:[`fw_printenv bootdelay`]"
    echo "-----------------"
}

hardware_info ()
{
    echo "\nHardware info:"
    echo "-----------------"
    echo "processor:[`uname -m`]"
    echo "device-tree-overlays:[]"
    echo "board:[`fw_printenv board`]"
    echo "fdt_board:[`fw_printenv fdt_board`]"
    echo "soc:[`fw_printenv soc`]"
    echo "-----------------"
}

devices_info ()
{
    echo "\nAll devices:\n`ls -lh /dev`"
    echo "-----------------"
    echo "END"
}

help_info ()
{
    echo "Usage: tdx_version.sh [OPTION]"
    echo "List information about hardware and software from Toradex modules."
    echo ""
    echo "--help, -h        : Display this message."
    echo "--software, -s    : Display only software information."
    echo "--hardware, -w    : Display only hardware information."
    echo "--devices, -d     : List all devices in /dev/."
    echo "--no-devices, -nd : Diplay hardware and software information without listing devices."
    echo ""
}

case $1 in
    "--help" | "-h")
        help_info 
        ;;
    "--software" | "-s")
        software_info
        ;;
    "--hardware" | "-w")
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
