#!/bin/bash

# miscelaneos a instalar
apt install arc-theme \
  git g++ python-numpy \
  libeigen3-dev zlib1g-dev libqt4-opengl-dev libgl1-mesa-dev \
  libfftw3-dev libtiff5-dev \
  libqt5opengl5 libqt5opengl5-dev \
  libcanberra-gtk3-module libcanberra-gtk-module \
  chromium-browser chrome-gnome-shell \
  x2goclient x2goserver sshfs \
  inkscape keepassx \
  gdebi-core htop tree curl \
  libmng-dev \
  libgtkglext1 \
  tcsh \
  python-qwt5-qt4 \
  gnome-tweaks gnome-shell-extensions \
  moka-icon-theme \
  libssl-dev curl libcurl4-openssl-dev \
  numix-blue-gtk-theme numix-gtk-theme numix-icon-theme \
  papirus-icon-theme \
  tilix shutter \
  cinnamon-desktop-environment plasma-desktop budgie-desktop lxde gnome-session \
  parallel \
  dia \
  xvfb

#update-alternatives --config gdm3.css






# rstudio
echo "[installing rstudio]"
# First we install a PPA for the latest version of R, which is more modern than that in the ubuntu repos
add-apt-repository ppa:marutter/rrutter
apt-get update
apt install r-base r-base-dev
# and now we install rstudio
#wget --progress=bar --directory-prefix=/tmp https://download1.rstudio.org/rstudio-xenial-1.1.456-amd64.deb
wget --progress=bar --directory-prefix=/tmp https://download1.rstudio.org/desktop/bionic/amd64/rstudio-2021.09.1-372-amd64.deb
#gdebi /tmp/rstudio-xenial-1.1.456-amd64.deb
gdebi /tmp/rstudio-2021.09.1-372-amd64.deb
ln -s /usr/lib/rstudio/bin/libicui18n.so.55 /usr/lib/rstudio/bin/libicui18n.so.52
wget --progress=bar --directory-prefix=/tmp http://mirrors.kernel.org/ubuntu/pool/main/libx/libxp/libxp6_1.0.2-1ubuntu1_amd64.deb
gdebi /tmp/libxp6_1.0.2-1ubuntu1_amd64.deb




# para fsl 509
# apt install libmng-dev
ln -sv /usr/lib/x86_64-linux-gnu/libmng.so.2 /usr/lib/x86_64-linux-gnu/libmng.so.1
ln -sv /usr/lib/x86_64-linux-gnu/libjpeg.so.8 /usr/lib/x86_64-linux-gnu/libjpeg.so.62
f=`locate libpng12.so.0 | head -n 1`
cp -v $f /usr/lib/x86_64-linux-gnu/


# para mrtrix
# apt install libgtkglext1
f=/usr/lib/x86_64-linux-gnu/libgsl.so.23
ln -sv $f /usr/lib/x86_64-linux-gnu/libgsl.so.0

# para freesurfer 5.3
# apt install tcsh


# rclone
echo "[installing rclone]"
wget --progress=bar --directory-prefix=/tmp https://downloads.rclone.org/rclone-current-linux-amd64.deb
rclonedeb=/tmp/rclone-current-linux-amd64.deb
if [ -f $rclonedeb ]
then
  gdebi --n $rclonedeb
else
  echo "Did not find .deb for rclone: $rclonedeb"
fi

# atom
echo "[installing atom]"
wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | apt-key add -
sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
apt-get update
apt install atom

# visual studio
echo "[installing visualstudio code]"
#deb=code_1.41.1-1576681836_amd64.deb
#if [ -f $deb ]
#then
#  gdebi --n $deb
#else
#  echo "Did not find .deb for visual studio code: $deb"
#fi

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
apt install apt-transport-https
apt update
apt install code


# google chrome
echolor "[installing google chrome]"
wget --progress=bar --directory-prefix=/tmp https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
deb=/tmp/google-chrome-stable_current_amd64.deb
if [ -f $deb ]
then
  gdebi --n $deb
else
  echo "Did not find .deb for google-chrome: $deb"
fi

# zoom
wget --progress=bar --directory-prefix=/tmp https://zoom.us/client/latest/zoom_amd64.deb
deb=/tmp/zoom_amd64.deb
if [ -f $deb ]
then
  gdebi --n $deb
else
  echo "Did not find .deb for zoom: $deb"
fi




rm -f -v /tmp/*.deb
echo "[finished installing software]"
