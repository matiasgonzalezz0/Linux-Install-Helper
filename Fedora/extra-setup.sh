#!/usr/bin/env bash

# Does extra setup to some of the packages installed before

_user=$(whoami)

# Virtual box
sudo usermod -aG vboxusers $_user

# Docker (Fedora doesn't start it by default)
sudo usermod -aG docker $_user
sudo systemctl enable --now docker

# Zsh as default shell
sudo usermod -s "$(command -v zsh)" $_user

# Oh My Zsh
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Oh My Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "Done! Log out and back in for the group and shell changes"
