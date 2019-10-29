#!/usr/bin/env bash

test=$1

DISPLAY=:0 zenity --warning --text="Go check on your phone!" --title="$test"
