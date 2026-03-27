#!/bin/bash
# =================================================================
# WOMBAT EXTREME TECHNOLOGIES - MASTER WATCHDOG & DEPLOYER v1.9
# =================================================================

PROJECT_DIR="$HOME/diy-kvm"
WATCHDOG_SCRIPT="$PROJECT_DIR/watchdog.sh"

echo "--- 🛠️ Starting Final Production Deployment ---"

# 1. Create the Watchdog Script
cat <<'EOF' > "$WATCHDOG_SCRIPT"
#!/bin/bash
# Checks if the KVM stream is alive. If not, restarts Docker.
while true; do
    if ! curl -s --head  --request GET http://localhost:8080/stream | grep "200 OK" > /dev/null; then
        echo "$(date): KVM Stream down! Restarting services..." >> $HOME/kvm_watchdog.log
        cd $HOME/diy-kvm && sudo docker compose restart kvm
    fi
    sleep 60
done
EOF

chmod +x "$WATCHDOG_SCRIPT"

# 2. Fix Hardware Permissions (Serial & Video)
echo "--- 🔒 Setting Hardware Permissions ---"
sudo usermod -aG dialout $USER
sudo usermod -aG video $USER

# 3. Build and Launch the Containers
echo "--- 🏗️ Building Wombat-KVM Image (v1.9) ---"
cd "$PROJECT_DIR"
sudo docker compose up -d --build

# 4. Set up the Watchdog in Crontab
echo "--- 🕒 Scheduling Auto-Start & Watchdog ---"
# Remove old entries to prevent duplicates
crontab -l | grep -v "diy-kvm" | crontab -
# Add new reboot and watchdog entries
(crontab -l ; echo "@reboot sleep 30 && cd $PROJECT_DIR && sudo docker compose up -d") | crontab -
(crontab -l ; echo "@reboot sleep 60 && bash $WATCHDOG_SCRIPT") | crontab -

echo "--- ✅ DEPLOYMENT COMPLETE ---"
echo "Watchdog is active. Logs available at ~/kvm_watchdog.log"