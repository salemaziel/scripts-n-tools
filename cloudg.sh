#!/usr/bin/env bash

switch=$1


gcloud compute instances $switch workspace2 --zone=us-west1-b
