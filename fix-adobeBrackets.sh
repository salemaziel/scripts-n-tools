#!/bin/bash

ANSI_RED=$'\033[1;31m'
ANSI_YEL=$'\033[1;33m'
ANSI_GRN=$'\033[1;32m'
ANSI_VIO=$'\033[1;35m'
ANSI_BLU=$'\033[1;36m'
ANSI_WHT=$'\033[1;37m'
ANSI_RST=$'\033[0m'

echo_cmd()    { echo -e "${ANSI_BLU}${@}${ANSI_RST}"; }
echo_prompt()   { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
echo_note()   { echo -e "${ANSI_GRN}${@}${ANSI_RST}"; }
echo_info() { echo -e "${ANSI_WHT}${@}${ANSI_RST}"; }
echo_warn()   { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
echo_debug()  { echo -e "${ANSI_VIO}${@}${ANSI_RST}"; }
echo_fail()   { echo -e "${ANSI_RED}${@}${ANSI_RST}"; }


fix_deb() {
	echo_note "Opening deb package"
        dpkg-deb -R Brackets.Release.*.deb Brackets-fixed
        echo_note "Replacing dependency libcurl3 with libcurl4"
        sed -i 's/libcurl3/libcurl4/g' Brackets-fixed/DEBIAN/control
        echo_note "Repackaging to Brackets-fixed.deb file"
        dpkg-deb -b Brackets-fixed Brackets-fixed.deb
}

install_fixed() {
echo_prompt "Install now? [y/n]"
read install_now
case $install_now in
	y)
		if [[ -z $(which gdebi) ]]; then
			sudo gdebi -n Brackets-fixed.deb
			echo_note "Brackets has been installed"
			sleep 2
			exit 0
		else
			sudo dpkg -i Brackets-fixed.deb
			echo_note "Brackets has been installed"
			sleep 2
			exit 0
		fi
			;;
	n)
		echo_note "Ok, exiting"
		sleep 1
		exit 0
		;;
esac
}


echo_prompt "Enter the absolute path to the folder Brackets Release deb file is in. "
echo_info "If you don't know the path, or what a path is, enter: idk "
read 'wheres_brackets'

case $wheres_brackets in
	idk)
		echo_prompt "Ok, enter the name of the folder its in \n (case-sensitive) "
		read brackets_folder
		echo_note "Looking for $brackets_folder "
		possible_folders=$(find $HOME/ -name "$brackets_folder") > /dev/null 2>&1
		brackets_path=$(find $possible_folders/ -name "Brackets.Release.*.deb")
		echo $brackets_path
		sleep 3
		echo_prompt "Is this correct? [y/n] "
		read path_correct
		case $path_correct in
			y)
				echo_note "Opening deb package"
				sleep 1
				dpkg-deb -R $brackets_path Brackets-fixed #Brackets.Release.*.deb Brackets-fixed
				echo_note "Replacing dependency libcurl3 with libcurl4"
				sleep 2
				sed -i 's/libcurl3/libcurl4/g' Brackets-fixed/DEBIAN/control
				echo_note "Repackaging to Brackets-fixed.deb file"
				dpkg-deb -b Brackets-fixed Brackets-fixed.deb
				echo_prompt "Install now? [y/n]"
				read install_now
				case $install_now in
					y)
						if [[ -z $(which gdebi) ]]; then
							sudo gdebi -n Brackets-fixed.deb > /dev/null 2>&1
							echo_note "Brackets has been installed"
							sleep 2
							exit 0
						else
							sudo dpkg -i Brackets-fixed.deb
							echo_note "Brackets has been installed"
							sleep 2
							exit 0
						fi
							;;
					n)
						echo_note "Ok, exiting"
						sleep 2
						exit 0
							;;
				esac
					;;
			n)
				echo_warn "Sorry, try again"
				sleep 2
				exit 0
					;;
		esac
			;;
	*)
		cd $wheres_brackets
		fix_deb
		install_fixed
			;;
esac


