#!/usr/bin/env bash

vncserver -kill :1
vncserver -geometry 512x384 -depth 24
ssvncviewer -scale 0.625 :1 -fullscreen -passwd ~/.vnc/passwd &
DISPLAY=:1
cd ~/macmini/minivmac
DISKS=$(ls *dsk | grep -v system.dsk | xargs)
ARCH=$(uname -i)
./minivmac.${ARCH}.512 system.dsk ${DISKS}
