#!/usr/bin/env bash

switch=$1

case "$switch" in
	'stop') gcloud compute instances stop workspace2 --zone=us-west1-b ;;
	'off') gcloud compute instances stop workspace2 --zone=us-west1-b ;;
	'start') gcloud compute instances start workspace2 --zone=us-west1-b ;;
	'on') gcloud compute instances start workspace2 --zone=us-west1-b ;;
	'status') gcloud compute instances list | grep workspace2 | grep --color -E "RUNNING|TERMINATED" ;;
esac
