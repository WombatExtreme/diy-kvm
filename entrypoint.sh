#!/bin/bash
# Start uStreamer (The Eyes) - Using 720p 15fps for D520 stability
ustreamer --device=/dev/video0 --host=0.0.0.0 --port=8000 --resolution=1280x720 --desired-fps=15 &

# Start the Flask Web UI (The Brain)
python3 app.py