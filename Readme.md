# 🦊 WOMBAT-KVM v1.9 [BETA]
### "Smart Tech Done Right"
Developed by **Wombat Extreme Technologies**

A professional-grade, self-healing KVM-over-IP appliance repurposed from legacy Dell Latitude D520 hardware. Optimized for headless rack operation, remote BIOS management, and mobile accessibility.
## 🚀 QUICK INSTALL (ONE-LINER)
To deploy the **Wombat-KVM** on a fresh Debian 13 "Trixie" host, copy and paste this command into your terminal:

```bash
curl -sSL [https://raw.githubusercontent.com/](https://raw.githubusercontent.com/)WombatExtreme/diy-kvm/main/deploy_kvm.sh | bash
---
🛠️ PROJECT ARCHITECTURE

This project transforms a 20-year-old laptop into a modern remote management tool:

    Video Engine: uStreamer (Low-latency MJPEG @ 720p60).

    HID Engine: Python 3 + PySerial (CH9329 Protocol).

    Web UI: Adaptive HTML5/CSS3 with Desktop & Mobile input modes.

    Watchdog: Health-check daemon (Restarts service on stream hang).

    Audio: Motherboard speaker alerts for Startup, Login, and Reboot.

🔌 HARDWARE REQUIREMENTS

    Host Platform: Dell Latitude D520 (Intel Core 2 Duo).

    HID Controller: CH9329 Serial-to-USB Adapter.

    Video Capture: USB HDMI UVC Capture Card.

    Motherboard: Internal PC Speaker (for Beta Audio Alerts).

📂 SCRIPTS & AUTOMATION
Script	Command	Function
Deployer	./deploy_kvm.sh	Sets permissions, crontabs, and initial build.
Watchdog	./watchdog.sh	Checks stream health every 60s; auto-restarts on failure.
Maintenance	./maintenance.sh	Deletes logs/screenshots > 7 days old; prunes Docker.
Rebuilder	./build_wombat.sh	Forces a clean wipe and fresh container build.
🔬 FINAL BETA CHECKLIST (3-DAY BURN-IN)

Execute these tests to verify "Wombat Extreme" stability.

    [ ] Thermal Soak: Run 24h with lid closed. Use GEN DEBUG LOG to verify CPU temps.

    [ ] HID Buffer: Rapidly type in Mobile UI. Ensure no "stuck" keys or lag.

    [ ] Power Cycle: Pull the D520 plug. Verify all services auto-start on power-on.

    [ ] Watchdog: Manually docker stop kvm. Verify auto-restart within 60s.

    [ ] Audio: Confirm "Startup" chirp, "Login" beep, and "Reboot" tone.

🛠️ TROUBLESHOOTING

If the KVM is unresponsive, use the Debug Log button in the Web UI or run:
Bash

tail -f ~/diy-kvm/docs/watchdog_events.txt

Wombat Extreme Technologies
30 Years of PC Excellence.


---

### 📊 The "One-Tap" Diagnostic Command
To check your logs, CPU temps, and Watchdog status all at once while you are testing, run this in your D520 terminal:

```bash
watch -n 5 "echo '--- THERMALS ---'; cat /sys/class/thermal/thermal_zone0/temp; echo '--- WATCHDOG ---'; tail -n 5 ~/diy-kvm/docs/watchdog_events.txt"

This will refresh every 5 seconds so you can watch the D520 "breath" during the test.


