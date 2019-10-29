#!/usr/bin/env bash



echo " *************************************************** "
echo " *************************************************** "
echo " *                                                 * "
echo " *                     WARNING                     * "
echo " *                                                 * "
echo " *       This won't work unless you're running     * "
echo " *       from within the directory containing      * "
echo " *       static website files.                     * "
echo " *                                                 * "
echo " *************************************************** "
echo " *************************************************** "


sleep 2

echo " *************************************************** "
echo "                                                     "
read -p "Are you in the directory containing the static files?[Y/n]  " right_directory
    case "$right_directory" in
        y) echo "Cool, continuing" ;;
        Y) echo "Cool, continuing" ;;
        n) echo "Move to the right directory guy, and try again" && exit 1 ;;
        N) echo "Move to the right directory guy, and try again" && exit 1 ;;
    esac

sleep 2

read -p "Enter customer name, company name, or desired custom subdomain: [MUST BE TWO WORDS AND SEPARATED BY DASH. For example: codestaff-devin]  " "sub"


mv $PWD/auto-mockup.sh $HOME/auto-mockup.sh

surge . "$sub".surge.sh

sleep 1

firefox --browser --display=:0 https://"$sub".surge.sh
