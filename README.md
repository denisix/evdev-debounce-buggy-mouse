# evdev-debounce-buggy-mouse
The patch to evdev library to debounce fix the double clicks of broken mouse buttons

This instructions helped me to fix the issue with my broken mouse "RAPOO 5G Wireless Device", the issue was with single clicks often recognized as double clicks.

* Installation using provided **build.sh** script:
```sh
git clone https://github.com/denisix/evdev-debounce-buggy-mouse
cd evdev-debounce-buggy-mouse
sh ./build.sh
```

* Or you can clone the repo and install by yourself:
```sh
cp ./evdev-debounce.patch /tmp/
cd /tmp
apt-get source xserver-xorg-input-evdev-dev
sudo apt-get build-dep xserver-xorg-input-evdev-dev
cd xserver-xorg-input-evdev-*/
patch -p 1 < ../evdev-debounce.patch
dch -i
debuild -us -uc -b
cd ..
sudo dpkg -i xserver-xorg-input-evdev_*ubuntu2_*.deb
```

### Configuration:

After that please relogin (restart Xorg) and check the device by it's ID:

```sh
$ xinput --list|grep pointer
⎡ Virtual core pointer                    	id=2	[master pointer  (3)]
⎜   ↳ Virtual core XTEST pointer              	id=4	[slave  pointer  (2)]
⎜   ↳ RAPOO RAPOO 5G Wireless Device          	id=11	[slave  pointer  (2)]
⎜   ↳ Broadcom Corp. Bluetooth USB Host Controller	id=13	[slave  pointer  (2)]
⎜   ↳ bcm5974                                 	id=15	[slave  pointer  (2)]
```

My mouse RAPOO mouse has ID = 11:
```sh
$ xinput --list-props 11|grep Debounce
	Evdev Debounce Delay (298):	0
```

You can find the best debounce value and check if it solves the issue:
```sh
$ xinput --set-prop --type=int --format=32 11 298 20
```
in this command **11** - the xinput ID, **298** - the ID property, **20** - the debounce timeout value

you can check if the fix works well:
`xev | awk '/ButtonRelease/ {print $1,i++}'`

When you will find the exact value you can put this comman into your $HOME/.xprofile. 
Or you can install into system-wide configuration file, for example:
cat /usr/share/X11/xorg.conf.d/99-rapoo.conf
```xorg
Section "InputClass"
    Identifier "evdev-mouse-rapoo"
    MatchProduct "RAPOO RAPOO 5G Wireless Device"
    MatchIsPointer "on"
    Driver "evdev"
    Option "DebounceDelay" "20"
EndSection
```


##### based on original author patch & instructions from here:
_Matt Whitlock freedesktop at mattwhitlock.name_

_Mon Aug 13 14:47:12 PDT 2012_

https://lists.x.org/archives/xorg-devel/2012-August/033225.html
