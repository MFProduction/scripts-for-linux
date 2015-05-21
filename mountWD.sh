#!/bin/bash
# Scrpit for connecting to mycloud -zakladnica 
echo "Mounting WD Cloud"
echo ""
## Variables ##
mount_dir=~/WD
mount_p=$mount_dir/Public
mount_my=$mount_dir/MyData
wd_ip="192.168.0.5"

## Functions ##
function if_dir_exsist () 
{
if [ -d $1 ]; then
	echo "check..."
else
	mkdir $1 
	echo "[CREATE] $1"
fi
}

function clear_dir () 
{
#if is unmounted - remove dir	
if [ -d $1 ]; then
	echo "check..."
else
	mkdir $1 
	echo "[CREATE] $1"
fi
}

function mountwd ()
{
	if grep -qs $1 /proc/mounts; then
	  echo "[Allredy mounted] $1"
	else
	 # echo "[Not mounted] $1."
	   sudo mount -t cifs -o sec=none,uid=1000 //192.168.0.5/Public  $1
	  if [ $? -eq 0 ]; then
	    echo "[Mount success]  $1"
	  else
	    echo "[Mount error] $1"
	  fi
	fi
}

function umwd () 
{
	echo "unmounting"
	sudo umount $1
}

## MAIN
if_dir_exsist $mount_dir
if_dir_exsist $mount_p
if_dir_exsist $mount_my

case "$1" in
	"-m")
		mountwd $mount_p
		mountwd $mount_my
		;;
	"-u")
		umwd $mount_p
		umwd $mount_my
		;;
	-h)
		echo "usage: [-m]ount [-u]mount"
		;;
	*) 
		echo "usage: [-m]ount [-u]mount"
		exit 1
		;;
esac
