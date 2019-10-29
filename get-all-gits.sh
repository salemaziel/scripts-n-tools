#!/bin/bash

read -p "Users Github Username? " github_user

curl -s https://api.github.com/users/($github_user)/repos | jq -r 'map(select(.fork == false)) | map(.url) | map(sub("https://api.github.com/repos/"; "git clone git@github.com:")) | @sh' | xargs -n1 sh -c]
