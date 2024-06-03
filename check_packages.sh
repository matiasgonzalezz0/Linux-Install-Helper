#!/bin/bash

# Checks if the packages specified in _packages_file exist in the current arch repositories
# The packages files can have inline comments that start with #

# Change file if needed
_packages_file=packages.txt

_packages=$(grep -v -E '^\s*$|^#' $_packages_file | sort)

_missing_packages=$(comm -23 <(echo "$_packages") <(pacman -Ssq | sort))

if [[ -z "$_missing_packages" ]]; then
	echo "All packages exist in the arch repositories!"
else
	echo "The following packages were not found in the arch repositories:"
	echo "$_missing_packages"
fi
