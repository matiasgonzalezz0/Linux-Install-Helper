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

check_packages_op() {
	while true; do
		_operation=0

		while true; do
			echo "###################################################"
			echo "Select which packages you wish to check:"
			echo "(1) Arch"
			echo "(2) AUR"
			echo ""
			echo "(3) <- Go Back"
			echo "###################################################"

			echo ""
			echo -n "Op: "
			read -r _operation
			echo ""

			case $_operation in
				1|2|3)
					break;;
				*)
					echo "Invalid Operation! Please enter a valid number";;
			esac
		done

		case $_operation in
			1)
				echo "###################################################"
				check_packages_arch
				echo "###################################################"
				echo "";;
			2)
				echo "###################################################"
				check_packages_aur
				echo "###################################################"
				echo "";;
			3)
				return;;
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
	_aur_packages=$(grep -v -E '^\s*$|^#' $_filename_aur | sort)

	echo "Installing packages from the AUR..."
	yay -S --needed - < <(echo "$_aur_packages")
	echo ""
	echo "Installation completed!"
}

install_packages_op() {
	while true; do
		_operation=0

		while true; do
			echo "###################################################"
			echo "Select which packages you wish to install:"
			echo "(1) Arch"
			echo "(2) AUR"
			echo ""
			echo "(3) <- Go Back"
			echo "###################################################"

			echo ""
			echo -n "Op: "
			read -r _operation
			echo ""

			case $_operation in
				1|2|3)
					break;;
				*)
					echo "Invalid Operation! Please enter a valid number";;
			esac
		done

		case $_operation in
			1)
				echo "###################################################"
				install_packages_arch
				echo "###################################################"
				echo "";;
			2)
				echo "###################################################"
				install_packages_aur
				echo "###################################################"
				echo "";;
			3)
				return;;
		esac
	done
}

main() {
	while true; do
		_operation=0

		while true; do
			echo "###################################################"
			echo "Select the operation you wish to make:"
			echo "(1) Check packages existence"
			echo "(2) Install packages"
			echo ""
			echo "(3) Exit script"
			echo "###################################################"

			echo ""
			echo -n "Op: "
			read -r _operation
			echo ""

			case $_operation in
				1|2|3)
					break;;
				*)
					echo "Invalid Operation! Please enter a valid number";;
			esac
		done


		case $_operation in
			1)
				check_packages_op;;
			2)
				install_packages_op;;
			3)
				break;;
		esac
	done

	echo "Enjoy your linux installation!"
}

main
