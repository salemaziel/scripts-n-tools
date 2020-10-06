#!/usr/bin/env bash

read -p "Does it look the same? " "looksame"
    case $looksame in
        Y) echo "Cool, continuing";;
        y) echo "Cool, continuing";;
        N) echo "Uh oh, exiting" && exit 1 ;;
        n) echo "Uh oh, exiting" && exit 1 ;;
    esac
