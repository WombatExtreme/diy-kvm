FROM debian:13-slim
RUN apt-get update && apt-get install -y \
    build-essential \
    libevent-dev \
    libjpeg-dev \
    libbsd-dev \
    python3 \
    python3-pip \
    python3-serial \
    python3-psutil \
    python3-flask \
    python3-requests \
    git \
    beep \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 https://github.com/pikvm/ustreamer /tmp/ustreamer && \
    cd /tmp/ustreamer && make && cp ustreamer /usr/local/bin/ && rm -rf /tmp/ustreamer

WORKDIR /app
COPY . .
CMD ustreamer --device=/dev/video0 --host=0.0.0.0 --port=8080 --format=mjpeg --resolution=1280x720 & python3 app.py