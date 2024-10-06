#!/usr/bin/env bash

sudo apt install -y flatpak

# kde
sudo apt install -y plasma-discover-backend-flatpak

# gnome
# sudo apt install -y gnome-software-plugin-flatpak

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
