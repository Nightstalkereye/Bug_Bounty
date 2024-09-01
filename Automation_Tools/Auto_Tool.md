# Domain Recon Tool

This Bash-based tool automates the process of subdomain enumeration and network scanning. It leverages `subfinder`, `assetfinder`, and `nmap` to discover subdomains, resolve them to IP addresses, and perform a TCP scan on the target.

## Features

- **Subdomain Enumeration:** Uses `subfinder` and `assetfinder` to discover subdomains of a target domain.
- **Subdomain Resolution:** Filters and sorts unique subdomains and resolves them using `httpx-toolkit`.
- **Network Scanning:** Performs a TCP scan on the discovered IP address using `nmap`.
- **Automatic Tool Installation:** Checks and installs required tools (`subfinder`, `assetfinder`, `httpx-toolkit`, and `nmap`) if they are not already installed.
- **Simple and Clean Output:** Saves the results of each stage in separate text files.

## Prerequisites

Before running the tool, ensure that you have the following installed on your system:

- **Bash**: The script is designed to run in a Bash shell environment.
- **subfinder**: Tool for subdomain enumeration.
- **assetfinder**: Another tool for subdomain enumeration.
- **httpx-toolkit**: A tool to resolve subdomains.
- **nmap**: A powerful network scanning tool.

The script will check for these tools and install them automatically if they are not found on your system.

## Installation on Linux

git clone https://github.com/yourusername/recon_tool.git

cd recon_tool

./auto_tool.sh
