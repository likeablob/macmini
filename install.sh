#! /bin/bash

[ $(id -u) -gt 0 ] && echo Please run as root! && exit 1

set +x

apt install -y -q \
    bluez \
    tightvncserver \
    ssvnc \
    mplayer \
    chromium-browser \
    basilisk2 \
    matchbox-window-manager \
    nodm \
    xserver-xorg-input-libinput \
    xloadimage \
    pulseaudio \
    pulseaudio-esound-compat \
    pulseaudio-utils \
    pavucontrol

cp -a config/.xinitrc ~/.xinitrc
cp -a config/xstartup ~/.vnc/
cp config/99-fbdev.conf /etc/X11/xorg.conf.d/
cp config/fbtft.conf /etc/modprobe.d/
cp config/asound.conf /etc/
cp config/rc.local /etc/

cd switcher && npm install

echo Done!
