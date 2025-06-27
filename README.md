# 🚀 OpenVPN Access Server Docker Installer (Debian Bookworm)

This repository provides a one-shot script (`docker.sh`) to install Docker on **Debian 12 (Bookworm)** and deploy the **OpenVPN Access Server** inside a Docker container.

---

## 📦 What's Included?

- Installs Docker CE and required plugins on Debian Bookworm
- Pulls the official `openvpn/openvpn-as` image
- Runs the container with:
  - Proper TUN device access
  - `NET_ADMIN` and `MKNOD` capabilities
  - Volume binding for configuration persistence
- Automatically restarts the container on reboot or crash

---

## 🛠 Prerequisites

- A Debian 12 (Bookworm) server
- Sudo/root access
- A public IP address or domain name

---

## 🧪 Installation & Usage

1. **Clone this repository**  
   ```bash
   git clone https://github.com/srimankatipally/OpenVpndocker.git
   cd openvpn-access-docker
   ```

2. **Make the installer script executable**  
   ```bash
   chmod +x docker.sh
   ```

3. **Run the installer**  
   ```bash
   sudo ./docker.sh
   ```

---

## 🌐 Access the Admin Web UI

Once the container is running, open your browser and navigate to:

- **Admin UI:** `https://<your-server-ip>:943/admin`
- **Client UI:** `https://<your-server-ip>:943/`

> ⚠️ You will see a self-signed certificate warning—accept it to proceed.

---

## 🔐 Retrieve the Admin Password

To view the auto-generated password for the `admin` user, run:
```bash
sudo docker logs openvpn-as | grep 'Auto-generated pass'
```

---

## 📁 Persistent Data

Container configuration and data are stored under:
```bash
/opt/openvpn_data
```
You can back up or mount this directory to retain settings across container restarts or upgrades.

---

## 🧯 Troubleshooting

- Ensure the TUN device exists on the host:
  ```bash
  ls /dev/net/tun
  ```
- Verify that ports `943/tcp`, `443/tcp`, and `1194/udp` are open in your firewall.
- To restart the container:
  ```bash
  sudo docker restart openvpn-as
  ```

---

## 🔄 Updates

If you pull a new version of the Docker image, recreate the container to pick up changes:
```bash
sudo docker pull openvpn/openvpn-as
sudo docker rm -f openvpn-as
sudo docker run --name openvpn-as   --cap-add=NET_ADMIN --cap-add=MKNOD   -v /opt/openvpn_data:/config   -p 943:943 -p 443:443 -p 1194:1194/udp   -d openvpn/openvpn-as
```
