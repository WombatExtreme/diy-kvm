#!/bin/bash
# =================================================================
# WOMBAT-KVM AUTOMATED CRON SCHEDULER (V1.9 BETA)
# =================================================================

# Get the current user and home directory automatically
USER_HOME=$HOME
SCRIPT_DIR="$USER_HOME/diy-kvm"

echo "🦊 Wombat Extreme Technologies: Setting up automation..."

# 1. MAKE SURE ALL SCRIPTS ARE EXECUTABLE
chmod +x "$SCRIPT_DIR"/*.sh

# 2. DEFINE THE CRON JOBS
# - Heartbeat/Thermal Log: Every minute
# - Watchdog Service: Every 5 minutes (to check if KVM is alive)
# - Weekly Cleanup: Every Sunday at 3:00 AM

JOB_HEARTBEAT="* * * * * /bin/bash $SCRIPT_DIR/heartbeat.sh >> $SCRIPT_DIR/docs/heartbeat_log.txt 2>&1"
JOB_WATCHDOG="*/5 * * * * /bin/bash $SCRIPT_DIR/watchdog.sh >> $SCRIPT_DIR/docs/watchdog_events.txt 2>&1"
JOB_CLEANUP="0 3 * * 0 /bin/bash $SCRIPT_DIR/wombat_clean.sh >> $SCRIPT_DIR/docs/maint_log.txt 2>&1"

# 3. WRITE TO CRONTAB (WITHOUT DUPLICATES)
(crontab -l 2>/dev/null | grep -v "diy-kvm"; echo "$JOB_HEARTBEAT"; echo "$JOB_WATCHDOG"; echo "$JOB_CLEANUP") | crontab -

echo "✅ SUCCESS! Automation is now live."
echo "   - Heartbeat: Running every 1 minute"
echo "   - Watchdog:  Running every 5 minutes"
echo "   - Cleanup:   Running every Sunday at 3 AM"