#! /bin/bash

[ $(id -u) -gt 0 ] && echo Please run with sudo && exit 1

set -x

apt update && apt install -y -q \
    bluez \
    tightvncserver \
    ssvnc \
    mplayer \
    chromium-browser \
    basilisk2 \
    matchbox-window-manager \
    nodm \
    xserver-xorg-input-libinput \
    xserver-xorg-video-fbdev \
    x11-apps \
    xinit \
    xfonts-base \
    xloadimage \
    tmux \
    pulseaudio \
    pulseaudio-esound-compat \
    pulseaudio-utils \
    pavucontrol

fc-cache -fv # just in case

cp -a config/.xinitrc ~/.xinitrc
cp -a config/.xsession ~/.xsession
cp -a config/.Xdefaults ~/.Xdefaults
cp -a config/xstartup ~/.vnc/
cp config/99-fbdev.conf /etc/X11/xorg.conf.d/
cp config/fbtft.conf /etc/modprobe.d/
echo fbtft_device > /etc/modules-load.d/fbtft.conf
cp config/asound.conf /etc/
cp config/rc.local /etc/
sed -i.orig -e "s/NODM_USER=root/NODM_USER=${SUDO_USER}/" /etc/default/nodm 

sudo -u $SUDO_USER sh -c "cd switcher && npm i --production"

echo Done!
