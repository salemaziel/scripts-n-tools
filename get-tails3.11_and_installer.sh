#!/bin/bash

wget --continue http://dl.amnesia.boum.org/tails/stable/tails-amd64-3.11/tails-amd64-3.11.iso

wget https://tails.boum.org/torrents/files/tails-amd64-3.11.iso.sig

TZ=UTC gpg --no-options --keyid-format 0xlong --verify tails-amd64-3.11.iso.sig tails-amd64-3.11.iso

sudo add-apt-repository universe

sudo add-apt-repository ppa:tails-team/tails-installer

sudo apt update

sudo apt install tails-installer
