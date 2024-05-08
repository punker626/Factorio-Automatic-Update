#!/bin/bash

# Define variables
factorio_install_dir="/opt/factorio/"
factorio_download_page_url="https://www.factorio.com/download"
temp_file="/tmp/factorio_download_page.html"

# Function to get the latest version
get_latest_version() {
    latest_version=$(curl -s "$factorio_download_page_url" | grep -oP ' - \K\d+\.\d+\.\d+' | head -n 1)
    if [ -z "$latest_version" ]; then
        echo "Error: Latest version not found."
    else
        echo "${latest_version}"
    fi
}

# Function to get the installed version
get_installed_version() {
   installed_version=$(cat "$factorio_install_dir"/data/base/info.json | grep -Po '"version":.*?[^\\]",' | cut -d '"' -f 4)
 
if [ -z "$installed_version" ]; then
        echo "Error: Installed version not found."
    else
        echo "${installed_version}"
    fi
}

# Function to compare versions
compare_versions() {
    installed_version="$1"
    latest_version="$2"

    latest_major=$(echo "$latest_version" | cut -d '.' -f 1)
    latest_minor=$(echo "$latest_version" | cut -d '.' -f 2)
    latest_patch=$(echo "$latest_version" | cut -d '.' -f 3)

    installed_major=$(echo "$installed_version" | cut -d '.' -f 1)
    installed_minor=$(echo "$installed_version" | cut -d '.' -f 2)
    installed_patch=$(echo "$installed_version" | cut -d '.' -f 3)

    if [ "$installed_major" -lt "$latest_major" ] || \
       ([ "$installed_major" -eq "$latest_major" ] && [ "$installed_minor" -lt "$latest_minor" ]) || \
       ([ "$installed_major" -eq "$latest_major" ] && [ "$installed_minor" -eq "$latest_minor" ] && [ "$installed_patch" -lt "$latest_patch" ]); then
        echo "newer"
    elif [ "$installed_major" -eq "$latest_major" ] && [ "$installed_minor" -eq "$latest_minor" ] && [ "$installed_patch" -eq "$latest_patch" ]; then
        echo "equal"
    else
        echo "older"
    fi
}

#Function to update Factorio if a newer version is available
update_factorio() {
    echo "Checking for updates..."
    latest_version=$(get_latest_version)
    installed_version=$(get_installed_version)

    echo "Latest version: $latest_version"
    echo "Installed version: $installed_version"

    comparison_result=$(compare_versions "$installed_version" "$latest_version")

    if [ "$comparison_result" = "equal" ]; then
        echo "Factorio is already up to date."
    elif [ "$comparison_result" = "newer" ]; then
        echo "Newer version available: $latest_version"
        # Perform update logic here
        echo "Removed Archived Installation"
        sudo rm -r /opt/factorio.old1
        echo "Archived Installtion Removed"
        echo "Archive Backup Installation"
        sudo cp -r /opt/factorio.old /opt/factorio.old1
        echo "Backup Archived"
        echo "Remove Backup"
        sudo rm -r /opt/factorio.old
        echo "Backup Removed"
        echo "Stop Factorio Service"
        sudo systemctl stop factorio.service
        echo "Backup Current Installation"
        sudo cp -r /opt/factorio /opt/factorio.old
        echo "Current Installation Backedup"
        echo "Downloading Newest Version"
        wget -O /home/ubuntu/factorio_headless.tar.xz https://factorio.com/get-download/stable/headless/linux64
        echo "Newest version Downloaded"
        sudo systemctl stop factorio.service
        echo "Updating Installation"
        sudo tar -xJf /home/ubuntu/factorio_headless.tar.xz -C /opt/
        echo "Factorio Updated"
        echo "Restarting Server"
        sudo systemctl start factorio.service
        echo "Check Factorio Status"
        sudo systemctl status factorio.service
    else
        echo "Installed version is greater than the latest version."
    fi

}

# Call the update function
update_factorio
