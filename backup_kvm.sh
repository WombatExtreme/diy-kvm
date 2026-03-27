#!/bin/bash
# DIY KVM Backup Script

# Find the USB stick (assumes it is mounted at /media/...)
BACKUP_DIR=$(find /media/$USER -maxdepth 1 -type d | grep -v "/media/$USER$" | head -n 1)

if [ -z "$BACKUP_DIR" ]; then
    echo "❌ USB Drive not found in /media/$USER. Please insert a USB stick."
    exit 1
fi

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/diy_kvm_backup_$TIMESTAMP.tar.gz"

echo "--- 💾 Backing up KVM settings to $BACKUP_FILE ---"

# Compress the project folder
tar -czf "$BACKUP_FILE" -C ~ diy-kvm

echo "--- ✅ Backup Complete! ---"