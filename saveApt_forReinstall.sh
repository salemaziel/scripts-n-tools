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



echo_info "Creating directory aptReinstalling in Home folder to save files into"
sleep 2
mkdir $HOME/aptReinstalling.$(date -I)

sudo dpkg --get-selections > $HOME/aptReinstalling.$(date -I)/Package.list
echo_note "Saved list of installed packages in Package.list"
sleep 2

echo_info "Copying your /etc/apt/sources.list and sources.list.d/* to aptReinstalling directory"
sleep 2
sudo rsync -avzh /etc/apt/sources.list* $HOME/aptReinstalling.$(date -I)/

echo_info "exporting Repo gpg keys to Repo.keys"
sudo apt-key exportall > $HOME/aptReinstalling.$(date -I)/Repo.keys
sleep 2

echo_note "You can safely ignore the warning about apt-key output"
sleep 2

echo_prompt "Are there locally/manually installed programs you want to back up as well? [y/n] "
read backup_local

case $backup_local in
	y)
		echo_note "Ok."
		echo_prompt "Are they located in your /opt and or /usr/local/bin folders? [y/n] "
		read opt_usrlocbin
		case $opt_usrlocbin in
			y)
				echo_info "Fsho, backing up those directories"
				sleep 2
				echo_note "If you only wanted one, run: rm -rf UNWANTEDDIRECTORY"
				sleep 2
				echo_warn "Press Ctl+c to cancel at any time"
				sleep 2
				sudo rsync -avzh /opt $HOME/aptReinstalling.$(date -I)/
				echo_note "Finished backing up /opt folder"
				echo _info "Continuing..."
				sleep 3
				sudo rsync -avzh /usr/local/bin $HOME/aptReinstalling.$(date -I)/
				echo_note "Finished backing up /usr/local/bin folder"
				sleep 3
					;;
			n)
				echo_info "Ok, well you probably know what you're doing then "
				sleep 1
				echo_info "You can use the rsync script for yourself lmao"
				sleep 2
				echo_note "For ya trublz, here's the script so you can copy and paste"
				sleep 1
				echo_info "rsync -avzh /path/to/directory/you/want $HOME/aptReinstalling.$(date -I)/"
				sleep 2
					;;
        esac
                ;;
    n)
        echo_note "OK, skipping"
		sleep 2
			;;
esac

echo_info "Copying the reinstallation script into your aptReinstalling folder"
cp Reinstall_savedApt.sh $HOME/aptReinstalling.$(date -I)/
sleep 2

echo_note "Done! Make sure to save this folder aptReinstalling.$(date -I) somewhere it can"
echo_note "be moved back from it to your fresh installation to get back all your apt packages"

