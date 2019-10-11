#!/usr/bin/env bash

vncserver -kill :1
vncserver -geometry 320x240
ssvncviewer -scale 1 :1 -fullscreen -passwd ~/.vnc/passwd &
DISPLAY=:1
cd ~/macmini/minivmac
DISKS=$(ls *dsk | grep -v system.dsk | xargs)
./minivmac.320 system.dsk ${DISKS}
