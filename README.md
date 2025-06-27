# OpenVPN Access Server Docker Installer

This script installs Docker (for Debian Bookworm) and runs OpenVPN Access Server in a secure Docker container.

## Usage

\`\`\`bash
chmod +x docker.sh
./docker.sh
\`\`\`

Then access: https://<your-server-ip>:943/admin

Use \`sudo docker logs -f openvpn-as | grep 'Auto-generated pass'\` to get the default admin password.
