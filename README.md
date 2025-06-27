````markdown
# 🚀 OpenVPN Access Server Docker Installer (Debian Bookworm)

This repository provides a one-shot script (`docker.sh`) to install Docker on **Debian 12 (Bookworm)** and deploy the **OpenVPN Access Server** inside a Docker container.

---

## 📦 Features

- Installs Docker CE and required plugins on Debian 12 (Bookworm)
- Pulls the official `openvpn/openvpn-as` image
- Runs container with:
  - Proper TUN device access
  - `NET_ADMIN` and `MKNOD` capabilities
  - Volume binding for config persistence
- Automatically restarts container on reboot or crash

---

## 🛠 Prerequisites

- A Debian 12 (Bookworm) server
- Sudo/root access
- A public IP address or domain name

---

## 🧪 Installation & Usage

1. **Clone this repository**  
   ```bash
   git clone https://github.com/<your-username>/openvpn-access-docker.git
   cd openvpn-access-docker
````

2. **Make the installer executable**

   ```bash
   chmod +x docker.sh
   ```

3. **Run the installer**

   ```bash
   sudo ./docker.sh
   ```

---

## 🌐 Access the Admin Web UI

Once the container is up and running:

* **Admin UI:**

  ```
  https://<your-server-ip-or-domain>:943/admin
  ```

> ⚠️ You’ll see a self-signed certificate warning—accept it to proceed.

---

## 🔐 Retrieve the Admin Password

To view the auto-generated password:

```bash
sudo docker logs openvpn-as 2>&1 | grep 'Auto-generated pass'
```

---

## 📁 Persistent Data

All configuration and state are stored in:

```
/opt/openvpn_data
```

Backup or bind-mount this directory to retain settings across upgrades or host rebuilds.

---

## 🧯 Troubleshooting

* Ensure `/dev/net/tun` exists on the host:

  ```bash
  sudo mkdir -p /dev/net
  sudo mknod /dev/net/tun c 10 200
  sudo chmod 600 /dev/net/tun
  ```
* Open required firewall ports:

  * TCP 943 (Admin UI)
  * TCP 443 (Client UI)
  * UDP 1194 (VPN data)
* To restart the container manually:

  ```bash
  sudo docker restart openvpn-as
  ```

---

