"""
Python script provides a GUI for installing images
Author: Zhixing.chen
Date: 2023-04-21
Copyright @ 2023 Zhixing.chen. All rights reserved.
To convert this script to an executable file, PyInstaller can be used
    #pyinstaller --onefile image_install_gui.py
"""

import os
import sys
import PySimpleGUI as sg

def get_available_drive():
    cmd = "ls /dev/sd*"
    cmd = "%s | grep -v [0-9]$" % cmd
    drives_array = os.popen(cmd).read()
    drives_array = drives_array.strip()
    drives_array = drives_array.split("\n")
    print (drives_array)
    cmd = "df -h / /usr"
    os_partitions = os.popen(cmd).read()
    for drive in drives_array:
        print (drive)
        if drive in os_partitions:
            print ("%s is os drive"%drive)
            continue
        else:
            cmd = "udevadm info --query=all --name=%s | grep ID_BUS"%drive
            drive_bus="ATA"
            drive_id_bus = os.popen(cmd).read()
            drive_id_bus = drive_id_bus.strip()
            if "usb" in drive_id_bus:
               drive_bus="USB"
            return [drive_bus,drive]      
    #   get nvme drive 
    if os.path.exists("/dev/nvme0n1"):
         return ["NVMe","/dev/nvme0n1"]               
    return None

available_drive = get_available_drive()
if available_drive == None:
    sg.Popup("No available hard disk or usb disk detected, exit")
    os._exit(1)
if available_drive[0] == "NVMe":
    cmd = "cat /sys/class/nvme/nvme0/model"
    drive_model = os.popen(cmd).read()
    drive_model = drive_model.strip()
    drive_information = "[%s drive]  -  %s"%(available_drive[0],drive_model)    
else:
    cmd = "udevadm info --query=all --name=%s | grep ID_MODEL="%available_drive[1]
    drive_model = os.popen(cmd).read()
    drive_model = drive_model[12:]
    drive_model = drive_model.strip()
    drive_information = "[%s drive]  -  %s"%(available_drive[0],drive_model)
sg.theme('SandyBeach')     
     
layout = [
        [sg.Text('Target Drive:', size =(20, 1)), sg.InputText('%s'%drive_information)],
        [sg.Text('Select Boot Mode:')],
        [sg.T("         "), sg.Radio('Legacy', "RADIO2", default=True, key="LEGACY_BOOT"),sg.Radio('UEFI', "RADIO2", default=False, key="UEFI_BOOT")],          
        [sg.Submit(), sg.Cancel()]
    ]
window = sg.Window('Image Installation', layout)
while True:
    event, values = window.read()  
    if event == sg.WIN_CLOSED or event=="Exit" or event == 'Cancel':
        window.close()
        break
    else:
        if available_drive[0] == "NVMe":
            commandLine = "lxterminal -e bash -lic '/usr/local/bin/arch_install_nvme.sh %s %s'"%(available_drive[1],sie_site)
            from subprocess import Popen
            Popen(commandLine, shell=True)             

        elif values["LEGACY_BOOT"] == True:
            commandLine = "lxterminal -e bash -lic '/usr/local/bin/arch_install.sh %s %s'"%(available_drive[1],sie_site)
            from subprocess import Popen
            Popen(commandLine, shell=True) 
            
        elif values["UEFI_BOOT"] == True:
            commandLine = "lxterminal -e bash -lic '/usr/local/bin/arch_install_uefi.sh %s %s'"%(available_drive[1],sie_site)
            from subprocess import Popen
            Popen(commandLine, shell=True) 
        
   
        


























