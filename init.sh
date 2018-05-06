#!/bin/bash

############################
# Usage:
# File Name: init.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2018-05-03 10:42:59
############################

cd /home/resume
TYPE=$1 STYLE=$2 PHONE=$3 EMAIL=$4 HOMEPAGE=$5 GITHUB=$6 COLOR=$7 PHOTO=$8 YAML=$9 WORK=${10} FONT=${11} QUOTE=${12} make
make clean
