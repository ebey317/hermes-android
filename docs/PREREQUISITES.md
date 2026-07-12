# Step-by-Step: F-Droid + Termux + Tailscale

This guide assumes you have never sideloaded an app before.

## 1. Allow installing apps from outside the Play Store

### Android 12 / 13

1. Open **Settings**.
2. Tap **Apps**.
3. Tap the **three dots** in the top-right corner.
4. Tap **Special access**.
5. Tap **Install unknown apps**.
6. Find your web browser or file manager and toggle it **On**.

### Android 14 / 15

1. Open **Settings**.
2. Tap **Apps**.
3. Tap **Special app access**.
4. Tap **Install unknown apps**.
5. Find your browser or file manager and tap it.
6. Toggle **Allow from this source** to **On**.

## 2. Download F-Droid

1. On the Android device, open the browser and go to:
   ```
   https://f-droid.org
   ```
2. Tap **Download F-Droid**.
3. Wait for the `.apk` file to finish downloading.
4. Open the downloaded file from the notification or from your file manager.
5. Tap **Install**.

If it asks for permission, tap **Allow**.

## 3. Install Termux from F-Droid

**Do NOT install Termux from Google Play.** The Play Store version is outdated and no longer maintained.

1. Open the **F-Droid** app.
2. Pull down to refresh the app list.
3. Search for **Termux** (package name `com.termux`).
4. Tap **Install**.
5. Wait for the install to finish.

## 4. Install Tailscale from F-Droid

1. In **F-Droid**, search for **Tailscale** (package name `com.tailscale.ipn`).
2. Tap **Install**.
3. Wait for the install to finish.

## 5. Open Termux for the first time

1. Find **Termux** in your app drawer and open it.
2. You will see a black terminal screen.
3. Type:
   ```bash
   whoami
   ```
   Press Enter.
4. Write down the username it prints (usually `u0_a180` or similar). You need it for SSH later.

## 6. Storage permission for Termux

If you want to run the installer from a flash drive or SD card:

```bash
termux-setup-storage
```

Tap **Allow** when Android asks for storage permission. This creates a `~/storage` folder that links to shared device storage.

## 7. Architecture check

Run:

```bash
dpkg --print-architecture
```

You must see:

```
aarch64
```

If you see `arm` (32-bit) or `i686`, this guide is not tested on your device. Stop and open an issue.

## 8. Android version check

Run:

```bash
getprop ro.build.version.release
```

You should see **12**, **13**, **14**, **15**, or higher.

## 9. Next step

Once Termux is open and `whoami` prints a username, run the installer:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USER/hermes-android/main/install.sh)
```

Or, if you copied the installer from a flash drive:

```bash
bash ~/storage/downloads/install.sh
```

Replace `YOUR_GITHUB_USER` with the actual GitHub username where this repo is hosted.
