## ⚡ QUICK INSTALL (ONE-LINER)
If you are on a fresh Debian 13 "Trixie" install on a D520, run this command to pull the repository and launch the **Wombat-KVM** environment:

```bash
curl -sSL [https://raw.githubusercontent.com/](https://raw.githubusercontent.com/)WombatExtreme/diy-kvm/main/deploy_kvm.sh | bash

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

---

## 🛠️ SCRIPTS & AUTOMATION GUIDE
The following scripts manage the lifecycle, health, and maintenance of the Wombat-KVM.

### 1. `deploy_kvm.sh` (The Master Setup)
* **Purpose:** One-time setup of hardware permissions, Docker builds, and Crontab scheduling.
* **Usage:** `bash deploy_kvm.sh`
* **Action:** Sets `dialout/video` groups and initializes the Watchdog.

### 2. `watchdog.sh` (The Health Monitor)
* **Purpose:** Runs in the background every 60 seconds to ensure the MJPEG stream is active.
* **Usage:** Automated via Crontab (or `bash watchdog.sh` for manual testing).
* **Action:** Restarts the `kvm` container if the web port (8080) returns a 404/500 error.

### 3. `maintenance.sh` (The Janitor)
* **Purpose:** Prevents the D520's internal storage from filling up during the Beta phase.
* **Usage:** `bash maintenance.sh` (Scheduled for Sundays at 00:00).
* **Action:** Deletes screenshots/logs older than 7 days and clears the Docker build cache.

### 4. `build_wombat.sh` (The Rebuilder)
* **Purpose:** Completely wipes the local directory and reconstructs the file structure.
* **Usage:** `bash build_wombat.sh`
* **Warning:** Use only if you need a "factory reset" of the project files.

---

## 🔬 FINAL BETA CHECKLIST (3-Day Burn-In)
*Execute these tests before moving from BETA to PRODUCTION.*

- [ ] **Thermal Soak:** Run for 24 hours with the lid closed. Check `GEN DEBUG LOG` for CPU temps.
- [ ] **HID Buffer Test:** Rapidly type in the Mobile UI. Ensure no "stuck" keys or lag.
- [ ] **Hard Power Cycle:** Pull the D520 power plug. Verify all 3 services (Video, API, Netboot) auto-start.
- [ ] **Watchdog Test:** Manually run `docker compose stop kvm`. Verify the system restarts within 60s.
- [ ] **Audio Validation:** Confirm "Startup" chirp, "Login" beep, and "Reboot" descending tone.

---
**Wombat Extreme Technologies**
*30 Years of PC Excellence. Smart Tech Done Right.*