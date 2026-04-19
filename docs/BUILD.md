# Build System Documentation

Comprehensive guide for the Debian-Custom Linux build system.

## Overview

The project uses a hierarchical Makefile system:

```
Makefile (root)              # Orchestration
├── kernel/Makefile          # Kernel build
├── distro/Makefile          # Distribution build
├── desktop/Makefile         # Desktop build
├── modules/Makefile         # Module build
└── build-scripts/           # Build utilities
```

## Build Process

### 1. Initial Setup

```bash
make setup
```

This creates:
- Directory structure
- Environment configuration (`.env`)
- Git repository initialization
- Build system scripts

### 2. Build Components

Each component can be built independently:

```bash
# Kernel only
make kernel

# Distribution only
make distro

# Desktop only
make desktop

# Modules only
make modules

# All components
make build
```

## Environment Configuration

File: `.env` (created during setup)

```bash
# Paths
PROJECT_ROOT=/workspaces/web-pc
BUILD_DIR=$PROJECT_ROOT/build
OUTPUT_DIR=$PROJECT_ROOT/output

# Versions
KERNEL_VERSION=6.8.5
DISTRO_VERSION=1.0

# Build options
JOBS=8                    # Parallel build jobs
ARCH=x86_64              # Target architecture
CFLAGS=-O2 -march=native
```

Load environment:
```bash
source .env
```

## Directory Structure After Build

```
project/
├── build/               # Build intermediates
│   ├── kernel/
│   ├── distro/
│   ├── desktop/
│   └── modules/
├── output/              # Final artifacts
│   ├── kernel/
│   │   ├── vmlinuz-6.8.5
│   │   ├── System.map-6.8.5
│   │   └── config-6.8.5
│   ├── distro/
│   ├── desktop/
│   │   └── bin/window-manager
│   └── modules/
│       └── *.ko
└── rootfs/              # Root filesystem
    ├── bin/
    ├── etc/
    ├── lib/
    └── ...
```

## Cross-Compilation

### Compile for different architecture

#### ARM 32-bit
```bash
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
make kernel
```

#### ARM 64-bit
```bash
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
make kernel
```

#### PowerPC
```bash
export ARCH=powerpc
export CROSS_COMPILE=powerpc-linux-gnu-
make kernel
```

## Build Performance

### Parallel compilation

The system automatically detects CPU count:

```bash
# Override with JOBS variable
make build JOBS=16
```

### Build time estimates

- **Kernel**: 5-15 minutes (depends on CPU)
- **Distro**: 2-5 minutes
- **Desktop**: < 1 minute
- **Modules**: < 1 minute

Total: ~15-20 minutes first build, ~1-5 minutes subsequent builds

### Speed optimization

```bash
# Use RAM disk for faster builds
sudo mount -t tmpfs -o size=4G tmpfs ./build

# Use ccache for compiler caching
export CC="ccache gcc"
export CXX="ccache g++"
```

## Incremental Builds

The build system supports incremental compilation:

```bash
# Only rebuilds changed files
make kernel

# Force rebuild everything
make -B kernel

# Clean then rebuild
make clean && make kernel
```

## Debugging Builds

### Verbose output

```bash
# Show all commands
make kernel V=1

# Show all variables
make kernel --debug=b
```

### Stop on first error

```bash
make kernel -S  # or --no-keep-going
```

### Debug specific component

```bash
cd kernel
make build V=1
```

View build logs:
```bash
make kernel 2>&1 | tee build.log
```

## Build Configuration

### Minimal configuration

For embedded systems:
```bash
make kernel minimal-config
```

### Full configuration

```bash
cd kernel
make menuconfig
```

### Save configuration

```bash
# Save current config as default
cp kernel/build/linux-6.8.5/.config kernel/minimal-config.txt
```

## Package Creation

### Create .deb packages

```bash
make distro build-packages
```

Creates Debian binary packages (.deb) for distribution.

### Create ISO image

```bash
make iso
```

Creates bootable ISO in `output/debian-custom.iso`.

## Troubleshooting

### Build fails: "cannot find headers"

```bash
# Install kernel headers
sudo apt-get install linux-headers-$(uname -r)
```

### Out of disk space

```bash
# Check disk usage
du -sh build/ output/

# Clean temporary files
make clean
```

### Compilation errors

```bash
# Check build log
tail -50 build.log

# Verify compiler
gcc --version
make --version
```

### Module load fails

```bash
# Check kernel version compatibility
uname -a
modinfo custom_module.ko

# Clear dmesg and try again
sudo dmesg -c
sudo insmod custom_module.ko
dmesg
```

## Testing Builds

### Check kernel build

```bash
file output/kernel/vmlinuz-*
# Should show: ELF 64-bit LSB executable
```

### Test module load

```bash
make modules install
lsmod | grep custom
dmesg | tail
```

### Test desktop WM

```bash
./output/desktop/bin/window-manager
# Should start window manager
```

### Test distribution

```bash
./distro/package-manager.py list
# Should show installed packages
```

## Build Parameters

### Make variables

| Variable | Purpose | Example |
|----------|---------|---------|
| JOBS | Parallel jobs | `make JOBS=16` |
| ARCH | Target arch | `make ARCH=arm64` |
| VERBOSE | Build verbosity | `make V=1` |
| INSTALL | Install to system | `make install` |

### Configuration overrides

```bash
# Override defaults
make kernel KERNEL_VERSION=6.9.0
make distro DISTRO_VERSION=2.0
make desktop CROSS_COMPILE=arm-linux-
```

## Continuous Integration

### Simple CI build

```bash
#!/bin/bash
set -e

make setup
make clean
make build
make test
make iso
```

### Parallel CI builds

```bash
make kernel &
make distro &
make modules &
wait

make desktop
```

## Build Caching

### Enable ccache

```bash
sudo apt-get install ccache
export PATH=/usr/lib/ccache:$PATH
```

### Clear cache

```bash
ccache -C
```

## Advanced Configuration

### Custom build flags

Edit `.env`:
```bash
CFLAGS="-O3 -march=native -mtune=native"
LDFLAGS="-flto"
```

### Custom kernel patches

```bash
# Place patches in kernel/patches/
ls kernel/patches/*.patch

# Apply automatically during build
cd kernel/build/linux-*/
for p in ../../patches/*.patch; do
  patch -p1 < "$p"
done
```

## Performance Analysis

### Build timing

```bash
time make build
```

### Profile build

```bash
make build 2>&1 | tee build.log
cat build.log | grep "^make\[" | sort -k3 -t: -n
```

## References

- GNU Make: https://www.gnu.org/software/make/manual/
- Kernel Build System: https://www.kernel.org/doc/html/latest/kbuild/
- Linux Build Best Practices: https://wiki.debian.org/BuildingADebianPackage
