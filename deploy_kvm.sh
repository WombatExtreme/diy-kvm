#!/bin/bash
# =================================================================
# WOMBAT-KVM MASTER DEPLOYER v1.9 (BETA)
# =================================================================

echo "🦊 Starting Wombat-KVM Deployment..."

# 1. Update and Install Dependencies
sudo apt-get update
sudo apt-get install -y docker.io docker-compose curl git beep alsa-utils

# 2. Hardware Permissions (Serial & Video)
# Adds current user to necessary groups for D520 hardware access
sudo usermod -aG dialout,video,docker $USER

# 3. Enable PC Speaker (Motherboard Beeper)
# This ensures the 'Startup' and 'Login' beeps actually work.
sudo modprobe pcspkr
echo "pcspkr" | sudo tee /etc/modules-load.d/pcspkr.conf
sudo amixer -c 0 set Beep 100% unmute 2>/dev/null || echo "Check Alsamixer for Beep settings."

# 4. Directory Structure
mkdir -p ~/diy-kvm/docs
mkdir -p ~/diy-kvm/screenshots
cd ~/diy-kvm

# 5. Set Permissions for Scripts
chmod +x *.sh

# 6. Initialize Crontab (Watchdog & Maintenance)
# Deletes existing KVM crons and adds fresh ones
crontab -l | grep -v "diy-kvm" | crontab -
(crontab -l ; echo "* * * * * /bin/bash $HOME/diy-kvm/watchdog.sh") | crontab -
(crontab -l ; echo "0 0 * * 0 /bin/bash $HOME/diy-kvm/maintenance.sh") | crontab -

# 7. Build and Launch
sudo docker-compose up -d --build

echo "-------------------------------------------------------"
echo "✅ DEPLOYMENT COMPLETE"
echo "URL: http://$(hostname -I | awk '{print $1}'):5000"
echo "-------------------------------------------------------"
echo "Note: You may need to REBOOT for group permissions to apply."