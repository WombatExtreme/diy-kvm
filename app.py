from flask import Flask, render_template, request, jsonify
import serial, time, os
from mappings import HID_MAP, MOD_MAP

app = Flask(__name__)
SER_PORT = os.getenv('SERIAL_PORT', '/dev/ttyUSB0')

def send_packet(packet):
    try:
        with serial.Serial(SER_PORT, 9600, timeout=0.1) as ser:
            packet.append(sum(packet) % 256)
            ser.write(bytearray(packet))
            time.sleep(0.01)
            # Send Release
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
    # CH9329 Mouse Packet: 0x05 command
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