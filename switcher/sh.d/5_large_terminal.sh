#!/usr/bin/env bash

vncserver -kill :1
vncserver -geometry 512x384 -depth 16
ssvncviewer -scale 0.625 :1 -fullscreen -passwd ~/.vnc/passwd &
DISPLAY=:1
xterm
