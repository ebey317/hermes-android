# Hermes Android Setup — Service Tiers

Hermes on Android gives you a private AI assistant that runs locally on your phone or tablet. The public repo below is the **Community** path: free, cloud-only, and fully automatic.

If you want local models, hybrid cloud+local, multiple devices, or hands-off setup, the paid tiers below cover that.

For paid setup inquiries: contact Elijah at **business-development@anthropic.com**

---

## Free Community Tier

**Cost:** $0  
**Includes:**
- One Hermes entity on one Android device (Termux)
- Pre-configured for **Ollama Cloud** with one working model
- Hermes CLI + Web UI on the device
- Self-serve install from the public repo
- Direct links to Termux, Tailscale, Ollama settings, and OpenRouter

**What you do:**
- Have an Android device
- Install Termux from F-Droid
- Run the install script
- Paste your Ollama Cloud API key

**What you get:**
- A working AI assistant in your browser at `http://127.0.0.1:8787`
- Remote access via Tailscale once you install the Tailscale Android app

---

## Gateway Tier — $150

**For:** one person or one small workspace that wants cloud AI on a single device without doing the install themselves.

**Includes:**
- One Android device configured as a Hermes entity
- Remote setup done for you
- **Hermes Desktop** installed and demonstrated
- One cloud provider configured (Ollama Cloud)
- Tailscale + SSH access configured
- Web UI password + basic security

**You get the same Community install, but you do not have to run it yourself.**

---

## Gateway + Prime Setup — $250

**For:** one device with the full working stack — local model plus multiple cloud providers.

**Includes everything in Gateway, plus:**
- Local model installed and tuned on the device
- Two cloud tiers configured (for example: Ollama Cloud + OpenRouter)
- Multiple models available in the Web UI
- Hermes Desktop + CLI + Web UI all verified end-to-end

**This is the same setup running on Madam-Mary today:** local model, cloud fallback, multiple providers, Hermes Desktop.

---

## Pro Workstation — $500

**For:** a small office, barbershop, gas station, restaurant, or home workspace with up to **4 devices**.

**Includes:**
- Up to 4 devices (Android, Linux, Windows — mixed OK)
- Local model installed on **one main server device**
- Hermes Desktop installed on **all 4 devices**
- One shared Telegram bot on the main server
- Tailscale mesh connecting all devices
- AI Controller included as an accessibility sweetener
- A walkthrough video showing how to use the setup

**How it works:**
- One main device runs the local model and the shared Telegram bot
- The other devices connect to it through Hermes Desktop or the Web UI
- Everyone in the workspace shares the same token pool and bill

---

## Independent Agent — $150 each

**For:** a person in the workspace who needs their **own isolated AI setup** using their own API keys.

**Examples:**
- A secretary who uses her own Anthropic or Cohere account
- A contractor who brings their own laptop and does not want to share the main workspace token pool
- A manager who wants personal AI separate from the floor staff

**Includes:**
- One additional device configured with its own API keys
- OpenRouter free tier used by default (or their own provider)
- Its own Telegram bot
- Isolated from the main workspace billing

---

## Enterprise — $1,500–$3,500

**For:** small business clusters with **5+ devices** or multiple locations.

**Examples:**
- A plaza owner with several units
- A multi-location restaurant
- A distributed team that needs shared local + cloud access

**Price depends on:**
- Number of devices
- Number of locations
- Local model cluster size
- Support level

---

## Turnkey Hardware

If you want a working box shipped to you instead of configuring your own device:

| Tier | Setup Fee | Hardware Range | Deliverable |
|------|-----------|----------------|-------------|
| Pro Workstation Server | $500 | $600–$800 | One server device with local model + Hermes Desktop, ready to connect up to 3 additional devices |
| Enterprise Server | $1,500 | $800–$1,200 | Larger local model cluster, configured for 5+ device mesh |

Hardware cost is separate. You can buy locally and have it configured remotely, or the hardware can be sourced and shipped.

---

## Monthly Support

| Tier | Price | What you get |
|------|-------|--------------|
| Basic | $50/mo | Bug fixes, config recovery after Termux or package updates |
| Standard | $150/mo | Model updates, config changes, priority help |
| Enterprise | $500/mo | Priority support, custom routing, multi-device monitoring |

---

## Add-Ons

| Add-On | Price | Notes |
|--------|-------|-------|
| Additional Telegram bot | $25 | For an independent agent or separate service |
| Extra cloud provider config | Bundled in Prime Setup | Included when you buy Gateway + Prime |
| Local model setup alone | $100 | If added to an existing Gateway install |

---

## Why These Tiers?

- **Cloud-only is free** because it is easy, fast, and works on almost any Android device.
- **Local models cost** because hardware varies, setup takes time, and performance tuning is device-specific.
- **Hybrid is the sweet spot** because local models have cutoff dates. You want a local model for speed and privacy, but cloud fallback for web search and current information.
- **Multiple devices cost** because each one needs identity, access, routing, and security configured.
- **Telegram bots are per-agent** because one shared bot for a whole workspace is usually enough; separate bots are only needed for truly independent users.

---

## Get Started

- **Free:** follow the README and run `install.sh`
- **Paid setup:** email **business-development@anthropic.com** with which tier you want and how many devices you have
