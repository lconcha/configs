#!/bin/bash

# UBUNTU REPOSITORIES

## miscelaneos a instalar
apt install ssh sshfs \
  git \
  wget \
  htop \
  byobu \
  tree \
  xvfb \
  parallel \
  build-essential \
  cmake \
  curl \
  gdebi-core\
  apcupsd \
  gnome-tweaks gnome-shell-extensions \
  python-is-python3 python3-matplotlib python3-numpy \
  xfonts xfonts-base xfonts-100dpi 

## Apps a instalar
apt install xterm tilix \
  shutter \
  inkscape \
  tcsh \
  x2goclient x2goserver \
  vim
  
	# terminator \ terminal padre pero se isntala por encima del default

apt autoremove




# PPA SOFTWARE

## Installing R base

	# update indices
	apt update -qq
	# install two helper packages we need
	apt install --no-install-recommends software-properties-common dirmngr
	# add the signing key (by Michael Rutter) for these repos
	# To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
	# Fingerprint: E298A3A825C0D65DFD57CBB651716619E084DAB9
	wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
	# add the R 4.0 repo from CRAN -- adjust 'focal' to 'groovy' or 'bionic' as needed
	add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

	apt install --no-install-recommends r-base r-base-dev





## DEB-GET SOFTWARE

#Install deb-get
curl -sL https://raw.githubusercontent.com/wimpysworld/deb-get/main/deb-get | sudo -E bash -s install deb-get

#deb-get install rstudio \ Hay un big en deb-get para esto, revisar si ya fue resuleto

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
	onlyoffice-desktopeditors





# NEUROSTUFF SOFTWARE

## Librerias requeridas
### MRtrix3 (git g++ python-is-python3 instalados en miscelaneos)
apt-get install libeigen3 zlib1g libqt5opengl5 libqt5svg5 libgl1-mesa libfftw3 libtiff5 libpng
### Afni
apt-get install gsl-bin libcurl4-openssl-dev libgdal-dev libglw1-mesa libjpeg62 libnode-dev libopenblas-dev libudunits2-dev libxm4 libxml2-dev

## Pasos adicionales
	# para fsl 509
	# apt install libmng-dev
	#ln -sv /usr/lib/x86_64-linux-gnu/libmng.so.2 /usr/lib/x86_64-linux-gnu/libmng.so.1
	#ln -sv /usr/lib/x86_64-linux-gnu/libjpeg.so.8 /usr/lib/x86_64-linux-gnu/libjpeg.so.62
	#f=`locate libpng12.so.0 | head -n 1`
	#cp -v $f /usr/lib/x86_64-linux-gnu/


	# para mrtrix
	# apt install libgtkglext1
	#f=/usr/lib/x86_64-linux-gnu/libgsl.so.23
	#ln -sv $f /usr/lib/x86_64-linux-gnu/libgsl.so.0

	# para freesurfer 5.3

	# para afni
	ln -s /usr/lib/x86_64-linux-gnu/libgsl.so.23 /usr/lib/x86_64-linux-gnu/libgsl.so.19





# removing .deb in /tmp
rm -f -v /tmp/*.deb

echo "[finished installing software]"
