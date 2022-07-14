#!/bin/sh

## Script to get useful info about Toradex hardware.
# Date: may-02-2022
# Author: hiagofranco & g-claudino

if [ "`id -u`" != "0" ]; then
	echo "Please, run as root."
	exit
fi

distro_name="`uname -a`"
ref_name="Torizon"
if [[ $distro_name =~ $ref_name ]]; then
	ref_distro=$ref_name
else
	ref_distro="BSP"
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
    if [[ $ref_distro =~ $ref_name ]]; then
    	echo "device-tree-overlays:[`cat /boot/ostree/torizon*/dtb/overlays.txt`]"
    else
	echo "device-tree-overlays:[`cat /boot/overlays.txt`]"
    fi
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
    if [[ $ref_distro =~ $ref_name ]]; then
        echo "`ls -lh /boot/ostree/torizon*/dtb/overlays`"
    else
        echo "`ls -lh /boot/overlays`"
    fi
    echo "-----------------"
}

overlays_enabled(){
    echo "Overlays Enabled:"
    echo "-----------------"
    if [[ $ref_distro =~ $ref_name ]]; then
        echo "device-tree-overlays:[`cat /boot/ostree/torizon*/dtb/overlays.txt`]"
    else
        echo "device-tree-overlays:[`cat /boot/overlays.txt`]"
    fi
    echo "-----------------"
}

help_info ()
{
    echo "Usage: tdx_version.sh [OPTION]"
    echo "List information about hardware and software from Toradex modules."
    echo ""
    echo "--devices, -d     : List all devices in /dev/."
    echo "--dmesg, -dm      : Export the dmesg output in a txt file at ~."
    echo "--help, -h        : Display this message."
    echo "--no-devices, -nd : Diplay hardware and software information without listing devices."
    echo "--overlays, -o    : Display overlay related information."
    echo "--software, -s    : Display only software information."
    echo "--hardware, -w    : Display only hardware information."
    echo ""
}


dmesg_log ()
{
    if [[ $ref_distro =~ $ref_name ]]; then
	    echo "`dmesg`" > /home/torizon/dmesg.txt
    else
	    echo "`dmesg`" > /home/root/dmesg.txt
    fi
}

modules_info (){
    echo "Current list of kernel modules"
    echo "-----------------"
    echo "`lsmod`"
    echo "-----------------"
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
    "--dmesg" | "-dm")
      	dmesg_log
	      ;;
    "--modules" | "-m")
        modules_info
        ;;
    "-a" | "--all" | *)
        software_info
        hardware_info
        devices_info
	overlays_info
        modules_info
        ;;
esac
