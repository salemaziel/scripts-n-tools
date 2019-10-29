#!/usr/bin/env bash

sub=$(kdialog --title "Enter Custom Subdomain Url"  --inputbox "Enter personalized subdomain label. Must be two words separated by dash; e.g. codestaff-io or devins-website")

if [[ $? = 0 ]] ; then
		kdialog --title "Confirm Custom Url" --yesnocancel "You entered $sub ; is this correct? "
            if [[ $? = 1 ]] ; then
                echo "Exiting; Re-run this command to enter the correct subdomain"
                exit 1
            fi
fi

webroot=$(kdialog --title "Select WebRoot Directory" --getexistingdirectory)
if [[ $? = 0 ]] ; then
    cd $webroot || exit 1
fi

surge . "$sub".surge.sh

xdg-open https://$sub.surge.sh
