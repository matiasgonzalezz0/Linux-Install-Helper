#!/usr/bin/env bash

# ASUS laptops only: asusctl (fan profiles, keyboard LEDs, battery charge limit, dGPU on/off) + ROG Control Center
# Reference: https://asus-linux.org/guides/fedora-guide/

# Terra repository (asus-linux packages are published there, their old COPR is no longer maintained)
sudo dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

sudo dnf install -y asusctl asusctl-rog-gui
sudo systemctl enable --now asusd.service

# Firmware for the Cirrus speaker amps (G14 2025), usually already installed
sudo dnf install -y cirrus-audio-firmware

# Fedora uses tuned-ppd for power profiles, asus-linux supports power-profiles-daemon
sudo dnf swap -y tuned-ppd power-profiles-daemon --allowerasing
sudo systemctl enable --now power-profiles-daemon.service

echo "Done!"
