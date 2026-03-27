# 🦊 WOMBAT-KVM v1.9 [BETA]
### "Smart Tech Done Right"
Developed by **Wombat Extreme Technologies**

A professional-grade, self-healing KVM-over-IP appliance repurposed from legacy Dell Latitude D520 hardware. Optimized for headless rack operation, remote BIOS management, and mobile accessibility.

---

## 🛠️ PROJECT ARCHITECTURE
This project transforms a 20-year-old laptop into a modern remote management tool using a containerized stack:

* **Host OS:** Debian 13 (Trixie) - Optimized for "Lid-Closed" operation.
* **Video Engine:** `uStreamer` (Low-latency MJPEG @ 720p60).
* **HID Engine:** Python 3 + `PySerial` (Communicating with CH9329 HID chip).
* **Web UI:** Adaptive HTML5/CSS3 with Desktop & Mobile input modes.
* **Watchdog:** Background health-check daemon (Restarts service on stream hang).

---

## 🔌 HARDWARE REQUIREMENTS
* **Controller:** Dell Latitude D520 (Intel Core 2 Duo).
* **HID Interface:** CH9329 Serial-to-USB Adapter (Hex Command Protocol).
* **Video Capture:** USB HDMI UVC Capture Card.
* **Motherboard:** Internal PC Speaker (Required for Beta Audio Alerts).

---

## 🚀 BETA v1.9 FEATURES
* **Audio Alerts:** Motherboard beeps for Service Start, Login, and Host Reboot.
* **Debug Logger:** On-demand generation of system telemetry and Docker logs.
* **Mobile Mode:** "App-ready" meta tags and dedicated touch-keyboard area.
* **Netboot Integration:** Built-in `netboot.xyz` container for remote OS installs.
* **Branded Splash:** Custom "Wombat Extreme" splash screen and MOTD.

---

## 📁 DIRECTORY STRUCTURE
```text
diy-kvm/
├── app.py              # Main Flask Logic & HID Translation
├── mappings.py         # HID Scan-code to CH9329 Hex map
├── Dockerfile          # Debian-slim build with uStreamer & Beep
├── docker-compose.yml  # Service & Hardware orchestration
├── README.md           # This documentation
├── MOTD.txt            # Custom Terminal Banner
├── static/             # Assets (wombat_logo.png)
├── templates/          # UI (index.html)
├── docs/               # Auto-generated Debug Logs
└── screenshots/        # User-captured Screen Grabs