#!/usr/bin/env bash

# Adds every third party repository needed by packages-dnf.txt and packages-flatpak.txt
# Run this first, before installing any packages

sudo dnf upgrade --refresh -y

# RPM Fusion (free + nonfree): codecs, steam, unrar, VirtualBox, NVIDIA drivers
sudo dnf install -y \
	https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Fedora removes the patented codecs (H.264/HEVC), these bring them back:
# Full ffmpeg (used by Firefox, Chromium, Dolphin thumbnails...)
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
# AMD iGPU hardware video decoding, otherwise videos are decoded by the CPU (battery)
sudo dnf install -y mesa-va-drivers-freeworld

# Flathub (Fedora may ship it disabled)
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-modify --enable flathub

# Docker CE
sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo

# VS Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo tee /etc/yum.repos.d/vscode.repo > /dev/null <<EOF
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
autorefresh=1
type=rpm-md
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

# Cursor
sudo tee /etc/yum.repos.d/cursor.repo > /dev/null <<EOF
[cursor]
name=Cursor
baseurl=https://downloads.cursor.com/yumrepo
enabled=1
gpgcheck=1
gpgkey=https://downloads.cursor.com/keys/anysphere.asc
repo_gpgcheck=1
EOF

sudo dnf makecache

echo "Done!"
