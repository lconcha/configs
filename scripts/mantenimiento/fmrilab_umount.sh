#!/bin/bash
if [ $# -eq 0 ]
        then
        echo "Falta carpeta a desmontar"
        exit 0
fi
umount -l /datos/$1
