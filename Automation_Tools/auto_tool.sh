#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print messages in blue
print_blue() {
    echo -e "\033[34m$1\033[0m"
}

print_blue "Checking for subfinder..."
# Check if subfinder is installed
if ! command_exists subfinder; then
    echo "subfinder not found. Installing..."
    sudo apt-get update && sudo apt-get install -y subfinder
    print_blue "subfinder installed."
else
    print_blue "subfinder is already installed."
fi

print_blue "Checking for assetfinder..."
# Check if assetfinder is installed
if ! command_exists assetfinder; then
    echo "assetfinder not found. Installing..."
    sudo apt-get update && sudo apt-get install -y assetfinder
    print_blue "assetfinder installed."
else
    print_blue "assetfinder is already installed."
fi

print_blue "Checking for httpx-toolkit..."
# Check if httpx-toolkit is installed
if ! command_exists httpx-toolkit; then
    echo "httpx-toolkit not found. Installing..."
    # Replace with the actual installation command for httpx-toolkit if different
    sudo apt-get install -y httpx-toolkit
    print_blue "httpx-toolkit installed."
else
    print_blue "httpx-toolkit is already installed."
fi

# Ask for the domain name
read -p "Enter the domain name: " domain

print_blue "Creating directory /home/$USER/$domain..."
# Create a folder with the domain name in /home/$USER/
domain_dir="/home/$USER/$domain"
if [ ! -d "$domain_dir" ]; then
    mkdir "$domain_dir"
    print_blue "Directory created: $domain_dir"
else
    print_blue "Directory $domain_dir already exists."
fi

print_blue "Navigating to directory $domain_dir..."
# Navigate to the domain folder
cd "$domain_dir" || exit

print_blue "Working in directory: $(pwd)"

print_blue "Running subfinder..."
# Run subfinder to find subdomains and save the output to a file
subfinder -d "$domain" -all > subfinder_subdomain.txt
print_blue "subfinder completed. Subdomains saved to subfinder_subdomain.txt."

print_blue "Running assetfinder..."
# Run assetfinder to find subdomains and save the output to a file
assetfinder --subs-only "$domain" > assetfinder_subdomain.txt
print_blue "assetfinder completed. Subdomains saved to assetfinder_subdomain.txt."

print_blue "Combining and sorting subdomains..."
# Combine, sort, and remove duplicates from the two output files
sort -u subfinder_subdomain.txt assetfinder_subdomain.txt > subdomain_result.txt
print_blue "Sorted and combined subdomain results saved to subdomain_result.txt."

print_blue "Removing intermediate files..."
# Remove the intermediate files
rm subfinder_subdomain.txt assetfinder_subdomain.txt
print_blue "Removed intermediate files: subfinder_subdomain.txt and assetfinder_subdomain.txt."

print_blue "Running httpx-toolkit..."
# Run httpx-toolkit on the combined result
cat subdomain_result.txt | httpx-toolkit -sc >> httpx_result
print_blue "httpx-toolkit scan results saved to httpx_result."

print_blue "Pinging the domain..."
# Ping the domain and extract the IPv4 address
ping_output=$(ping -4 "$domain" -c 1)
print_blue "Ping output:"
echo "$ping_output"

# Extract unique IPv4 addresses from the ping result
ipv4_addresses=$(echo "$ping_output" | grep -oP '\d+\.\d+\.\d+\.\d+' | sort -u)
print_blue "Extracted IPv4 addresses:"
echo "$ipv4_addresses"

# Take the first unique IP address if available
ipv4_address=$(echo "$ipv4_addresses" | head -n 1)

if [ -n "$ipv4_address" ]; then
    print_blue "Running nmap TCP scan on $ipv4_address..."
    # Run nmap TCP scan to find open ports and detect service versions
    sudo nmap -sS -sV -p- "$ipv4_address" -oN nmap_tcp_scan.txt
    print_blue "nmap TCP scan results saved to nmap_tcp_scan.txt."
else
    print_blue "No IPv4 address found for the domain."
fi

print_blue "All tasks completed."
