#!/usr/bin/env bash
sudo pvpn -d
sync
sleep 2
systemctl reboot
