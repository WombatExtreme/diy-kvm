#!/bin/bash
# =================================================================
# DIY KVM INSTALLER v1.6 - The "Auto-Update" Edition
# Optimized for: Debian 13.4 (Trixie) / Dell Latitude D520
# Features: One-Click Git Update, Adaptive UI, Telemetry, Screenshots
# =================================================================

set -e

echo "--- 🛠 Starting Universal DIY KVM Installation v1.6 ---"

# 1. System Repair & Lid Management
echo "--- 🩹 Disabling Lid Sleep & Repairing Sources ---"
sudo sed -i 's/non-free-software/non-free/g' /etc/apt/sources.list || true
sudo mkdir -p /etc/systemd/logind.conf.d/
echo -e "[Login]\nHandleLidSwitch=ignore\nHandleLidSwitchExternalPower=ignore" | sudo tee /etc/systemd/logind.conf.d/kvm.conf
sudo systemctl restart systemd-logind

# 2. Hardware Scan
VIDEO_DEV=$(ls /dev/video* 2>/dev/null | head -n 1 || true)
SERIAL_DEV=$(ls /dev/ttyUSB* 2>/dev/null | head -n 1 || true)
PROJECT_DIR="$HOME/diy-kvm"

if [ -z "$VIDEO_DEV" ] || [ -z "$SERIAL_DEV" ]; then
    echo "❌ ERROR: Hardware missing! Check USB connections."
    exit 1
fi

# 3. Inject Repositories (Docker & Tailscale)
sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
curl -fsSL https://pkgs.tailscale.com/stable/debian/$(lsb_release -cs).noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg > /dev/null
curl -fsSL https://pkgs.tailscale.com/stable/debian/$(lsb_release -cs).tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

# 4. Install Dependencies
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin tailscale aria2 build-essential python3-flask python3-serial python3-psutil python3-requests git

# 5. Project Folders
mkdir -p "$PROJECT_DIR/templates" "$PROJECT_DIR/screenshots" "$PROJECT_DIR/netboot/assets"
cd "$PROJECT_DIR"

# 6. Generate mappings.py
cat <<EOF > mappings.py
HID_MAP = {'a':0x04,'b':0x05,'c':0x06,'d':0x07,'e':0x08,'f':0x09,'g':0x0a,'h':0x0b,'i':0x0c,'j':0x0d,'k':0x0e,'l':0x0f,'m':0x10,'n':0x11,'o':0x12,'p':0x13,'q':0x14,'r':0x15,'s':0x16,'t':0x17,'u':0x18,'v':0x19,'w':0x1a,'x':0x1b,'y':0x1c,'z':0x1d,'1':0x1e,'2':0x1f,'3':0x20,'4':0x21,'5':0x22,'6':0x23,'7':0x24,'8':0x25,'9':0x26,'0':0x27,'Enter':0x28,'Escape':0x29,'Backspace':0x2a,'Tab':0x2b,'Space':0x2c,'-':0x2d,'=':0x2e,'[':0x2f,']':0x30,'\\\\':0x31,';':0x33,"'":0x34,'\`':0x35,',':0x36,'.':0x37,'/':0x38,'CapsLock':0x39,'F1':0x3a,'F2':0x3b,'F3':0x3c,'F4':0x3d,'F5':0x3e,'F6':0x3f,'F7':0x40,'F8':0x41,'F9':0x42,'F10':0x43,'F11':0x44,'F12':0x45,'PrintScreen':0x46,'Delete':0x4c,'ArrowRight':0x4f,'ArrowLeft':0x50,'ArrowDown':0x51,'ArrowUp':0x52}
MOD_MAP = {'Control':0x01,'Shift':0x02,'Alt':0x04,'Meta':0x08}
EOF

# 7. Generate app.py (With Update Logic)
cat <<EOF > app.py
from flask import Flask, render_template, request, jsonify, send_file
import serial, time, os, psutil, requests, subprocess

app = Flask(__name__)
SER_PORT = os.getenv('SERIAL_PORT', '$SERIAL_DEV')

