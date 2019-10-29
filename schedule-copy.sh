#!/usr/bin/env bash

answer_title=$1

if test "$answer_title" == ""; then
	read -p "Title of scheduled popup notification? " answer_title
fi
read -p "Content of scheduled popup notification? " answer_content
read -p "Show notification at what time?[Format: 4:20 pm]  " answer_time1
read -p "Show more notifications?[y/n] " answer_more
if test "$answer_more" == "y"; then
	read -p "Show 2nd notification at what time? " answer_time2
	read -p "Show more notifications?[y/n] " answer_more2
		if test "$answer_more2" == "y"; then
			 read -p "Show 3rd notification at what time? " answer_time3
		fi
fi

echo DISPLAY=:0 kdialog --warningcontinuetocancel "$answer_content" --title="$answer_title" | at "$answer_time1"

if test "$answer_more" == "y"; then
	echo DISPLAY=:0 kdialog --warningcontinuetocancel "$answer_content" --title="$answer_title" | at "$answer_time2"
	if test "$answer_more2" == "y"; then
		echo DISPLAY=:0 kdialog --warningcontinuetocancel "$answer_content" --title="$answer_title" | at "$answer_time3"
	fi
else
	exit 0
fi

