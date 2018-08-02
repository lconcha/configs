#!/bin/bash

# miscelaneos a instalar
apt install arc-theme \
  git g++ python-numpy \
  libeigen3-dev zlib1g-dev libqt4-opengl-dev libgl1-mesa-dev \
  libfftw3-dev libtiff5-dev \
  libqt5opengl5 libqt5opengl5-dev \
  libcanberra-gtk3-module \
  chromium-browser chrome-gnome-shell \
  x2goclient sshfs \
  inkscape keepassx \
  gdebi-core htop tree curl \
  r-base \
  libmng-dev \
  libgtkglext1 \
  tcsh


# rstudio
#apt install r-base
wget --progress=bar --directory-prefix=/tmp https://download1.rstudio.org/rstudio-xenial-1.1.456-amd64.deb
gdebi /tmp/rstudio-xenial-1.1.456-amd64.deb

# para fsl 509
# apt install libmng-dev
ln -sv /usr/lib/x86_64-linux-gnu/libmng.so.2 /usr/lib/x86_64-linux-gnu/libmng.so.1
ln -sv /usr/lib/x86_64-linux-gnu/libjpeg.so.8 /usr/lib/x86_64-linux-gnu/libjpeg.so.62
f=`locate libpng12.so.0 | head -n 1`
cp -v $f /usr/lib/x86_64-linux-gnu/


# para mrtrix
# apt install libgtkglext1
f=`locate libgsl.so. | head -n 1`
ln -sv $f /usr/lib/x86_64-linux-gnu/libgsl.so.0

# para freesurfer 5.3
# apt install tcsh
