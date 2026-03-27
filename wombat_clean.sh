#!/bin/bash
# =================================================================
# WOMBAT-KVM AUTOMATED MAINTENANCE & PURGE
# =================================================================

# --- CONFIGURATION ---
LOG_DIR="$HOME/diy-kvm/docs"
KVM_ROOT="$HOME/diy-kvm"
KEEP_DAYS=7
# ---------------------

echo "--- WOMBAT MAINTENANCE START: $(date) ---"

# 1. PURGE OLD THERMAL LOGS & WATCHDOG EVENTS (> 7 Days)
if [ -d "$LOG_DIR" ]; then
    find "$LOG_DIR" -type f -name "*.txt" -mtime +$KEEP_DAYS -delete
    find "$LOG_DIR" -type f -name "*.log" -mtime +$KEEP_DAYS -delete
    echo "Done: Cleaned logs older than $KEEP_DAYS days."
fi

# 2. PURGE OLD SCREENSHOTS/SNAPS (If your Web UI saves them)
if [ -d "$KVM_ROOT/screenshots" ]; then
    find "$KVM_ROOT/screenshots" -type f -name "*.jpg" -mtime +$KEEP_DAYS -delete
    echo "Done: Purged old KVM snapshots."
fi

# 3. DOCKER HOUSEKEEPING
# Cleans up stopped containers, unused networks, and dangling images
# to ensure the D520's storage doesn't bloat.
docker system prune -f --volumes > /dev/null
echo "Done: Docker system pruned."

echo "--- MAINTENANCE COMPLETE ---"