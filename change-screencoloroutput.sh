#!/bin/bash

## https://www.reddit.com/r/GalliumOS/comments/c79jyk/galliumos_30_released/eztscji/?context=3
## Indeed. A simple startup script. Super easy, barely an inconvenience.
##  Switch to full color range 0 - 255; default is broadcast range 16 - 235

sleep 10

xrandr --output HDMI2 --set "Broadcast RGB" "Full"
