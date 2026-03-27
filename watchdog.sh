watchdog.sh#!/bin/bash
# =================================================================
# WOMBAT EXTREME TECHNOLOGIES - WATCHDOG v1.9 (BETA)
# =================================================================

PROJECT_DIR="$HOME/diy-kvm"
LOG_FILE="$PROJECT_DIR/docs/watchdog_events.txt"

# Check if uStreamer is responding on Port 8080
if ! curl -s --head --request GET http://localhost:8080/stream | grep "200 OK" > /dev/null; then
    echo "$(date): [CRITICAL] KVM Stream down! Attempting recovery..." >> $LOG_FILE
    cd "$PROJECT_DIR" && sudo docker compose restart kvm
    echo "$(date): [RECOVERY] Service restarted by Watchdog." >> $LOG_FILE
else
    # Optional: Log successful health check (uncomment for heavy debugging)
    # echo "$(date): [HEALTHY] Stream active." >> $LOG_FILE
    exit 0
fi