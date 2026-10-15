#!/usr/bin/env bash

# Installs the NVIDIA driver from RPM Fusion (run add-repos.sh first)
# akmod = the module is compiled locally on every kernel update (like nvidia-dkms on Arch)
# Reference: https://rpmfusion.org/Howto/NVIDIA

# -cuda: nvidia-smi and NVENC/NVDEC for host apps. libs.i686: 32-bit libs for Steam/Wine (lib32-nvidia-utils)
sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda xorg-x11-drv-nvidia-libs.i686

# Builds the module now instead of in the background, so it's ready before rebooting
sudo akmods --force
modinfo -F version nvidia || echo "The nvidia module was not built! Check /var/cache/akmods/nvidia/"

echo "Done! Reboot"
