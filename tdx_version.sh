#!/bin/sh

## Script to get useful info about Toradex hardware.
# Date: may-02-2022
# Author: hiagofranco & g-claudino

if [ "$(id -u)" != "0" ]; then
    echo "Please, run as root."
    exit
fi

distro_name=$(uname -a)
ref_name="Torizon"
if [[ $distro_name =~ $ref_name ]]; then
    ref_distro=$ref_name
else
    ref_distro="BSP"
fi

software_info ()
{
    uname=$(uname -a)
    kernel=$(uname -r)
    kernel_version=$(echo $kernel | sed -r "s/\+.*//g" | sed -r "s/-.*//g")
    kernel_release=$(uname -v)
    bsp_version=$(echo $kernel | sed -r "s/.*-//g" | sed -r "s/\+.*//g")
    os_release=$(cat /etc/os-release)
    etc_issue=$(cat /etc/issue)
    uboot_version=$(tr -d '\0' </proc/device-tree/chosen/u-boot,version)
    uboot_env_vendor=$(fw_printenv vendor | sed -r "s/.*=//g")
    uboot_env_vidargs=$(fw_printenv vidargs | sed -r "s/.*=//g")
    uboot_env_sec_boot=$(fw_printenv sec_boot | sed -r "s/.*=//g")
    uboot_env_bootdelay=$(fw_printenv bootdelay | sed -r "s/.*=//g")

    echo ""
    echo "Software info:"
    echo "-----------------"
    echo "uname-all:[$uname]"
    echo "kernel:[$kernel]"
    echo "kernel-version:[$kernel_version]"
    echo "kernel-release:[$kernel_release]"
    echo "BSP-version:[$bsp_version]"
    echo "-----------------"
    echo "/etc/os-release:"
    echo "$os_release"
    echo "-----------------"
    echo "/etc/issue:"
    echo "$etc_issue"
    echo "-----------------"
    echo "U-Boot-version:[$uboot_version]"
    echo "vendor:[$uboot_env_vendor]"
    echo "video args:[$uboot_env_vidargs]"
    echo "secure boot:[$uboot_env_sec_boot]"
    echo "boot delay:[$uboot_env_bootdelay]"
    echo "-----------------"
}

hardware_info ()
{
    som_model=$(tr -d '\0' </proc/device-tree/model)
    som_pid4=$(tr -d '\0' </proc/device-tree/toradex,product-id)
    som_pid8=$(tr -d '\0' </proc/device-tree/toradex,board-rev)
    processor=$(uname -m)
    uboot_env_board=$(fw_printenv board | sed -r "s/.*=//g")
    uboot_env_fdt_board=$(fw_printenv fdt_board | sed -r "s/.*=//g")
    uboot_env_soc=$(fw_printenv soc | sed -r "s/.*=//g")

    echo ""
    echo "Hardware info:"
    echo "-----------------"
    echo "SoM model:[$som_model]"
    echo "SoM version:[$som_pid4 $som_pid8]"
    echo "Processor arch:[$processor]"
    echo "U-Boot board:[$uboot_env_board]"
    echo "U-Boot fdt_board:[$uboot_env_fdt_board]"
    echo "U-Boot soc:[$uboot_env_soc]"
    echo "-----------------"
}

overlays_info(){
    if [[ $ref_distro =~ $ref_name ]]; then
        stateroot=$(cat /proc/cmdline | awk -F "ostree=" '{print $2}' | awk '{print $1}' | awk -F "/" '{print $5}')
        dto_enabled=$(cat /boot/ostree/torizon-$stateroot/dtb/overlays.txt)
        dto_available=$(ls /boot/ostree/torizon-$stateroot/dtb/overlays)
    else
        dto_enabled=$(cat /boot/overlays.txt)
        dto_available=$(ls /boot/overlays)
    fi

    echo ""
    echo "Device Tree Overlays:"
    echo "-----------------"
    echo "Device tree overlays enabled:[$dto_enabled]"
    echo "Device tree overlays available:[$dto_available]"
    echo "-----------------"
}

devices_info ()
{
    devices=$(ls -lh /dev)

    echo ""
    echo "All devices:"
    echo "-----------------"
    echo "$devices"
    echo "-----------------"
    echo "END"
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
        echo "$(dmesg)" > /home/torizon/dmesg.txt
    else
        echo "$(dmesg)" > /home/root/dmesg.txt
    fi
}

modules_info (){
    lsmod=$(lsmod)

    echo "Current list of kernel modules"
    echo "-----------------"
    echo "$lsmod"
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
        overlays_info
        devices_info
        modules_info
        ;;
esac
