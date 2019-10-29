#!/usr/bin/env bash

if [ "$(whoami)" != 'root' ]; then
    echo $"Please run with sudo"
        exit 1;
fi

echo -e "
███████╗███████╗██████╗  █████╗ ██████╗  █████╗ ████████╗███████╗
██╔════╝██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝
███████╗█████╗  ██████╔╝███████║██████╔╝███████║   ██║   █████╗  
╚════██║██╔══╝  ██╔═══╝ ██╔══██║██╔══██╗██╔══██║   ██║   ██╔══╝  
███████║███████╗██║     ██║  ██║██║  ██║██║  ██║   ██║   ███████╗
╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝
"                                                               
echo -e "
██████╗ ██████╗ ██╗██╗   ██╗███████╗
██╔══██╗██╔══██╗██║██║   ██║██╔════╝
██║  ██║██████╔╝██║██║   ██║█████╗  
██║  ██║██╔══██╗██║╚██╗ ██╔╝██╔══╝  
██████╔╝██║  ██║██║ ╚████╔╝ ███████╗
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝  ╚══════╝
"
echo -e "
██████╗  █████╗  ██████╗██╗  ██╗██╗   ██╗██████╗ 
██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██║   ██║██╔══██╗
██████╔╝███████║██║     █████╔╝ ██║   ██║██████╔╝
██╔══██╗██╔══██║██║     ██╔═██╗ ██║   ██║██╔═══╝ 
██████╔╝██║  ██║╚██████╗██║  ██╗╚██████╔╝██║     
╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝     
"

sleep 2

echo  "                                                                         "
echo  "                                                                         "
echo  "                                                                         "
echo  "*************************************************************************"
echo  "                                                                         "
echo  " USE A DIFFERENT TOOL IF YOU'RE TRYING TO BACK UP TO SOMETHING ELSE :)   "
echo  "                                                                         "
echo  "                                                                         "
echo  "*************************************************************************"
echo  "                                                                         "
echo  "                                                                         "
echo  "                                                                         "

sleep 3
read -p "Enter full path of directory you want to backup: " path_dir1

mkdir /mnt/backupdrive
mkdir -p /mnt/backupdrive/"$(path_dir1)"
mount /dev/sda1 /mnt/harddrive
mount /dev/sdb3
rm -rf /media/ubuntu/home/*
rsync -aXS --progress --exclude='/*/.gvfs' /mnt/harddrive/old-home. /media/ubuntu/home/.

read -p "Enter the name of your user on the new install, to chown the home folder: " user_name

chown -R $user_name:$user_name /media/ubuntu/home/