def send_packet(packet):
    try:
        with serial.Serial(SER_PORT, 9600, timeout=0.1) as ser:
            packet.append(sum(packet) % 256)
            ser.write(bytearray(packet))
            time.sleep(0.01)
            ser.write(bytearray([0x57, 0xAB, 0x00, 0x02, 0x08, 0,0,0,0,0,0,0,0, 0xED]))
    except: pass

@app.route('/stats')
def get_stats():
    cpu = psutil.cpu_percent()
    ram = psutil.virtual_memory().percent
    bat = psutil.sensors_battery()
    pwr = f"{bat.percent}%" if bat else "AC"
    return jsonify(cpu=f"{cpu}%", ram=f"{ram}%", pwr=pwr)

@app.route('/update', methods=['POST'])
def update_self():
    # Trigger a background update script so we don't kill the flask thread mid-run
    subprocess.Popen(["/bin/bash", "-c", "sleep 2 && cd /app && git pull && docker compose up -d --build"])
    return jsonify(status="Update triggered! Interface will reboot in 10s.")

@app.route('/screenshot')
def take_ss():
    ts = int(time.time())
    path = f"screenshots/ss_{ts}.jpg"
    try:
        r = requests.get("http://localhost:8080/snapshot", timeout=2)
        with open(path, 'wb') as f: f.write(r.content)
        return send_file(path, as_attachment=True)
    except: return "Capture Failed", 500

@app.route('/')
def index(): return render_template('index.html')

@app.route('/send_key', methods=['POST'])
def handle_key():
    data = request.json
    mod = 0x00
    if data.get('shift'): mod |= MOD_MAP['Shift']
    if data.get('ctrl'): mod |= MOD_MAP['Control']
    if data.get('alt'): mod |= MOD_MAP['Alt']
    hid = HID_MAP.get(data.get('key').lower() if len(data.get('key'))==1 else data.get('key'), 0x00)
    if hid: send_packet([0x57, 0xAB, 0x00, 0x02, 0x08, mod, 0x00, hid, 0,0,0,0,0])
    return jsonify(status="ok")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

# 8. Generate Adaptive templates/index.html (With Update Button)
cat <<EOF > templates/index.html
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Wombat DIY-KVM Master v1.6</title>
    <style>
        body { background:#111; color:#0f0; font-family:monospace; margin:0; text-align:center; }
        #dash { background:#222; padding:10px; border-bottom:1px solid #444; font-size:12px; display:flex; justify-content:center; gap:15px; }
        #dash span { color:#fff; }
        #stream { display:block; max-width:100%; height:auto; border:2px solid #333; margin: 10px auto; }
        .controls { margin-top:15px; display:flex; justify-content:center; gap:10px; padding:10px; flex-wrap: wrap; }
        .btn { background:#333; color:#0f0; border:1px solid #0f0; padding:10px 15px; cursor:pointer; font-weight:bold; }
        .btn:hover { background:#0f0; color:#000; }
        .danger { border-color:red; color:red; }
        .update-btn { border-color: #0af; color: #0af; font-size: 10px; }
        @media (max-width: 800px) {
            .btn { width: 90%; padding: 15px; font-size: 16px; }
            #pbox { width: 90%; background: #000; color: #0f0; border: 1px solid #0f0; padding: 10px; margin-top: 10px; }
        }
    </style>
</head>
<body>
    <div id="dash">
        <div>CPU: <span id="c">-</span></div> <div>RAM: <span id="r">-</span></div> <div>PWR: <span id="p">-</span></div>
        <button class="btn update-btn" onclick="if(confirm('Pull latest from GitHub?')) fetch('/update',{method:'POST'})">🔄 UPDATE APP</button>
    </div>
    <img id="stream" src="http://{{ request.host.split(':')[0] }}:8080/stream">
    <div class="controls">
        <button class="btn" onclick="window.location='/screenshot'">📸 SCREENSHOT</button>
        <button class="btn danger" onclick="fetch('/send_key',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({key:'Delete',ctrl:true,alt:true})})">CTRL+ALT+DEL</button>
    </div>
    <textarea id="pbox" rows="2" placeholder="Mobile Input..."></textarea>
    <script>
        setInterval(() => {
            fetch('/stats').then(r=>r.json()).then(d=>{
                document.getElementById('c').innerText=d.cpu; document.getElementById('r').innerText=d.ram;