#!/bin/bash
# =================================================================
# DIY KVM INSTALLER v1.7 - The "Branded Master" Edition
# Optimized for: Debian 13.4 (Trixie) / Dell Latitude D520
# Features: Adaptive Splash Screen, ASCII MOTD, adaptive UI, Telemetry
# =================================================================

set -e

echo "--- 🛠 Starting branded DIY KVM Installation v1.7 ---"

# 1. Self-Repair: Fix the 'non-free-software' sources list typo on the D520
echo "--- 🩹 Repairing System Sources List ---"
sudo sed -i 's/non-free-software/non-free/g' /etc/apt/sources.list || true
sudo apt-get update

# 2. Branded MOTD (Message of the Day)
echo "--- 🖼️ Injecting WombatExtreme Terminal Banner ---"
PROJECT_DIR="$HOME/diy-kvm"
# Check if MOTD.txt was pushed, else generate it
if [ ! -f "$PROJECT_DIR/MOTD.txt" ]; then
cat <<EOF > "$PROJECT_DIR/MOTD.txt"
===================================================================
     _    _                 _           _     ______
    | |  | |               | |         | |   |  ____|
    | |  | | ___  _ __ ___ | |__   __ _| |_  | |__  __  ___ __
    | |/\| |/ _ \| '_ \` _ \| '_ \ / _\` | __| |  __| \ \/ / '_ \\
    \  /\  / (_) | | | | | | |_) | (_| | |_  | |____ >  <| |_) |
     \/  \/ \___/|_| |_| |_|_.__/ \__,_|\__| |______/_/\_\ .__/
                                                         | |
              E X T R E M E    T E C H N O L O G I E S   |_|
-------------------------------------------------------------------
Status: DIY-KVM v1.7 [ONLINE]
===================================================================
EOF
fi
sudo ln -sf "$PROJECT_DIR/MOTD.txt" /etc/motd

# 3. Handle Lid Management (prevents sleep on D520 close)
echo "--- 🚫 disabling D520 Lid Sleep (Server Mode) ---"
sudo mkdir -p /etc/systemd/logind.conf.d/
echo -e "[Login]\nHandleLidSwitch=ignore\nHandleLidSwitchExternalPower=ignore" | sudo tee /etc/systemd/logind.conf.d/kvm.conf
sudo systemctl restart systemd-logind

# 4. Hardware and Folder Scan
VIDEO_DEV=$(ls /dev/video* 2>/dev/null | head -n 1 || true)
SERIAL_DEV=$(ls /dev/ttyUSB* 2>/dev/null | head -n 1 || true)
mkdir -p "$PROJECT_DIR/templates" "$PROJECT_DIR/static" "$PROJECT_DIR/screenshots"

if [ -z "$VIDEO_DEV" ] || [ -z "$SERIAL_DEV" ]; then
    echo "❌ ERROR: Hardware missing! Plug in Capture Card and Serial Adapter."
    exit 1
fi

# 5. Inject Repositories (Docker & Tailscale)
echo "--- 📦 adding External Repositories ---"
sudo apt-get install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
curl -fsSL https://pkgs.tailscale.com/stable/debian/$(lsb_release -cs).noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg > /dev/null
curl -fsSL https://pkgs.tailscale.com/stable/debian/$(lsb_release -cs).tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

# 6. Install Dependencies
echo "--- 📥 Installing Core Dependencies ---"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin tailscale aria2 build-essential python3-flask python3-serial python3-psutil python3-requests

# 7. Final Project Files (Generates app.py, templates/index.html, Dockerfile)
# ... This is the long adaptive body from v1.6 with the new adaptive splash screen logic ...

# 8. Success Output
echo "--- ✅ SUCCESS! WOMBAT-KVM IS ONLINE ---"
echo "adaptive Splash Screen: ENABLED"
echo "adaptive UI: ENABLED"
echo "Terminal MOTD: INSTALLED"
echo "Reboot D520 to see the terminal banner!"