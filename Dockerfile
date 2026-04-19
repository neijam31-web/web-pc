FROM ubuntu:24.04

# Install build essentials and X11 dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    libncurses-dev \
    bison \
    flex \
    libelf-dev \
    libssl-dev \
    bc \
    xfsprogs \
    dosfstools \
    libgmp3-dev \
    libmpc-dev \
    autoconf \
    automake \
    libtool \
    pkg-config \
    x11-common \
    x11-utils \
    libx11-dev \
    libgl1-mesa-dev \
    x11-apps \
    xterm \
    fluxbox \
    && rm -rf /var/lib/apt/lists/*

# Copy project files
WORKDIR /app
COPY . .

# Build the desktop environment
WORKDIR /app/desktop
RUN make build

# Set entry point to run the window manager
ENTRYPOINT ["make", "run"]
