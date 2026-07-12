# Where to get the APKs

This repo does **not** redistribute APK files because they are large and update frequently. Download them once and keep them on a flash drive, SD card, or shared folder for offline installs.

| APK | Direct download | F-Droid package |
|-----|-----------------|-----------------|
| F-Droid client | <https://f-droid.org/> | N/A |
| Termux | <https://f-droid.org/packages/com.termux/> | `com.termux` |
| Tailscale | <https://f-droid.org/packages/com.tailscale.ipn/> | `com.tailscale.ipn` |

## Why not Google Play?

- **Termux on Google Play** is deprecated and broken on newer Android versions.
- **F-Droid** builds Termux the way the maintainers intend.

## Optional APKs

| APK | Why you might want it |
|-----|-----------------------|
| Termux:Boot | Start sshd and Hermes automatically after reboot |
| Termux:Widget | Launch Termux scripts from the home screen |
| Termux:API | Access Android notifications, clipboard, etc. |
| Termux:Styling | Change colors/fonts |

## Sideload steps

1. Copy the APKs to the Android device (flash drive, Bluetooth, cloud storage, etc.).
2. Enable **Install unknown apps** for your file manager.
3. Install F-Droid first.
4. Open F-Droid and install Termux + Tailscale.

Or install the APKs directly if you already have them.
