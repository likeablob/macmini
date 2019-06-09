#!/usr/bin/env bash

MACMINI_DIR=~/macmini
xloadimage  ${MACMINI_DIR}/images/macface.png -fullscreen -onroot
[ -e ${MACMINI_DIR}/macboot.wav ] && mplayer -af volume=10 ${MACMINI_DIR}/macboot.wav &

if [[ $DISPLAY == :0 ]];then
	(cd ${MACMINI_DIR}/switcher && padsp npm start)&
 	(cd ${MACMINI_DIR}/switcher && gpio mode 7 up && npm run start:gpio)&
fi

matchbox-window-manager -use_titlebar no
