#!/bin/bash

# UBUNTU REPOSITORIES

## CLI apps
apt -y install ssh sshfs \
  git \
  wget \
  htop \
  byobu screen \
  tree \
  xvfb \
  parallel \
  build-essential \
  cmake \
  curl \
  gdebi-core\
  apcupsd \
  python-is-python3 python3-matplotlib python3-numpy \
  xfonts-base xfonts-100dpi

## Apps
apt -y install gnome-tweaks gnome-shell-extensions \
  xterm tcsh tilix \
  shutter \
  inkscape \
  x2goclient x2goserver \
  vlc \
  vim
  
	# terminator \ terminal padre pero se instala por encima del default

apt -y autoremove

### añadidos para mrtrix y afni: python-is-python3 python3-matplotlib python3-numpy 
### añadidos para afni: tcsh, xfonts-base, xfonts-100dpi


# PPA SOFTWARE

## Installing R base

	# update indices
	apt update -qq
	# install two helper packages we need
	apt -y install --no-install-recommends software-properties-common dirmngr
	# add the signing key (by Michael Rutter) for these repos
	# To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
	# Fingerprint: E298A3A825C0D65DFD57CBB651716619E084DAB9
	wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
	# add the R 4.0 repo from CRAN -- adjust 'focal' to 'groovy' or 'bionic' as needed
	add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

	apt -y install --no-install-recommends r-base r-base-dev





## DEB-GET SOFTWARE

#Install deb-get
curl -sL https://raw.githubusercontent.com/wimpysworld/deb-get/main/deb-get | sudo -E bash -s install deb-get

#deb-get install rstudio \ Hay un bug en deb-get para esto, revisar si ya fue resuleto

deb-get install code \
	rclone \
	gitkraken \
	zotero \
	pandoc \
	zoom \
	google-chrome-stable \
	brave-browser \
	bitwarden keepassxc \
	sejda-desktop \
	rocketchat \
	bat lsd duf fd \
	onlyoffice-desktopeditors \
        micro

# NEUROSTUFF SOFTWARE

## MRtrix3 (git g++ python-is-python3 instalados arriba)
apt -y  install zlib1g libqt5opengl5 libqt5svg5 libtiff5 libeigen3-dev libgl1-mesa-dev libfftw3-dev libpng-dev
	# en las instrucciones de mrtrix todos eran packetes -dev  

## Afni (python stuff, tcsh, xfonts-base, xfonts-100dpi instalados arriba)
apt -y install gsl-bin libcurl4-openssl-dev libgdal-dev libglw1-mesa libjpeg62 libnode-dev libopenblas-dev libudunits2-dev libxm4 libxml2-dev libssl-dev
	# faltan para el 22.04  libgfortran4 libgfortran-8-dev
#### link simbolico que afni requiere
#ln -s /usr/lib/x86_64-linux-gnu/libgsl.so.23 /usr/lib/x86_64-linux-gnu/libgsl.so.19 # Ubunu 20.04
ln -sf /usr/lib/x86_64-linux-gnu/libgsl.so.27 /usr/lib/x86_64-linux-gnu/libgsl.so.19


## para fsl 509
# apt install libmng-dev
#ln -sv /usr/lib/x86_64-linux-gnu/libmng.so.2 /usr/lib/x86_64-linux-gnu/libmng.so.1
#ln -sv /usr/lib/x86_64-linux-gnu/libjpeg.so.8 /usr/lib/x86_64-linux-gnu/libjpeg.so.62
#f=`locate libpng12.so.0 | head -n 1`
#cp -v $f /usr/lib/x86_64-linux-gnu/


## para mrtrix (version anteior?)
# apt install libgtkglext1
#f=/usr/lib/x86_64-linux-gnu/libgsl.so.23
#ln -sv $f /usr/lib/x86_64-linux-gnu/libgsl.so.0

# para freesurfer 5.3






# Terminando la instalacion

## removing .deb in /tmp
rm -f -v /tmp/*.deb

echo "[finished installing software]"
