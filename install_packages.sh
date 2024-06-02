#!/bin/bash

_packages_file=packages.txt
_aur_packages_file=packages-aur.txt

_packages=$(grep -v -E '^\s*$|^#' $_packages_file | sort)
_aur_packages=$(grep -v -E '^\s*$|^#' $_aur_packages_file | sort)

echo "Installing packages from the arch repositories..."
sudo pacman -S --needed - < <(echo "$_packages")

echo "Installing packages from the AUR..."
yay -S --needed - < <(echo "$_aur_packages")
