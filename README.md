# Arch_ISO_Build_Script

- Author: Zhixing.chen czxsg2010@gmail.com
- Copyright (c) 2023 Zhixing.chen

Arch ISO Build Script is a powerful tool that allows users to create custom Arch Linux installation images. This script automates the process of creating a bootable ISO image by installing the necessary packages, configuring the system, and adding custom software packages.

# Requirement
To generate the Arch installation ISO, you will need the following packages:

- archiso package

# How to Generate Arch Installation ISO
To generate the Arch installation ISO, follow these steps:

- Download all required packages.
- Open the terminal and navigate to the Arch_ISO_Build_Script directory.
- Run the command sudo pacman-key --refresh-keys to refresh the keys.
- Run the command sudo mkarchiso -v -w work -o out releng_work to generate the ISO @ <out> folder.
  - [ Arch_ISO_Build_Script ] $ ls
     - image_install_gui  out  releng  work
  - [ out ]$ ls
    - archlinux-2023.04.21-x86_64.iso


# How to Customize your image_installation_gui
![GitHub Logo](/image_installation_gui.png)
  - Requirement
    - python3
    - python3 pyinstaller module
    - python3 PySimpleGUI module
  - navigate to the Arch_ISO_Build_Script/image_installation_gui directory and run <pyinstaller --onefile image_install_gui.py>
  

  
