#!/bin/bash
cd ~/.ssh

for file in google_compute_engine google_compute_engine.pub google_compute_known_hosts; do mv $file ~/.ssh/getcodestaff.io-gcloud/$file; done

cd ~/.ssh/newlifemeds-gcloud

for file in google_compute_engine google_compute_engine.pub google_compute_known_hosts; do mv $file ~/.ssh/$file; done

cd ~/

gcloud init
