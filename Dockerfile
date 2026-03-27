FROM debian:13-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-serial \
    ustreamer v4l-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

# Install Flask
RUN pip3 install --no-cache-dir flask --break-system-packages

# Set permissions for hardware access
RUN usermod -aG video,dialout root

# Launch the dual-engine script
RUN chmod +x entrypoint.sh
CMD ["./entrypoint.sh"]