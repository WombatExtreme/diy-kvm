![DIY KVM - Trash to Treasure](header.png)

# DIY-KVM: Dell Latitude D520 Edition

A lightweight, high-performance IP-KVM (Keyboard, Video, Mouse) solution designed to run on legacy hardware. This project repurposes a Dell Latitude D520 (or similar) into a remote management appliance using Debian 13.4 Stable and Docker.

## 🛠 Hardware Requirements
* **Host:** Dell Latitude D520 (Core 2 Duo, 4GB RAM recommended).
* **Video:** HDMI to USB Capture Card (USB 2.0).
* **Control:** CH9329 HID Adapter + CH340 USB-to-Serial Bridge.
* **OS:** Debian 13.4 (Trixie) Stable.
USB 2.0 Power: On the D520, use the rear USB ports for the capture card if possible; they often provide more stable voltage than the side ports.

Video Lag: If the stream is laggy, the D520 CPU might be hitting 100%. Reducing the resolution in the Dockerfile to 800x600 is a pro-move for older dual-core systems.

Part,Approx. Cost,Purpose
HDMI Capture Card,$3.59,Captures video from the target PC. https://www.aliexpress.us/item/3256806413218882.html?pvid=bf572e03-249c-4963-ad0a-46a1676bc008&pdp_ext_f=%7B%22ship_from%22%3A%22CN%22%2C%22sku_id%22%3A%2212000037780798078%22%7D&scm=1007.57594.431530.0&scm-url=1007.57594.431530.0&scm_id=1007.57594.431530.0&pdp_npi=6%40dis%21USD%21US%20%248.60%21US%20%244.30%21%21%2159.18%2129.59%21%402101e8f317746163038636810e3cea%2112000037780798078%21gdf%21US%21701655678%21X%211%210%21n_tag%3A-29919%3Bd%3A712a5687%3Bm03_new_user%3A-29895&mainPicRatio=1&spm=a2g0o.tm1000056545.9519976340.d10&aecmd=true&gatewayAdapt=glo2usa
CH9329 USB Adapter,$1.76 ,Sends keystrokes to the target PC. https://www.aliexpress.com/p/order/index.html?spm=a2g0o.tm1000056545.headerAcount.2.59026f3du5Xxo5
Old Laptop (D520),Free/E-waste,Acts as the KVM server & Tailscale node.
## 🚀 One-Line Installer
Run this command on your freshly installed Debian 13.4 machine to set up the entire stack:

```bash
curl -sSL https://raw.githubusercontent.com/WombatExtreme/diy-kvm/main/install_kvm.sh | bash

