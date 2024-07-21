#!/bin/bash

echo "Remember to enable multilib"

sudo pacman -Syu
sudo pacman -S git base-devel linux-headers xdg-utils

git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si
cd ..
sudo rm -r yay-git

echo "Done"
