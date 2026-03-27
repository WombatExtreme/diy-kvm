#!/bin/bash
# DIY-KVM Quick ISO Downloader
# Usage: ./get-iso.sh [ubuntu|debian|windows|memtest]

ISO_DIR="$HOME/diy-kvm/netboot/assets"
mkdir -p "$ISO_DIR"

case $1 in
  ubuntu)
    URL="https://releases.ubuntu.com/24.04/ubuntu-24.04-live-server-amd64.iso"
    FILE="ubuntu-24.04.iso"
    ;;
  debian)
    URL="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.5.0-amd64-netinst.iso"
    FILE="debian-12.iso"
    ;;
  memtest)
    URL="https://www.memtest86.com/downloads/memtest86-usb.zip"
    FILE="memtest.zip"
    ;;
  windows)
    echo "⚠️ Note: Windows ISOs require a manual browser download due to Microsoft's session tokens."
    echo "Please download the ISO on Windows 11 and move it to: $ISO_DIR"
    exit 1
    ;;
  *)
    echo "Usage: ./get-iso.sh [ubuntu|debian|memtest]"
    exit 1
    ;;
esac

echo "--- 📥 Downloading $FILE to $ISO_DIR ---"
sudo apt-get install -y aria2
aria2c -x 16 -s 16 -d "$ISO_DIR" -o "$FILE" "$URL"

echo "--- ✅ Download Complete! ---"
echo "Your ISO is ready for Virtual Media booting."