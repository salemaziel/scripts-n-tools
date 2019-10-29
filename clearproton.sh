#!/usr/bin/env bash

rm -rf /home/pc/.protonvpn-cli/connection_logs
touch /home/pc/.protonvpn-cli/connection_logs
chmod 600 /home/pc/.protonvpn-cli/connection_logs

rm -rf /home/pc/.protonvpn-cli/openvpn_cache/*

rm -f /home/pc/.protonvpn-cli/.previous_connection_config_id
rm -f /home/pc/.protonvpn-cli/.previous_connection_selected_protocol

rm -rf /home/pc/.protonvpn-cli/.response_cache
touch /home/pc/.protonvpn-cli/.response_cache
chmod 600 /home/pc/.protonvpn-cli/.response_cache

rm -f /home/pc/.protonvpn-cli/.response_cache.tmp
touch /home/pc/.protonvpn-cli/.response_cache.tmp
chmod 600 /home/pc/.protonvpn-cli/.response_cache.tmp
