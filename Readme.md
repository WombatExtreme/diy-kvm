# DIY-KVM: Dell Latitude D520 Edition

A lightweight, high-performance IP-KVM (Keyboard, Video, Mouse) solution designed to run on legacy hardware. This project repurposes a Dell Latitude D520 (or similar) into a remote management appliance using Debian 13.4 Stable and Docker.

## 🛠 Hardware Requirements
* **Host:** Dell Latitude D520 (Core 2 Duo, 4GB RAM recommended).
* **Video:** HDMI to USB Capture Card (USB 2.0).
* **Control:** CH9329 HID Adapter + CH340 USB-to-Serial Bridge.
* **OS:** Debian 13.4 (Trixie) Stable.
USB 2.0 Power: On the D520, use the rear USB ports for the capture card if possible; they often provide more stable voltage than the side ports.

Video Lag: If the stream is laggy, the D520 CPU might be hitting 100%. Reducing the resolution in the Dockerfile to 800x600 is a pro-move for older dual-core systems.

## 🚀 One-Line Installer
Run this command on your freshly installed Debian 13.4 machine to set up the entire stack:

```bash
curl -sSL https://raw.githubusercontent.com/WombatExtreme/diy-kvm/main/install_kvm.sh | bash

