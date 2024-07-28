#!/usr/bin/env bash

_directory="extra-installs"

cd $_directory

for _script in *.sh; do
    if [[ -f "$_script" ]]; then
        echo "Running $_script..."
		chmod +x $_script
		./$_script
    else
        echo "No .sh files found in $_directory"
		exit 1
    fi
done

echo "All installations completed!"
