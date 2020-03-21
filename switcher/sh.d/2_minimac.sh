#!/usr/bin/env bash

vncserver -kill :1
vncserver -geometry 320x240 -depth 24
ssvncviewer -scale 1 :1 -fullscreen -passwd ~/.vnc/passwd &
DISPLAY=:1
cd ~/macmini/minivmac
DISKS=$(ls *dsk | grep -v system.dsk | xargs)
ARCH=$(uname -i)
./minivmac.${ARCH}.320 system.dsk ${DISKS}
