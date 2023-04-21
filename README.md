# Arch_ISO_Build_Script
Arch ISO Build Script is a powerful tool that allows users to create custom Arch Linux installation images. This script automates the process of creating a bootable ISO image by installing the necessary packages, configuring the system, and adding custom software packages.

#Requirements
To generate the Arch installation ISO, you will need the following packages:

archiso package
Python 3
pyinstaller
PySimpleGUI

#How to Generate Arch Installation ISO
To generate the Arch installation ISO, follow these steps:

Download all required packages.
Open the terminal and navigate to the Arch_ISO_Build_Script directory.
Run the command sudo pacman-key --refresh-keys to refresh the keys.
Run the command sudo mkarchiso -v -w work -o out releng_work to generate the ISO @ out folder.
