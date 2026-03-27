# DIY-KVM: Dell Latitude D520 Edition

A lightweight, high-performance IP-KVM (Keyboard, Video, Mouse) solution designed to run on legacy hardware. This project repurposes a Dell Latitude D520 (or similar) into a remote management appliance using Debian 13.4 Stable and Docker.

## 🛠 Hardware Requirements
* **Host:** Dell Latitude D520 (Core 2 Duo, 4GB RAM recommended).
* **Video:** HDMI to USB Capture Card (USB 2.0).
* **Control:** CH9329 HID Adapter + CH340 USB-to-Serial Bridge.
* **OS:** Debian 13.4 (Trixie) Stable.

## 🚀 One-Line Installer
Run this command on your freshly installed Debian 13.4 machine to set up the entire stack:

```bash
curl -sSL https://raw.githubusercontent.com/WombatExtreme/diy-kvm/main/install_kvm.sh | bash