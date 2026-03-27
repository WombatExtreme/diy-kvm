from flask import Flask, render_template, request, jsonify, send_file
import serial, time, os, psutil, requests, subprocess, datetime

app = Flask(__name__)
SER_PORT = os.getenv('SERIAL_PORT', '/dev/ttyUSB0')

def play_beep(tone_type="single"):
    """Triggers the D520 internal motherboard beeper"""
    try:
        if tone_type == "startup":
            # Two quick rising chirps
            subprocess.Popen(["beep", "-f", "1000", "-l", "50", "-n", "-f", "1500", "-l", "50"])
        elif tone_type == "shutdown":
            # Long descending tone (Sad beep)
            subprocess.Popen(["beep", "-f", "800", "-l", "200", "-n", "-f", "400", "-l", "400"])
        elif tone_type == "login":
            # Quick high chirp
            subprocess.Popen(["beep", "-f", "2000", "-l", "30"])
        else:
            # Standard notification
            subprocess.Popen(["beep", "-f", "1000", "-l", "100"])
    except:
        pass # Ignore if beep utility isn't in container yet

def send_packet(packet):
    try:
        with serial.Serial(SER_PORT, 9600, timeout=0.1) as ser:
            packet.append(sum(packet) % 256)
            ser.write(bytearray(packet))
            time.sleep(0.01)
            release = [0x57, 0xAB, 0x00, 0x02, 0x08, 0,0,0,0,0,0,0,0]
            release.append(sum(release) % 256)
            ser.write(bytearray(release))
    except: pass

@app.route('/')
def index():
    play_beep("login") # Chirp when someone accesses the UI
    return render_template('index.html')

@app.route('/stats')
def get_stats():
    cpu = psutil.cpu_percent(); ram = psutil.virtual_memory().percent
    bat = psutil.sensors_battery(); pwr = f"{bat.percent}%" if bat else "AC"
    return jsonify(cpu=f"{cpu}%", ram=f"{ram}%", pwr=pwr)

@app.route('/send_key', methods=['POST'])
def handle_key():
    data = request.json
    from mappings import HID_MAP, MOD_MAP
    mod = 0x00
    if data.get('shift'): mod |= MOD_MAP['Shift']
    if data.get('ctrl'): mod |= MOD_MAP['Control']
    if data.get('alt'): mod |= MOD_MAP['Alt']
    key = data.get('key')
    hid = HID_MAP.get(key.lower() if len(key)==1 else key, 0x00)
    if hid: send_packet([0x57, 0xAB, 0x00, 0x02, 0x08, mod, 0x00, hid, 0,0,0,0,0])
    return jsonify(status="ok")

@app.route('/debug_log', methods=['POST'])
def generate_debug():
    ts = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    log_file = f"docs/debug_{ts}.txt"
    try:
        logs = subprocess.check_output(["docker", "compose", "logs", "--tail=20"]).decode('utf-8')
    except: logs = "Logs unavailable."
    with open(log_file, "w") as f:
        f.write(f"WOMBAT-KVM BETA DEBUG - {ts}\n{logs}")
    return jsonify(status=f"Log Created: {log_file}")

@app.route('/reboot_host', methods=['POST'])
def reboot_host():
    play_beep("shutdown") # Alert that the D520 is going down
    subprocess.Popen(["/bin/bash", "-c", "sleep 5 && reboot"])
    return jsonify(status="Rebooting hardware...")

if __name__ == '__main__':
    os.makedirs('screenshots', exist_ok=True)
    os.makedirs('docs', exist_ok=True)
    play_beep("startup") # Chirp on service start
    app.run(host='0.0.0.0', port=5000)