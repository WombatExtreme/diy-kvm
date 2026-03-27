#!/bin/bash
# =================================================================
# WOMBAT-KVM SELF-HOSTED HEARTBEAT (FREE & OPEN)
# =================================================================

# --- USER CONFIGURATION ---
# Replace 'MONITOR_SERVER' with your Uptime Kuma IP or Hostname
# Replace 'YOUR_KEY' with the Push Token from your Kuma dashboard
MONITOR_IP="CHANGE_ME"
PUSH_TOKEN="CHANGE_ME"
# ---------------------------

# 1. PING THE MONITORING NODE
# This tells your Uptime Kuma instance "I am alive"
if [ "$MONITOR_IP" != "CHANGE_ME" ]; then
    curl -fsS --retry 3 "http://$MONITOR_IP:3001/api/push/$PUSH_TOKEN?status=up&msg=Wombat_is_Alive" > /dev/null
fi

# 2. THERMAL LOGGING (For the 3-Day Burn-In)
# Saves to a local doc so you can verify the D520 didn't melt.
TEMP_RAW=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null)

if [ ! -z "$TEMP_RAW" ]; then
    TEMP_C=$((TEMP_RAW/1000))
    echo "$(date '+%Y-%m-%d %H:%M:%S') : ${TEMP_C}C" >> ~/diy-kvm/docs/thermal_history.txt
fi

# 3. BATTERY FAILSAFE (Optional)
# If a battery exists and is low, it logs a warning.
if [ -f /sys/class/power_supply/BAT0/capacity ]; then
    BATT=$(cat /sys/class/power_supply/BAT0/capacity)
    if [ "$BATT" -lt 20 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') : ⚠️ LOW BATTERY WARNING: ${BATT}%" >> ~/diy-kvm/docs/watchdog_events.txt
    fi
fi