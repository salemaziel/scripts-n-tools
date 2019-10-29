#!/usr/bin/env bash

state=$1

sudo systemctl "$state" containerd.service

sleep 4

sudo systemctl "$state" docker.service

if test "$state" == "stop"; then
	sudo systemctl "$state" docker.socket
fi

