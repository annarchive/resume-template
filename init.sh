#!/bin/bash

############################
# Usage:
# File Name: init.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2018-05-03 10:42:59
############################

cd /home/resume
TYPE=$1
if [ "$TYPE"x = "moderncv"x ];then
	TYPE=$1 STYLE=$2 PHONE=$3 EMAIL=$4 HOMEPAGE=$5 GITHUB=$6 COLOR=$7 PHOTO=$8 YAML=$9 WORK=${10} FONT=${11} QUOTE=${12} TPL=${13} ONLINECV=${14} make all-moderncv
else
	TYPE=$1 STYLE=$2 PHONE=$3 EMAIL=$4 HOMEPAGE=$5 GITHUB=$6 COLOR=$7 PHOTO=$8 YAML=$9 WORK=${10} FONT=${11} QUOTE=${12} TPL=${13} ONLINECV=${14} make $TYPE
fi
make clean
