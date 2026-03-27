#!/bin/bash
# =================================================================
# DIY KVM INSTALLER v1.1 - The "Master Edition"
# Optimized for: Debian 13.4 Stable (Trixie) 
# Support: Dell Latitude D520 / any x86_64 Linux PC
# =================================================================

set -e

echo "--- 🛠 Starting Universal DIY KVM Installation ---"

# 1. Identify User Context
CURRENT_USER=$USER
USER_HOME=$HOME
PROJECT_DIR="$USER_HOME/diy-kvm"

echo "✅ Target User: $CURRENT_USER"
echo "✅ Project Directory: $PROJECT_DIR"

# 2. Hardware Validation (Dynamic Detection)
echo "--- 🔍 Scanning for Hardware ---"
VIDEO_DEV=$(ls /dev/video* 2>/dev/null | head -n 1 || true)
SERIAL_DEV=$(ls /dev/ttyUSB* 2>/dev/null | head -n 1 || true)

if [ -z "$VIDEO_DEV" ] || [ -z "$SERIAL_DEV" ]; then
    echo "❌ ERROR: Hardware missing!"
    echo "   Ensure your HDMI Capture and CH340 adapter are plugged in."
    exit 1
fi
echo "✅ Found Video: $VIDEO_DEV"
echo "✅ Found Serial: $SERIAL_DEV"

# 3. System Prep & Dependencies
echo "--- 📦 Installing System Dependencies ---"
sudo apt-get update

# Install basics needed to add new repos
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# --- ADD DOCKER REPO ---
echo "--- 🐳 Adding Docker Repository ---"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# --- ADD TAILSCALE REPO ---
echo "--- 🔗 Adding Tailscale Repository ---"
curl -fsSL https://pkgs.tailscale.com/stable/debian/$(lsb_release -cs).noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg > /dev/null
curl -fsSL https://pkgs.tailscale.com/stable/debian/$(lsb_release -cs).tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

# Now update and install everything
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin tailscale aria2 build-essential

# 4. Create Project Directory Structure
mkdir -p "$PROJECT_DIR/templates"
mkdir -p "$PROJECT_DIR/netboot/assets"
mkdir -p "$PROJECT_DIR/netboot/config"
cd "$PROJECT_DIR"

# 5. Generate mappings.py
cat <<EOF > mappings.py
HID_MAP = {
    'a': 0x04, 'b': 0x05, 'c': 0x06, 'd': 0x07, 'e': 0x08, 'f': 0x09, 'g': 0x0a,
    'h': 0x0b, 'i': 0x0c, 'j': 0x0d, 'k': 0x0e, 'l': 0x0f, 'm': 0x10, 'n': 0x11,
    'o': 0x12, 'p': 0x13, 'q': 0x14, 'r': 0x15, 's': 0x16, 't': 0x17, 'u': 0x18,
    'v': 0x19, 'w': 0x1a, 'x': 0x1b, 'y': 0x1c, 'z': 0x1d, '1': 0x1e, '2': 0x1f, 
    '3': 0x20, '4': 0x21, '5': 0x22, '6': 0x23, '7': 0x24, '8': 0x25, '9': 0x26, 
    '0': 0x27, 'Enter': 0x28, 'Escape': 0x29, 'Backspace': 0x2a, 'Tab': 0x2b, 
    'Space': 0x2c, '-': 0x2d, '=': 0x2e, '[': 0x2f, ']': 0x30, '\\\\': 0x31, 
    ';': 0x33, "'": 0x34, '\`': 0x35, ',': 0x36, '.': 0x37, '/': 0x38, 
    'CapsLock': 0x39, 'F1': 0x3a, 'F2': 0x3b, 'F3': 0x3c, 'F4': 0x3d, 'F5': 0x3e, 
    'F6': 0x3f, 'F7': 0x40, 'F8': 0x41, 'F9': 0x42, 'F10': 0x43, 'F11': 0x44, 
    'F12': 0x45, 'PrintScreen': 0x46, 'Delete': 0x4c, 'ArrowRight': 0x4f, 
    'ArrowLeft': 0x50, 'ArrowDown': 0x51, 'ArrowUp': 0x52
}
MOD_MAP = {'Control': 0x01, 'Shift': 0x02, 'Alt': 0x04, 'Meta': 0x08}
EOF

