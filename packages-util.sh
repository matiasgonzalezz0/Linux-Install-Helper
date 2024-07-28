#!/usr/bin/env bash

# Script that checks packages existence and installs them.
# The script has an interactive prompt with all the functionalities.

# Requirements:
# * The appropiate package manager/distribution
# * For checking the aur packages you need to have the package `jq` installed
# * For installing the aur packages you need to have the yay AUR helper (you can find a script to install it in this repository)

# You must have files with the packages you want to check/install.
# This files can have empty lines and comments that start with the character #.
# Change the variables below if you wish to change the file names:
_filename_arch="packages-arch.txt"
_filename_aur="packages-aur.txt"
_filename_apt="packages-apt.txt"
_filename_flatpak="packages-flatpak.txt"

check_packages_arch() {
	_packages=$(grep -v -E '^\s*$|^#' $_filename_arch | sort)

	_missing_packages=$(comm -23 <(echo "$_packages") <(pacman -Ssq | sort))

	if [[ -z "$_missing_packages" ]]; then
		echo "All packages exist in the Arch repositories!"
	else
		echo "The following packages were not found in the Arch repositories:"
		echo "$_missing_packages"
	fi
}

check_packages_aur() {
	_packages=$(grep -v -E '^\s*$|^#' $_filename_aur | sort)

	_url='https://aur.archlinux.org/rpc?v=5&'

	_packages_in_aur=$(curl -s "${_url}type=info$(printf '&arg[]=%s' $_packages)" | jq -r '.results[]|.Name')

	_missing_packages=$(comm -23 <(echo "$_packages") <(echo "$_packages_in_aur"))

	if [[ -z "$_missing_packages" ]]; then
		echo "All packages exist in the AUR!"
	else
		echo "The following packages were not found in the AUR:"
		echo "$_missing_packages"
	fi
}

check_packages_apt() {
    _packages=$(grep -v -E '^\s*$|^#' "$_filename_apt" | sort)
    _missing_packages=""

    echo "$_packages" > /tmp/packages_list.txt

    while IFS= read -r _package; do
        if ! apt-cache show "$_package" &> /dev/null; then
            _missing_packages+="$_package\n"
        fi
    done < /tmp/packages_list.txt

    if [[ -n "$_missing_packages" ]]; then
        echo "The following packages were not found in the apt repositories:"
        echo -e "$_missing_packages"
    else
        echo "All packages exist in the apt repositories!"
    fi
}

check_packages_flatpak() {
    _packages=$(grep -v -E '^\s*$|^#' "$_filename_flatpak" | sort)
    _missing_packages=""

    echo "$_packages" > /tmp/packages_list.txt

    while IFS= read -r _package; do
        if ! flatpak search --columns=application $_package | grep "^$_package$" > /dev/null ; then
            _missing_packages+="$_package\n"
        fi
    done < /tmp/packages_list.txt

    if [[ -n "$_missing_packages" ]]; then
        echo "The following packages were not found in the flatpak repositories:"
        echo -e "$_missing_packages"
    else
        echo "All packages exist in the flatpak repositories!"
    fi
}

check_packages_op() {
	while true; do
		_operation=0

		echo "###################################################"
		echo "Select which packages you wish to check:"
		echo "(1) Arch"
		echo "(2) AUR"
		echo "(3) Apt"
		echo "(4) Flatpak"
		echo ""
		echo "(q) <- Go Back"
		echo "###################################################"

		echo ""
		echo -n "Op: "
		read -r _operation
		echo ""

		case $_operation in
			1)
				echo "###################################################"
				check_packages_arch
				echo "###################################################"
				echo ""
				;;
			2)
				echo "###################################################"
				check_packages_aur
				echo "###################################################"
				echo ""
				;;
			3)
				echo "###################################################"
				check_packages_apt
				echo "###################################################"
				echo ""
				;;
			4)
				echo "###################################################"
				check_packages_flatpak
				echo "###################################################"
				echo ""
				;;
			q)
				return
				;;
			*)
				echo "Invalid Operation! Please enter a valid number"
				;;
		esac
	done
}

install_packages_arch() {
	# Updates your system first
	sudo pacman -Syu

	_packages=$(grep -v -E '^\s*$|^#' $_filename_arch | sort)

	echo "Installing packages from the arch repositories..."
	sudo pacman -S --needed - < <(echo "$_packages")
	echo ""
	echo "Installation completed!"
}

install_packages_aur() {
	_packages=$(grep -v -E '^\s*$|^#' $_filename_aur | sort)

	echo "Installing packages from the AUR..."
	yay -S --needed - < <(echo "$_packages")
	echo ""
	echo "Installation completed!"
}

install_packages_apt() {
	# Updates your system first
	sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

	_packages=$(grep -v -E '^\s*$|^#' $_filename_apt | sort)

	echo "Installing packages from the apt repositories..."
	echo "$_packages" | xargs sudo apt install -y
	echo ""
	echo "Installation completed!"
}

install_packages_flatpak() {
	_packages=$(grep -v -E '^\s*$|^#' $_filename_flatpak | sort)

	echo "Installing packages from the apt repositories..."
	flatpak install $_packages
	echo ""
	echo "Installation completed!"
}

install_packages_op() {
	while true; do
		_operation=0

		echo "###################################################"
		echo "Select which packages you wish to install:"
		echo "(1) Arch"
		echo "(2) AUR"
		echo "(3) Apt"
		echo "(4) Flatpak"
		echo ""
		echo "(q) <- Go Back"
		echo "###################################################"

		echo ""
		echo -n "Op: "
		read -r _operation
		echo ""

		case $_operation in
			1)
				echo "###################################################"
				install_packages_arch
				echo "###################################################"
				echo ""
				;;
			2)
				echo "###################################################"
				install_packages_aur
				echo "###################################################"
				echo ""
				;;
			3)
				echo "###################################################"
				install_packages_apt
				echo "###################################################"
				echo ""
				;;
			4)
				echo "###################################################"
				install_packages_flatpak
				echo "###################################################"
				echo ""
				;;
			q)
				return;;
			*)
				echo "Invalid Operation! Please enter a valid number";;
		esac
	done
}

main() {
	while true; do
		_operation=0

		echo "###################################################"
		echo "Select the operation you wish to make:"
		echo "(1) Check packages existence"
		echo "(2) Install packages"
		echo ""
		echo "(q) Exit script"
		echo "###################################################"

		echo ""
		echo -n "Op: "
		read -r _operation
		echo ""

		case $_operation in
			1)
				check_packages_op
				;;
			2)
				install_packages_op
				;;
			q)
				return
				;;
			*)
				echo "Invalid Operation! Please enter a valid number"
				;;
		esac
	done

	echo "Enjoy your linux installation!"
}

main
