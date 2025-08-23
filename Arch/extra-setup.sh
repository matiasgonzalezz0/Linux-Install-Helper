#!/bin/bash

# Does extra setup to some of the packages installed before
# In this case, because of the $ZSH_CUSTOM variable, the script must be executed like this:
# . ./extra_setup.sh (Notice the extra dot)

_user=$(whoami)

# For the printer functionality
sudo systemctl enable cups.socket
sudo systemctl start cups.socket

# Bluetooth
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service

# Virtual box
sudo usermod -aG vboxusers $_user

# Docker
sudo usermod -aG docker $_user

# Libvirt
sudo systemctl enable libvirtd.service
sudo usermod -aG libvirt $_user

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Oh My Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# SDDM
sudo cp /usr/lib/sddm/sddm.conf.d/default.conf /etc/sddm.conf
sudo systemctl enable sddm

# AMD GPU Fan Control
sudo systemctl enable radeon-profile-daemon.service

echo "Done!"
