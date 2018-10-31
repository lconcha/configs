#!/bin/bash

apt install rpcbind nfs-common autofs



fmrilab_misc=./fmrilab_auto.misc
fmrilab_home=./fmrilab_auto.home
fmrilab_master=./auto.master

tmpMisc=/tmp/tmpMisc_$$


cp -v /etc/auto.misc /etc/auto.misc.bak
cp -v $fmrilab_misc /etc/auto.misc
cp -v $fmrilab_master /etc/auto.master
cp -v $fmrilab_home /etc/auto.home




echo "Habilitando cache para NFS y teoricamente para autofs"
apt install cachefilesd 
sed -i 's/#RUN=yes/RUN=yes/' /etc/default/cachefilesd

service cachefilesd restart
service autofs restart
