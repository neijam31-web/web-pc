# Linux Kernel Build Guide

This guide covers building a custom Debian-styled Linux kernel.

## Overview

The kernel build process involves:
1. Downloading kernel source
2. Configuration
3. Compilation
4. Installation
5. Packaging

## Prerequisites

```bash
sudo apt-get install -y build-essential git libncurses-dev bison flex libelf-dev
sudo apt-get install -y libssl-dev bc xfsprogs dosfstools
```

## Quick Start

```bash
cd kernel
make build
```

## Detailed Steps

### 1. Download Kernel Source

```bash
make download-kernel
```

This downloads Linux 6.8.5 kernel source to `build/linux-6.8.5/`.

### 2. Configure Kernel

#### Option A: Use existing system config
```bash
make config
```

#### Option B: Interactive menu
```bash
make menuconfig
```

#### Option C: Minimal embedded config
```bash
make minimal-config
```

### 3. Build Kernel

```bash
make build
```

Uses parallel compilation with `$(nproc)` jobs for faster builds.

### 4. Install Kernel

```bash
make install
```

Installs kernel modules and kernel image to boot directory.

### 5. Package Kernel

```bash
make package
```

Creates `output/` directory with:
- `vmlinuz-6.8.5` - Kernel image
- `System.map-6.8.5` - Kernel symbols
- `config-6.8.5` - Build configuration

## Custom Configuration

### Create minimal kernel for embedded systems

```bash
make minimal-config
# Edit minimal-config.txt as needed
make menuconfig
```

### Key kernel config options

```
CONFIG_X86_64=y              # 64-bit x86 support
CONFIG_SMP=y                 # Multiprocessor support
CONFIG_EXT4_FS=y             # Ext4 filesystem
CONFIG_MODULES=y             # Loadable module support
CONFIG_NET=y                 # Networking
```

## Building for Different Architectures

### ARM 32-bit
```bash
ARCH=arm make menuconfig
ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make build
```

### ARM 64-bit (ARM64)
```bash
ARCH=arm64 make menuconfig
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make build
```

## Kernel Modules

With `CONFIG_MODULES=y`, you can build loadable modules:

```bash
cd ../modules
make build
```

## Troubleshooting

### Build fails: "missing libssl-dev"
```bash
sudo apt-get install libssl-dev
```

### Cannot find kernel headers
```bash
cd build/linux-6.8.5
make headers_install INSTALL_HDR_PATH=/usr/local
```

### Build too slow
Increase parallel jobs:
```bash
# Using 16 jobs
make build JOBS=16
```

## Advanced Topics

### Custom kernel patches

Place patches in `kernel/patches/`:
```bash
cd build/linux-6.8.5
for patch in ../../patches/*.patch; do
    patch -p1 < "$patch"
done
```

### Generating kernel documentation

```bash
cd build/linux-6.8.5
make htmldocs
```

### Performance optimization

Edit `minimal-config.txt` for targeted optimization:
```
CONFIG_OPTIMIZATION=y
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
```

## Post-Installation

### Update boot configuration (GRUB)

```bash
sudo update-grub
```

### Verify installation

```bash
uname -a
# Should show custom kernel version
```

## Clean Build

Remove all build artifacts:

```bash
make clean
```

## References

- Linux Kernel Official: https://www.kernel.org
- Debian Kernel Build: https://wiki.debian.org/BuildAKernel
- Kernel Config: https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
