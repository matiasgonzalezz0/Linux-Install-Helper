#!/bin/bash

# Auto installs the packages from the Arch repositories and the AUR.
# It's recommended to first use the script to check if the packages actually exist.
# The packages files can have inline comments that start with #

# Change files if needed
_packages_file=packages.txt
_aur_packages_file=packages-aur.txt

# Updates your system first
sudo pacman -Syu

_packages=$(grep -v -E '^\s*$|^#' $_packages_file | sort)
_aur_packages=$(grep -v -E '^\s*$|^#' $_aur_packages_file | sort)

echo "Installing packages from the arch repositories..."
sudo pacman -S --needed - < <(echo "$_packages")

echo "Installing packages from the AUR..."
yay -S --needed - < <(echo "$_aur_packages")
