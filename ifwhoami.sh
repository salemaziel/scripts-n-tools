#!/usr/bin/env bash

if [ "$(whoami)" != 'root' ]; then
    echo $"Please run with sudo"
        exit 1;
fi
