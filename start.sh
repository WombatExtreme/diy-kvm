#!binbash
# Start uStreamer in the background
# We use --host=0.0.0.0 so it's accessible outside the container
ustreamer --device=devvideo0 --host=0.0.0.0 --port=8000 --resolution=1280x720 --desired-fps=15 &

# Start the Flask Web UI (The Brain)
python3 app.py