# Android Permissions and Battery Settings

Android kills background apps aggressively. If you don't change these settings, Hermes gateway, sshd, and long installs will stop as soon as the screen turns off.

## 1. Disable battery optimization for Termux

1. Open Android **Settings**.
2. Tap **Apps**.
3. Find and tap **Termux**.
4. Tap **Battery**.
5. Tap **Battery optimization** or **Optimize battery usage**.
6. Select **All apps** from the dropdown.
7. Find **Termux** and change it to **Don't optimize**.

Different Android skins use different words:
- Samsung: **Unrestricted**
- Pixel: **Unrestricted**
- OnePlus: **Don't optimize**
- Xiaomi/Redmi: **No restrictions**
- OPPO/Realme: **Allow background activity**

## 2. Keep Termux in recent apps

After opening Termux, **do not swipe it away** from the recent-apps list. Swiping it away tells Android to kill it.

## 3. Use termux-wake-lock

Inside Termux, run:

```bash
termux-wake-lock
```

This prevents the CPU from sleeping while Termux is running. Run it before:
- Long `pip install` builds
- Running `hermes gateway run`
- Running `sshd`

To release the lock later:

```bash
termux-wake-release
```

## 4. Autostart Termux on boot (optional)

Install the Termux:Boot app from F-Droid:
https://f-droid.org/packages/com.termux.boot/

Or create a boot script:

```bash
mkdir -p ~/.termux/boot
```

Create `~/.termux/boot/start-hermes.sh`:

```bash
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock
sshd
hermes gateway run &
cd ~/hermes-webui
python server.py &
```

Make it executable:

```bash
chmod +x ~/.termux/boot/start-hermes.sh
```

## 5. Web UI password is required

By default, the installer forces you to set a Web UI password. It is stored in `~/.hermes/webui/settings.json`.

If you ever need to reset it:

```bash
python3 -c "
import json
p = '/data/data/com.termux/files/home/.hermes/webui/settings.json'
d = json.load(open(p))
d['auth_enabled'] = True
d['password_auth_enabled'] = True
d['password_hash'] = ''
json.dump(d, open(p, 'w'), indent=2)
"
pkill -f server.py
sleep 2
cd ~/hermes-webui
python server.py &
```

Then set a new password when the Web UI prompts you.

## 6. Tailscale permission

1. Open **Tailscale**.
2. Sign in or create an account at https://login.tailscale.com.
3. Tap **Enable VPN** when Android asks.
4. Make sure the tablet appears in your Tailscale admin console:
   https://login.tailscale.com/admin/machines

## 7. Generate SSH keys for passwordless login

If you want to SSH from another machine without typing the Termux password every time:

On the **other machine** (your laptop/desktop):

```bash
ssh-keygen -t ed25519 -C "hermes-tablet"
cat ~/.ssh/id_ed25519.pub
```

Copy the printed line. Then on the Android device in Termux:

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cat >> ~/.ssh/authorized_keys
```

Paste the key line, then press **Ctrl+D** twice.

Set permissions:

```bash
chmod 600 ~/.ssh/authorized_keys
```

Now you can SSH from the other machine without a password:

```bash
ssh -p 8022 u0_a180@100.x.y.z
```

## 8. Lock the device down

After setup, you should have:
- [ ] Battery optimization disabled for Termux
- [ ] Termux kept in recent apps
- [ ] `termux-wake-lock` active during builds and gateway use
- [ ] Web UI password set
- [ ] Tailscale connected
- [ ] SSH key-based login configured (optional but recommended)

## Direct links

| What | Link |
|------|------|
| Tailscale admin | https://login.tailscale.com/admin/machines |
| Termux:Boot | https://f-droid.org/packages/com.termux.boot/ |
