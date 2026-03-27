#!/bin/bash
# =================================================================
# WOMBAT EXTREME TECHNOLOGIES - REBUILDER v1.0
# =================================================================

echo "--- 🏗️ WOMBAT-KVM: FORCING CLEAN REBUILD ---"

cd ~/diy-kvm

# Stop and remove existing containers/images
sudo docker compose down --rmi local

# Clear old logs and temp screenshots for a fresh start
rm -f docs/debug_*.txt
rm -f screenshots/*.jpg

# Rebuild from the Dockerfile
sudo docker compose up -d --build

echo "--- ✅ REBUILD COMPLETE ---"
echo "Check http://localhost:5000 to verify."