#!/bin/bash

# Exit on any error
set -e

# Update package lists
echo "Updating package lists..."
sudo apt update -y

# Define distribution codename for Ubuntu 24.04
DISTRO="noble"

# Add VirtualBox repository to sources.list
echo "Adding VirtualBox repository to /etc/apt/sources.list..."
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian $DISTRO contrib" | sudo tee -a /etc/apt/sources.list

# Download and register Oracle public key
echo "Downloading and registering Oracle VirtualBox public key..."
wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg --dearmor

# Update package lists again after adding new repository
echo "Updating package lists with new repository..."
sudo apt update -y

# Install VirtualBox 7.1
echo "Installing VirtualBox 7.1..."
sudo apt install -y virtualbox-7.1

echo "VirtualBox 7.1 installation completed successfully!"
