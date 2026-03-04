#!/bin/bash
# setup.sh

echo "Checking for prerequisites for Kubernetes Practice Environment (Linux/WSL)..."

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Ensure we are in Linux/WSL
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "Warning: This script is intended for Linux or WSL environments."
fi

# 1. Update apt and install Python
echo "Updating apt packages and installing Python 3..."
sudo apt-get update -y
sudo apt-get install -y python3 python3-pip python-is-python3 python3-venv

# 1.5 Install Python Requirements
echo "Installing Python requirements..."
if [ -f "requirements.txt" ]; then
    # We use break-system-packages for Debian Bookworm WSL environments as a simple global install
    pip install -r requirements.txt --break-system-packages 2>/dev/null || pip install -r requirements.txt
else
    echo "Warning: requirements.txt not found in root directory."
fi

# 2. Check Docker
if ! command_exists docker; then
    echo "Docker is not installed or not in PATH."
    echo "If you are using Docker Desktop with WSL 2, make sure you enabled WSL integration for this distro in Docker Desktop Settings."
    echo "Attempting to install native Docker engine as fallback..."
    sudo apt-get install -y docker.io
    sudo usermod -aG docker $USER
    echo "Please restart your WSL session to apply docker group changes."
else
    echo "Docker is installed."
fi

# 3. Check kubectl
if ! command_exists kubectl; then
    echo "kubectl is not installed. Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
else
    echo "kubectl is installed."
fi

# 4. Check kind
if ! command_exists kind; then
    echo "kind is not installed. Installing kind..."
    [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
else
    echo "kind is installed."
fi

echo ""
echo "Linux/WSL setup complete! You are ready to dive into the questions."
