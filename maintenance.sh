#!/bin/bash
# =================================================================
# WOMBAT EXTREME TECHNOLOGIES - WEEKLY MAINTENANCE v1.0
# =================================================================

PROJECT_DIR="$HOME/diy-kvm"
LOG_FILE="$PROJECT_DIR/docs/maintenance_log.txt"

echo "--- 🧹 Starting Wombat-KVM Cleanup: $(date) ---" >> $LOG_FILE

# 1. Clear old Screenshots (Older than 7 days)
find "$PROJECT_DIR/screenshots" -name "*.jpg" -type f -mtime +7 -delete
echo "Cleaned old screenshots." >> $LOG_FILE

# 2. Clear old Debug Logs (Older than 7 days)
find "$PROJECT_DIR/docs" -name "debug_*.txt" -type f -mtime +7 -delete
echo "Cleaned old debug logs." >> $LOG_FILE

# 3. Docker System Prune (Remove unused build cache/stopped containers)
# This keeps the D520 disk lean.
docker system prune -f >> $LOG_FILE

# 4. Check Disk Space
echo "Current Disk Usage:" >> $LOG_FILE
df -h / | grep / >> $LOG_FILE

echo "--- ✅ Maintenance Complete ---" >> $LOG_FILE