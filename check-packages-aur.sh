#!/bin/sh

# Checks if the packages specified in _packages_file exist in the current AUR
# The packages files can have inline comments that start with #

# Change file if needed
_packages_file=packages-aur.txt

_packages=$(grep -v -E '^\s*$|^#' $_packages_file | sort)

_url='https://aur.archlinux.org/rpc?v=5&'

_packages_in_aur=$(curl -s "${_url}type=info$(printf '&arg[]=%s' $_packages)" | jq -r '.results[]|.Name')

_missing_packages=$(comm -23 <(echo "$_packages") <(echo "$_packages_in_aur"))

if [[ -z "$_missing_packages" ]]; then
	echo "All packages exist in the AUR!"
else
	echo "The following packages were not found in the AUR:"
	echo "$_missing_packages"
fi
