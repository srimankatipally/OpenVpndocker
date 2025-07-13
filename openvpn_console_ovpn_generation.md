# OpenVPN Access Server: Console-Based .ovpn Generation Guide

This document provides a step-by-step reference to generate and retrieve a client `.ovpn` profile entirely via the console on your EC2 instance.

---

## Prerequisites

- **Root** or **sudo** privileges on the EC2 instance.
- **OpenVPN Access Server** installed (version ≥ 2.13.1).
- **SSH key** (e.g., `your-key.pem`) for SCP download.

---

## 1. Restart and Verify OpenVPN AS Service

Ensure the Access Server daemon is running:

```bash
sudo systemctl restart openvpnas
sudo systemctl status openvpnas
```

- Look for `Active: active (running)`.
- If it fails, proceed to check logs (Step 2).

---

## 2. Troubleshoot Service Failures

### 2.1 Inspect Recent Logs

```bash
sudo cat /var/log/openvpnas.log | tail -n 50
```

### 2.2 Check for OOM (Out‑Of‑Memory)

```bash
dmesg | grep -iE 'killed process|oom'
```

### 2.3 Address Port Conflicts

```bash
sudo lsof -i :943
sudo lsof -i :443
sudo lsof -i :1194
```

Stop conflicting services, e.g.: `sudo systemctl stop nginx`

---

## 3. Add Swap Space (If OOM Detected)

On small instances, Python may be killed by the OOM killer. Add a 1 GB swap file:

```bash
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
free -h            # Verify ~1 GiB swap present
```

Then restart OpenVPN AS:

```bash
sudo systemctl restart openvpnas
```

---

## 4. Enable Auto-Login for User (Optional)

To avoid interactive prompts in the client, set auto-login for the `openvpn` account:

```bash
sudo /usr/local/openvpn_as/scripts/sacli \
  --user openvpn \
  --key "prop_autologin" \
  --value "true" UserPropPut
```

Replace `openvpn` with your desired username.

---

## 5. Generate the Client ".ovpn" Profile

Use the `GetUserLoginProfile` command to render the full configuration:

```bash
sudo /usr/local/openvpn_as/scripts/sacli \
  --user openvpn \
  GetUserLoginProfile \
  > /root/openvpn.ovpn
```

Verify the file:

```bash
head -n 20 /root/openvpn.ovpn
```

Expect lines starting with:

```
client
 dev tun
 proto udp
 remote <your-public-ip> 1194
 <ca>
 ...
```

---

## 6. Secure and Download the Profile

1. **Restrict permissions**:

   ```bash
   sudo chmod 600 /root/openvpn.ovpn
   ```

2. **Copy to local machine**:

   ```bash
   scp -i your-key.pem ec2-user@<your-ec2-ip>:/root/openvpn.ovpn .
   ```

---

## 7. (Optional) Additional Tips

- **Disable Auto-Login** for increased security:

  ```bash
  sudo /usr/local/openvpn_as/scripts/sacli \
    --user openvpn \
    --key "prop_autologin" \
    --value "false" UserPropPut
  ```

- **Generate QR Code** for mobile clients:

  ```bash
  cat /root/openvpn.ovpn | qrencode -t ansiutf8
  ```

- **Upgrade Instance**: If memory issues persist, consider a larger EC2 type (≥2 GB RAM).

---

*End of Console-Based **``** Generation Guide*

