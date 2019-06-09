~/.basilisk_ii_prefs
```bash
disk ${/path/to/disk1.dsk}
disk ${/path/to/disk2.dsk}
extfs ${/path/to/your/home/dir}
screen win/512/384
seriala /dev/ttyS5
serialb /dev/ttyS6
ether slirp
udptunnel false
udpport 6066
rom ${/path/to/mac.rom}
bootdrive 0
bootdriver 0
ramsize 33554432
frameskip 0
modelid 5
cpu 3
fpu false
nocdrom true
nosound false
noclipconversion false
nogui false
jit true
jitfpu true
jitdebug false
jitcachesize 2048
jitlazyflush true
jitinline true
keyboardtype 5
keycodes false
mousewheelmode 1
mousewheellines 3
dsp /dev/dsp
mixer /dev/mixer
idlewait true
```