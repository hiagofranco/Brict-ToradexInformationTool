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
    echo ""
    echo "Software info:"
    echo "-----------------"
    echo "uname-all:[`uname -a`]"
    echo "kernel:[`uname -r`]"
    echo "kernel-version:[`uname -r | sed -r "s/\+.*//g" | sed -r "s/-.*//g" `]"
    echo "kernel-release:[`uname -v`]"
    echo "BSP-version:[`uname -r | sed -r "s/.*-//g" | sed -r "s/\+.*//g" `]"
    echo "-----------------"
    echo "/etc/os-release:"
    echo "`cat /etc/os-release`"
    echo "-----------------"
    echo "/etc/issue:"
    echo "`cat /etc/issue`"
    echo "-----------------"
    echo "uboot-version:"
    echo "vendor:[`fw_printenv vendor | sed -r "s/.*=//g"`]"
    echo "video args:[`fw_printenv vidargs | sed -r "s/.*=//g"`]"
    echo "secure boot:[`fw_printenv sec_boot | sed -r "s/.*=//g"`]"
    echo "boot delay:[`fw_printenv bootdelay | sed -r "s/.*=//g"`]"
    echo "-----------------"
}

hardware_info ()
{
    echo ""
    echo "Hardware info:"
    echo "-----------------"
    echo "processor:[`uname -m`]"
    echo "device-tree-overlays:[`cat /boot/overlays.txt`]"
    echo "board:[`fw_printenv board | sed -r "s/.*=//g"`]"
    echo "fdt_board:[`fw_printenv fdt_board | sed -r "s/.*=//g"`]"
    echo "soc:[`fw_printenv soc | sed -r "s/.*=//g"`]"
    echo "-----------------"
}

devices_info ()
{
    echo ""
    echo "All devices:"
    echo "-----------------"
    echo "`ls -lh /dev`"
    echo "-----------------"
    echo "END"
}

overlays_info(){
    echo "Overlays Available:"
    echo "-----------------"
    echo "`ls -lh /boot/overlays`"
    echo "-----------------"
}

overlays_enabled(){
    echo "Overlays Enabled:"
    echo "-----------------"
    echo "`cat /boot/overlays.txt`"
    echo "-----------------"
}

help_info ()
{
    echo "Usage: tdx_version.sh [OPTION]"
    echo "List information about hardware and software from Toradex modules."
    echo ""
    echo "--devices, -d     : List all devices in /dev/."
    echo "--help, -h        : Display this message."
    echo "--no-devices, -nd : Diplay hardware and software information without listing devices."
    echo "--overlays, -o    : Display overlay related information."
    echo "--software, -s    : Display only software information."
    echo "--hardware, -w    : Display only hardware information."
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
    "--overlays" | "-o")
        overlays_enabled
	overlays_info
	;;
    "-a" | "--all" | *)
        software_info
        hardware_info
        devices_info
	overlays_info
        ;;
esac
