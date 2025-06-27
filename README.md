
# 🚀 OpenVPN Access Server Docker Installer (Debian Bookworm)

This repository provides a one-shot script (`docker.sh`) to install Docker on **Debian 12 (Bookworm)** and deploy the **OpenVPN Access Server** inside a Docker container.

---

## 📦 What's Included?

- Installs Docker CE and required plugins on Debian Bookworm
- Pulls the official `openvpn/openvpn-as` image
- Runs the container with:
  - Proper TUN device access
  - Required `NET_ADMIN` and `MKNOD` capabilities
  - Volume binding for config persistence
- Automatically restarts container on reboot/crash

---

## 🛠 Prerequisites

- A Debian 12 (Bookworm) server
- Sudo/root access
- A public IP address or domain name

---

## 🧪 Installation & Usage

1. Clone this repository:
   ```bash
   git clone https://github.com/<your-username>/openvpn-access-docker.git
   cd openvpn-access-docker
````

2. Make the script executable:

   ```bash
   chmod +x docker.sh
   ```

3. Run the script:

   ```bash
   ./docker.sh
   ```

---

## 🌐 Access the Admin Web UI

Once the container is up:

* Admin UI:
  `https://<your-server-ip>:943/admin`

> ⚠️ Accept the browser's self-signed certificate warning to continue.

---

## 🔐 Retrieve Admin Password

Run:

```bash
sudo docker logs -f openvpn-as | grep 'Auto-generated pass'
```

---

## 📁 Persistent Data

Container config is stored in:

```bash
/opt/openvpn_data
```

You can back up or mount this folder to retain settings across container restarts or upgrades.

---

## 🧯 Troubleshooting

* Make sure `/dev/net/tun` exists on the host.
* Ensure ports 943, 443, and 1194/udp are open in your firewall.
* Restart container if needed:

  ```bash
  sudo docker restart openvpn-as
  ```

---

## 📜 License

MIT License — free to use and modify.

```

---

Let me know if you also want to include a `docker-compose.yml` and update the README to reflect that option.