# 6. Generate app.py
cat <<EOF > app.py
from flask import Flask, render_template, request, jsonify
import serial, time, os
from mappings import HID_MAP, MOD_MAP

app = Flask(__name__)
SER_PORT = os.getenv('SERIAL_PORT', '$SERIAL_DEV')

def send_packet(packet):
    try:
        with serial.Serial(SER_PORT, 9600, timeout=0.1) as ser:
            packet.append(sum(packet) % 256)
            ser.write(bytearray(packet))
            time.sleep(0.01)
            release = [0x57, 0xAB, 0x00, 0x02, 0x08] + [0]*8 + [0xED]
            ser.write(bytearray(release))
    except Exception as e: print(f"Serial Error: {e}")

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

@app.route('/send_mouse', methods=['POST'])
def handle_mouse():
    data = request.json
    packet = [0x57, 0xAB, 0x00, 0x05, 0x05, 0x01, data.get('btn', 0), data.get('x',0) & 0xFF, data.get('y',0) & 0xFF, 0]
    send_packet(packet)
    return jsonify(status="ok")

@app.route('/paste', methods=['POST'])
def handle_paste():
    for char in request.json.get('text', ''):
        mod = 0x02 if char.isupper() or char in '!@#$%^&*()_+' else 0x00
        hid = HID_MAP.get(char.lower(), 0x00)
        if hid: 
            send_packet([0x57, 0xAB, 0x00, 0x02, 0x08, mod, 0x00, hid, 0,0,0,0,0])
            time.sleep(0.05)
    return jsonify(status="ok")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

# 7. Generate templates/index.html
cat <<EOF > templates/index.html
<!DOCTYPE html>
<html>
<head>
    <title>DIY KVM Console</title>
    <style>
        body { background: #1a1a1a; color: #0f0; font-family: monospace; text-align: center; margin: 0; padding: 20px; }
        #container { position: relative; display: inline-block; border: 5px solid #333; cursor: crosshair; }
        #stream { max-width: 100%; display: block; border: 1px solid #444; }
        #mousepad { position: absolute; top:0; left:0; width:100%; height:100%; }
        .controls { margin-top: 20px; }
        textarea { background: #000; color: #0f0; width: 400px; height: 60px; border: 1px solid #0f0; padding: 10px; }
        button { background: #333; color: #0f0; border: 1px solid #0f0; padding: 10px 20px; cursor: pointer; font-family: monospace; }
        button:hover { background: #0f0; color: #000; }
        .danger { background: #600; color: #fff; border-color: red; }
    </style>
</head>
<body>
    <h2>REMOTE CONSOLE ACCESS</h2>
    <div id="container">
        <img id="stream" src="http://{{ request.host.split(':')[0] }}:8080/stream">
        <div id="mousepad"></div>
    </div>
    <div class="controls">
        <button class="danger" onclick="fetch('/send_key', {method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify({key:'Delete', ctrl:true, alt:true})})">SEND CTRL+ALT+DEL</button>
        <br><br>
        <textarea id="pbox" placeholder="Paste text here to type into target PC..."></textarea><br>
        <button onclick="fetch('/paste', {method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify({text:document.getElementById('pbox').value})})">TYPE CLIPBOARD</button>
    </div>
    <script>
        const pad = document.getElementById('mousepad');
        window.addEventListener('keydown', (e) => {
            if (document.activeElement.id === 'pbox') return;
            e.preventDefault();
            fetch('/send_key', {method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify({key:e.key, shift:e.shiftKey, ctrl:e.ctrlKey, alt:e.altKey})});
        });
        pad.addEventListener('mousemove', (e) => {
            fetch('/send_mouse', {method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify({x:e.movementX, y:e.movementY})});
        });
        pad.addEventListener('mousedown', (e) => {
            let btn = (e.button === 0) ? 0x01 : (e.button === 2 ? 0x02 : 0);
            fetch('/send_mouse', {method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify({btn:btn, x:0, y:0})});
        });
        document.addEventListener('contextmenu', event => event.preventDefault());
    </script>
</body>
</html>
EOF

# 8. Generate Dockerfile
cat <<EOF > Dockerfile
FROM debian:13-slim
RUN apt-get update && apt-get install -y build-essential libevent-dev libjpeg-dev libbsd-dev python3 python3-pip python3-serial git python3-flask
RUN git clone --