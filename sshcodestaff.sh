#!/bin/bash
cd ~/.ssh

for file in google_compute_engine google_compute_engine.pub google_compute_known_hosts; do mv $file ~/.ssh/newlifemeds-gcloud/$file; done

cd ~/.ssh/getcodestaff.io-gcloud

for file in google_compute_engine google_compute_engine.pub google_compute_known_hosts; do mv $file ~/.ssh/$file; done

cd ~/

gcloud init
