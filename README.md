# Linux-Install-Helper
I use this scripts on every new Arch installation that I want to setup with Hyprland.
Feel free to use them and change them for your personal needs.

I use the yay AUR helper for the auto installation of AUR packages. You can install it with the [install-yay.sh](Arch/install-yay.sh) script.

## Fedora (KDE Plasma)
Run the scripts in [Fedora](Fedora) in this order:
1. [add-repos.sh](Fedora/add-repos.sh): RPM Fusion, codecs, Flathub, Docker, VS Code and Cursor repos
2. [install-asus.sh](Fedora/install-asus.sh): asusctl + ROG Control Center (ASUS laptops only)
3. [install-nvidia.sh](Fedora/install-nvidia.sh): NVIDIA driver (reboot afterwards)
4. `packages-util.sh`: install the Dnf and Flatpak lists
5. [extra-setup.sh](Fedora/extra-setup.sh): docker/vboxusers groups, zsh, Oh My Zsh
6. [extra-installs.sh](Fedora/extra-installs.sh): nvm, pnpm, pyenv, Claude Code, JetBrains Mono Nerd Font
