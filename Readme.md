Markdown

# 🦊 WOMBAT-KVM v1.9 [BETA]

### "Smart Tech Done Right"
Developed by **Wombat Extreme Technologies**

A professional-grade, self-healing KVM-over-IP appliance repurposed from legacy Dell Latitude D520 hardware.

---

## 🚀 QUICK INSTALL (ONE-LINER)

To deploy the **Wombat-KVM** on a fresh Debian 13 host, copy and paste this command:

```bash
curl -sSL [https://raw.githubusercontent.com/WombatExtreme/diy-kvm/main/deploy_kvm.sh](https://raw.githubusercontent.com/WombatExtreme/diy-kvm/main/deploy_kvm.sh) | bash

🛠️ PROJECT ARCHITECTURE

    Video Engine: uStreamer (Low-latency MJPEG @ 720p60)

    HID Engine: Python 3 + PySerial (CH9329 Protocol)

    Web UI: Adaptive HTML5/CSS3 with Desktop & Mobile modes

    Watchdog: Health-check daemon (Restarts service on hang)

    Audio: Motherboard speaker alerts for Startup/Login/Reboot

🔌 HARDWARE REQUIREMENTS

    Host Platform: Dell Latitude D520 (Intel Core 2 Duo)

    HID Controller: CH9329 Serial-to-USB Adapter

    Video Capture: USB HDMI UVC Capture Card

    Motherboard: Internal PC Speaker

📂 SCRIPTS & AUTOMATION
Script	Command	Function
Deployer	./deploy_kvm.sh	Sets permissions, crontabs, and initial build.
Watchdog	./watchdog.sh	Checks stream health; auto-restarts on failure.
Maintenance	./maintenance.sh	Deletes logs/screenshots > 7 days old.
Rebuilder	./build_wombat.sh	Forces a clean wipe and fresh container build.
🔬 FINAL BETA CHECKLIST (3-DAY BURN-IN)

    [ ] Thermal Soak: Run 24h with lid closed. Verify CPU temps.

    [ ] HID Buffer: Rapidly type in Mobile UI. Ensure no "stuck" keys.

    [ ] Power Cycle: Pull the D520 plug. Verify services auto-start.

    [ ] Watchdog: Manually stop KVM. Verify auto-restart within 60s.

    [ ] Audio: Confirm Startup, Login, and Reboot tones.

🛠️ TROUBLESHOOTING

If the KVM is unresponsive, check the logs:
Bash

tail -f ~/diy-kvm/docs/watchdog_events.txt

📊 DIAGNOSTIC MONITORING

To watch thermals and watchdog status in real-time, run:
Bash

watch -n 5 "echo '--- THERMALS ---'; cat /sys/class/thermal/thermal_zone0/temp; echo '--- WATCHDOG ---'; tail -n 5 ~/diy-kvm/docs/watchdog_events.txt"

Wombat Extreme Technologies 30 Years of PC Excellence.