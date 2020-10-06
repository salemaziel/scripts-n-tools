#!/bin/bash


ANSI_RED=$'\033[1;31m'
ANSI_YEL=$'\033[1;33m'
ANSI_GRN=$'\033[1;32m'
ANSI_VIO=$'\033[1;35m'
ANSI_BLU=$'\033[1;36m'
ANSI_WHT=$'\033[1;37m'
ANSI_RST=$'\033[0m'


echo_cmd()    { echo -e "${ANSI_BLU}${@}${ANSI_RST}"; }
echo_prompt() { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
echo_note()   { echo -e "${ANSI_GRN}${@}${ANSI_RST}"; }
echo_info()   { echo -e "${ANSI_WHT}${@}${ANSI_RST}"; }
echo_warn()   { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
echo_debug()  { echo -e "${ANSI_VIO}${@}${ANSI_RST}"; }
echo_fail()   { echo -e "${ANSI_RED}${@}${ANSI_RST}"; }


echo_note "************************"
echo -e "                          "
echo_info "This script needs to run from within your aptReinstalling folder."
echo_prompt "Are you there now? [y/n]"
read correct_folder

case $correct_folder in
	y)
		echo_info "Cool, continuing"
		sleep 2
			;;
	n)
		echo_info "Copy this script to inside your aptReinstall folder before trying again"
		sleep 3
		echo_info "Quitting"
		sleep 2
		exit
			;;
esac


echo_note "Reimporting Repo.keys and copying source.list"
sleep 2
sudo DEBIAN_FRONTEND=noninteractive apt-key add Repo.keys
sudo rsync -avzh sources.list* /etc/apt/

sleep 2
echo_note "Running apt update and preparing to import your saved package list"
sleep 1
sudo apt update

sudo DEBIAN_FRONTEND=noninteractive apt-get install dselect -y

echo -e "updating dpkg's list of available packages to include your saved ones"
sleep 2
sudo apt-cache dumpavail > $HOME/temp_avail
sudo dpkg --merge-avail $HOME/temp_avail
rm -f $HOME/temp_avail

echo_note "importing and installing saved package list"
sudo dpkg --set-selections < Package.list
sudo DEBIAN_FRONTEND=noninteractive apt-get dselect-upgrade -y

if [[ -x $(ls bin) ]]; then
	echo_info "Copying your backed up /usr/local/bin folder to your current new one"
	sleep 2
	sudo rsync -avzh bin /usr/local/
fi

if [[ -x $(ls opt) ]]; then
	echo "Copying your backed up /opt folder to your current new one"
	sleep 2
	sudo rsync -avzh opt /
fi

sleep 2
echo_note "Done! If there were some errors due to package version issues and dependencies"
echo_info "I recommmend using aptitude (sudo apt install aptitude) to help resolve possible issues"

