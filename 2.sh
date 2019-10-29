#!/bin/bash

read -p "Internet? " answer_internet
if test $answer_internet == "y"; then
    read -p "Hostname? " fake_host
fi


SND_NET="--nodbus --nogroups --disable-mnt --hostname='$fake_host' --caps.drop=all --no3d --ipc-namespace --netfilter --private-cache --private-tmp --x11=xephyr --xephyr-screen=1366x768"
SND_NONET="--nodbus --net=none --nogroups --disable-mnt --caps.drop=all --no3d --ipc-namespace --private-cache --private-tmp --x11=xephyr --xephyr-screen=1366x768"
NOSND_NET="--machine-id --nodbus --nogroups --disable-mnt --hostname='$fake_host' --caps.drop=all --no3d --ipc-namespace --netfilter --private-cache --private-tmp --x11=xephyr --xephyr-screen=1366x768"
NOSND_NONET="--machine-id --nodbus --net=none --nogroups --disable-mnt --caps.drop=all --no3d --ipc-namespace --private-cache --private-tmp --x11=xephyr --xephyr-screen=1366x768"



read -p "Sound? " answer_sound
read -p "App? " app_name


if test $answer_internet == "y" && test $answer_sound == "y"; then 
    firejail $SND_NET $app_name
    exit 0
fi
if test $answer_internet == "n" && test $answer_sound == "y"; then
    firejail $SND_NONET $app_name
    exit 0
fi
if test $answer_internet == "y" && test $answer_sound == "n"; then
    firejail $NOSND_NET $app_name
    exit 0
else
    firejail $NOSND_NONET $app_name
fi
