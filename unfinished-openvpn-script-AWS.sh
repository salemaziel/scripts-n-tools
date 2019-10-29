#!/bin/bash

touch ycert-signing-script2 

echo "#!/bin/bash" >> cert-signing-script2

echo "sudo apt install openvpn easy-rsa

cd ~/CA

source ./vars
./clean-all
./build-ca

./build-dh 2048

./build-key client

./build-key client2

./build-key client3

./build-key client4

./build-key client5

openvpn --genkey --secret pfs.key

echo '*****run in your comp: for file in server.crt server.key ca.crt dh2048.pem pfs.key; do scp -i ~/AWS/**SSH-KEY-HERE** ubuntu@$HOSTNAME:~/CA/ ~/AWS/newly-created/ ' 

sleep 60

sudo poweroff " >> cert-signing-script2

chmod +x cert-signing-script2

./cert-signing-script2
