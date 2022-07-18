# Brict 
Script to get useful information about Toradex Hardware. The goal of this script is to run it once and get as much information about hardware and software as it can.


* Usage: brict [options]

- Nothing, “-a“ or “--all“: it’ll print everything.
- “-s” or “--software“ for software information only.
- “-w“ or “--hardware“ for hardware information only.
- “-d“ or “--devices“for device lists only.
- “-dm” or “--dmesg” to generate a dmesg log in a text file.
- “-nd“ or “--no-devices“ for everything except the device list.
- “-h“ or “--help“ for help.
- “-o“ or “--overlays“ for overlay related information (still only working with Torizon).
