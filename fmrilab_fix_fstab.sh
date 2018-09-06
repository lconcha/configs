#!/bin/bash

apt install rpcbind nfs-common

# mkdir /home/inb

# cp /etc/fstab /etc/fstab.original

#echo "" >> /etc/fstab
#echo "# fmrilab homes (auto-generado por script `basename $0`" >> /etc/fstab
#echo "tesla:/home/inb /home/inb nfs timeo=14,fsc,intr,bg,resvport,soft,nfsvers=3 0 0" >> /etc/fstab

#mount -av

echo "  No se modifica fstab, porque pondremos los homes a traves de autofs en /etc/auto.home"
