#!/bin/sh
cp ./evdev-debounce.patch /tmp/
cd /tmp
apt-get source xserver-xorg-input-evdev-dev
sudo apt-get build-dep xserver-xorg-input-evdev-dev
cd xserver-xorg-input-evdev-*/
patch -p 1 < ../evdev-debounce.patch
dch -i
debuild -us -uc -b
cd ..
sudo dpkg -i xserver-xorg-input-evdev_*-*ubuntu*.deb
