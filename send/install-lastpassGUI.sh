#!/usr/bin/env bash

if [[ -z $(which node) ]]; then
    echo " ** Installing NodeJS 10 and npm node package manager ** "
    cd ;
    mkdir ~/.npm-global
    curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
    sudo apt update
    sudo apt -y install nodejs
    npm config set prefix "$HOME/.npm-global"
    echo "if [[ -d '$HOME/.npm-global/bin' ]] ; then
        PATH='$HOME/.npm-global/bin:$PATH'
    fi" >> "$HOME/.profile"
    source ~/.profile
    npm install npm -g
fi
npm install npm -g
npm install nativefier -g
wget https://www.macupdate.com/images/icons256/34151.png
mv 34151.png "$HOME/Pictures/lastpass.png"
cd ;
nativefier --name Lastpass --platform linux --arch x64 -i /home/pc/Pictures/icons/lastpass.png "https://lastpass.com/?ac=1"
sudo mv lastpass-linux-x64 /opt/
sudo chown -R root:root /opt/lastpass-linux-x64
sudo ln -s /opt/lastpass-linux-x64/lastpass /usr/local/bin/lastpass
echo "[Desktop Entry]
Name=Lastpass
Exec='/usr/local/bin/lastpass' %U
Terminal=false
Icon=/home/$USER/Pictures/lastpass.png
Type=Application
Categories=Internet;Utilities
StartupNotify=false" | sudo tee /usr/share/applications/lastpass.desktop
sudo chmod ugo+r /usr/share/applications/lastpass.desktop
