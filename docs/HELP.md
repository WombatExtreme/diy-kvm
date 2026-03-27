# 🆘 Wombat-KVM Help & Troubleshooting
**Version:** 1.7 | **Hardware:** Dell Latitude D520

### 📺 Video Issues (Black Screen / No Signal)
* **Check LEDs:** Is the HDMI Capture Card light on?
* **Resolution Mismatch:** The target PC must be set to 1920x1080 or 1280x720. High-refresh rates (above 60Hz) will cause a black screen.
* **Bus Saturation:** If the D520 is lagging, move the Capture Card to a different USB port. The D520 has two separate internal USB buses.

### ⌨️ Input Issues (Keyboard/Mouse Not Working)
* **Serial Lock:** If the keyboard stops responding, the CH9329 might be "stuck." Click the **Update App** button to restart the container and reset the serial buffer.
* **Device Path:** Ensure the serial adapter is at `/dev/ttyUSB0`. If you have multiple adapters, it may have moved to `/dev/ttyUSB1`.

### ⚡ Power & Sleep Issues
* **Lid Close:** If the KVM dies when you close the lid, run `sudo systemctl status systemd-logind` to ensure the "Lid-Sleep Kill" fix is active.
* **Thermal Throttling:** If the D520 fans are screaming, the CPU is getting too hot with the lid closed. Open the lid slightly to allow airflow.

### 🌐 Network Issues
* **Tailscale:** If you can't access the UI remotely, run `tailscale status` to verify the D520 is "Online" and has a valid IP.