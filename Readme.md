<pre>
[W][O][M][B][A][T]   [K][V][M]
 ------------------------------
  EXTREME  TECHNOLOGIES  (v1.9)
 ------------------------------

---

A professional-grade, self-healing KVM-over-IP appliance repurposed from legacy Dell Latitude D520 hardware. Optimized for headless rack operation, remote BIOS management, and mobile accessibility.

---

[1] 🚀 QUICK INSTALL (ONE-LINER)

Copy and paste this command into your Debian 13 "Trixie" terminal:

> curl -sSL https://raw.githubusercontent.com/WombatExtreme/diy-kvm/main/deploy_kvm.sh | bash

---

[2] 🔌 HARDWARE REQUIREMENTS

* Host Platform: Dell Latitude D520 (Intel Core 2 Duo)
* HID Controller: CH9329 Serial-to-USB Adapter
* Video Capture: USB HDMI UVC Capture Card
* Motherboard:   Internal PC Speaker (for Beta Audio Alerts)

---

[3] 📂 SCRIPTS & AUTOMATION

+------------+------------------+--------------------------------------------+
| Script     | Command          | Function                                   |
+------------+------------------+--------------------------------------------+
| Deployer   | deploy_kvm.sh    | Sets permissions, crontabs, & initial build. |
| Watchdog   | watchdog.sh      | Checks stream health every 60s; auto-restarts. |
| Rebuilder  | build_wombat.sh  | Forces a clean wipe and fresh container build. |
| Maintain   | maintenance.sh   | Deletes logs/screenshots > 7 days old.     |
+------------+------------------+--------------------------------------------+

---

[4] 🔬 FINAL BETA CHECKLIST (3-DAY BURN-IN)

[ ] Thermal Soak: Run 24h with lid closed. Use 'GEN DEBUG LOG' for CPU temps.
[ ] HID Buffer:   Rapidly type in Mobile UI. Ensure no "stuck" keys or lag.
[ ] Power Cycle:  Pull the D520 plug. Verify all services auto-start.
[ ] Watchdog:     Manually docker stop kvm. Verify restart within 60s.
[ ] Audio:        Confirm "Startup" chirp, "Login" beep, and "Reboot" tone.

---

[5] 🛠️ TROUBLESHOOTING

If the KVM is unresponsive, use the **Debug Log** button or run:

> tail -f ~/diy-kvm/docs/watchdog_events.txt

---

[6] 📊 DIAGNOSTIC MONITORING

To watch thermals and watchdog status in real-time, run:

> watch -n 5 "echo '--- THERMALS ---'; cat /sys/class/thermal/thermal_zone0/temp; echo '--- WATCHDOG ---'; tail -n 5 ~/diy-kvm/docs/watchdog_events.txt"

</pre>
🛠️ Hardware Connectivity: The CH9329 <-> CH340 Bridge

This project uses a dual-chip serial bridge to translate HID (Keyboard/Mouse) commands from the Client PC to the KVM Server (D520).

Wiring Diagram (TTL Level):

    CH9329 TX -->  CH340 RX

    CH9329 RX <--  CH340 TX

    GND <--> GND (CRITICAL: Floating grounds cause erratic typing!)

Serial Specifications:

    Baud Rate: 9600

    Data Bits: 8

    Parity: None

    Stop Bits: 1

Troubleshooting the Link:

    Device Not Found: Ensure the CH340 is visible on the D520 by running ls /dev/ttyUSB*. If it doesn't appear, check your USB header connections.

    Permission Denied: The wombat user must be in the dialout group to access the serial port. Our setup_cron.sh handles this automatically.

    Phantom Keystrokes: Usually caused by EMI or a missing common ground between the two USB modules. Ensure the GND pins are jumped together.
---

## ☕ SUPPORT THE PROJECT

**Wombat-KVM** is, and always will be, **100% Free and Open Source**. 

If this project saved you from buying a $500 commercial KVM, or if you just want to support 30 years of "Extreme" PC tinkering, feel free to buy the developer a coffee or a spare CMOS battery:

* [ ] **Buy Me A Coffee:** buymeacoffee.com/wombatextreme
* [ ] **PayPal:** paypal.me/KristopherJenkins


*No paywalls. No corporate bloat. Just Smart Tech Done Right.*

---
**Wombat Extreme Technologies** *Est. 1996 | Dedicated to Repurposing the Past for the Future.*