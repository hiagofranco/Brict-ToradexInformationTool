#!/bin/sh

## Script to get useful info about Toradex hardware.
# Date: may-02-2022
# Author: hiagofranco & g-claudino

software_info ()
{
    uboot_version=$(tr -d '\0' </proc/device-tree/chosen/u-boot,version)
    uboot_env_vendor=$(fw_printenv vendor | sed -r "s/.*=//g")
    uboot_env_vidargs=$(fw_printenv vidargs | sed -r "s/.*=//g")
    uboot_env_sec_boot=$(fw_printenv sec_boot | sed -r "s/.*=//g")
    uboot_env_bootdelay=$(fw_printenv bootdelay | sed -r "s/.*=//g")
    kernel_version=$(uname -rv)
    kernel_cmdline=$(cat /proc/cmdline)
    if [[ -f /etc/os-release ]]; then
        distro_name=$(cat /etc/os-release | grep ^NAME)
        distro_version=$(cat /etc/os-release | grep VERSION_ID)
    else
        distro_name=$(cat /etc/issue)
        distro_version=""
    fi
    hostname=$(cat /etc/hostname)

    echo ""
    echo "Software info"
    echo "-----------------"
    echo "U-Boot-version:[$uboot_version]"
    echo "U-Boot vendor:[$uboot_env_vendor]"
    echo "U-Boot video args:[$uboot_env_vidargs]"
    echo "U-Boot secure boot:[$uboot_env_sec_boot]"
    echo "U-Boot boot delay:[$uboot_env_bootdelay]"
    echo "Kernel version:[$kernel_version]"
    echo "Kernel command line:[$kernel_cmdline]"
    echo "Distro name:[$distro_name]"
    echo "Distro version:[$distro_version]"
    echo "Hostname:[$hostname]"
    echo "-----------------"
}

hardware_info ()
{
    som_model=$(tr -d '\0' </proc/device-tree/model)
    som_pid4=$(tr -d '\0' </proc/device-tree/toradex,product-id)
    som_pid8=$(tr -d '\0' </proc/device-tree/toradex,board-rev)
    serial=$(tr -d '\0' </proc/device-tree/serial-number)
    processor=$(uname -m)
    uboot_env_board=$(fw_printenv board | sed -r "s/.*=//g")
    uboot_env_fdt_board=$(fw_printenv fdt_board | sed -r "s/.*=//g")
    uboot_env_soc=$(fw_printenv soc | sed -r "s/.*=//g")

    echo ""
    echo "Hardware info"
    echo "-----------------"
    echo "SoM model:[$som_model]"
    echo "SoM version:[$som_pid4 $som_pid8]"
    echo "SoM serial number:[$serial]"
    echo "Processor arch:[$processor]"
    echo "U-Boot board:[$uboot_env_board]"
    echo "U-Boot fdt_board:[$uboot_env_fdt_board]"
    echo "U-Boot soc:[$uboot_env_soc]"
    echo "-----------------"
}

device_tree_info()
{
    dt_compatible=$(tr -d '\0' </proc/device-tree/compatible)
    dt_used=$(fw_printenv fdtfile | sed -r "s/.*=//g")
    if [[ -d /boot/ostree ]]; then
        stateroot=$(cat /proc/cmdline | awk -F "ostree=" '{print $2}' | awk '{print $1}' | awk -F "/" '{print $5}')
        dt_available=$(ls /boot/ostree/torizon-$stateroot/dtb/ | grep dtb)
        if [[ -f /boot/ostree/torizon-$stateroot/dtb/overlays.txt ]]; then
            dto_enabled=$(cat /boot/ostree/torizon-$stateroot/dtb/overlays.txt)
            dto_available=$(ls /boot/ostree/torizon-$stateroot/dtb/overlays)
        else
            dto_enabled=""
            dto_available=""
        fi
    else
        dt_available=$(ls /boot/ | grep dtb)
        if [[ -f /boot/overlays.txt ]]; then
            dto_enabled=$(cat /boot/overlays.txt)
            dto_available=$(ls /boot/overlays)
        else
            dto_enabled=""
            dto_available=""
        fi
    fi

    echo ""
    echo "Device tree"
    echo "-----------------"
    echo "Device tree enabled:[$dt_used]"
    echo "Compatible string:[$dt_compatible]"
    echo "Device trees available:[$dt_available]"
    echo "-----------------"

    echo ""
    echo "Device tree overlays"
    echo "-----------------"
    echo "Overlays enabled:[$dto_enabled]"
    echo "Overlays available:[$dto_available]"
    echo "-----------------"
}

devices_info ()
{
    devices=$(ls -lh /dev)

    echo ""
    echo "Devices"
    echo "-----------------"
    echo "All devices available:[$devices]"
    echo "-----------------"
}

modules_info ()
{
    lsmod=$(lsmod)

    echo ""
    echo "Kernel modules"
    echo "-----------------"
    echo "Kernel modules loaded:[$lsmod]"
    echo "-----------------"
}

dmesg_log ()
{
    loggeduser=${SUDO_USER:-$(logname)}
    echo "$(dmesg)" > /home/$loggeduser/dmesg.txt
    chown $loggeduser:$loggeduser /home/$loggeduser/dmesg.txt
}

distro_detect ()
{
    # For (arguably) any modern distro, rely on /etc/os-release
    if [[ -f /etc/os-release ]]; then
        export "DISTRO_$(cat /etc/os-release | grep ^NAME)"
    else
        DISTRO_NAME="Unknown"
    fi
}

help_info ()
{
    echo "Usage: tdx_version.sh [OPTION]"
    echo "List information about hardware and software from Toradex modules."
    echo ""
    echo "--devices, -d      : List all devices in /dev/."
    echo "--device-tree, -dt : Display device tree and overlays related information."
    echo "--dmesg, -dm       : Export the dmesg output in a txt file at ~."
    echo "--hardware, -w     : Display only hardware information."
    echo "--help, -h         : Display this message."
    echo "--no-devices, -nd  : Diplay hardware and software information without listing devices."
    echo "--software, -s     : Display only software information."
    echo ""
}

# Main

if [ "$(id -u)" != "0" ]; then
    echo "Please, run as root."
    exit
fi

distro_detect

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
    "--device-tree" | "-dt")
        device_tree_info
        ;;
    "--devices" | "-d")
        devices_info
        ;;
    "--no-devices" | "-nd")
        software_info
        hardware_info
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
        device_tree_info
        devices_info
        modules_info
        ;;
esac
