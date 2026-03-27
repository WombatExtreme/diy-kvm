from flask import Flask, render_template, request, jsonify
import serial, time, os, psutil

app = Flask(__name__)
SER_PORT = os.getenv('SERIAL_PORT', '/dev/ttyUSB0')

@app.route('/stats')
def get_stats():
    # CPU & RAM
    cpu_pct = psutil.cpu_percent()
    ram = psutil.virtual_memory()
    
    # Network (Total bytes sent/received since boot)
    net = psutil.net_io_counters()
    
    # Temperature (D520 specific core temp)
    temp = "N/A"
    try:
        t = psutil.sensors_temperatures()
        if 'coretemp' in t: temp = f"{t['coretemp'][0].current}°C"
    except: pass

    # Power (Battery Status)
    battery = psutil.sensors_battery()
    pwr_status = "AC Power"
    if battery:
        pwr_status = f"{battery.percent}% ({'Charging' if battery.power_plugged else 'Discharging'})"

    return jsonify(
        cpu=f"{cpu_pct}%",
        ram=f"{ram.percent}%",
        temp=temp,
        net=f"TX: {net.bytes_sent // 1024**2}MB | RX: {net.bytes_recv // 1024**2}MB",
        power=pwr_status
    )

# ... [Keep your existing /send_key and /send_mouse routes here] ...