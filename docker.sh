#!/bin/bash
set -e

echo "🚀 Cleaning up incorrect Docker sources (if any)..."
sudo rm -f /etc/apt/sources.list.d/docker.list

echo "🔑 Setting up Docker repository for Debian Bookworm..."

# Install prerequisites
sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Create keyrings directory
sudo install -m 0755 -d /etc/apt/keyrings

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/debian/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker's repository for Debian
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
echo "📦 Installing Docker Engine..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "✅ Docker installed successfully!"
docker --version

# Pull OpenVPN Access Server Docker image
echo "📥 Pulling OpenVPN Access Server image..."
sudo docker pull openvpn/openvpn-as

# Create a volume directory for persistent data
DATA_DIR="/opt/openvpn_data"
echo "📁 Creating data directory at $DATA_DIR..."
sudo mkdir -p $DATA_DIR
sudo chown -R $(whoami):$(whoami) $DATA_DIR

# Run the OpenVPN Access Server container
echo "🐳 Running OpenVPN Access Server container..."
sudo docker run -d \
  --name openvpn-as \
  --device /dev/net/tun \
  --cap-add=MKNOD \
  --cap-add=NET_ADMIN \
  -p 943:943 -p 443:443 -p 1194:1194/udp \
  -v $DATA_DIR:/openvpn \
  --restart=unless-stopped \
  openvpn/openvpn-as

echo ""
echo "🎉 OpenVPN Access Server is now running!"
echo "🌐 Admin Web UI: https://<YOUR_PUBLIC_IP>:943/admin"
echo "🔑 To get admin password, run:"
echo "    sudo docker logs -f openvpn-as | grep 'Auto-generated pass'"
