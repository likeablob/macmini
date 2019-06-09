#!/usr/bin/env bash

vncserver -kill :1
vncserver -geometry 512x384
ssvncviewer -scale 0.625 :1 -fullscreen -passwd ~/.vnc/passwd &
DISPLAY=:1
cd ~/macmini/minivmac
./minivmac.512 vmac.rom system.dsk
