# Quick Start Guide

Get started building a custom Debian-styled Linux kernel and distribution in 5 minutes.

## Prerequisites

```bash
# Debian/Ubuntu
sudo apt-get update
sudo apt-get install -y build-essential git libncurses-dev bison flex libelf-dev
sudo apt-get install -y libssl-dev bc x11-common x11-utils libx11-dev libgl1-mesa-dev
```

## Step 1: Initialize Project (1 minute)

```bash
cd /workspaces/web-pc
make setup
```

This creates directory structure and environment configuration.

## Step 2: Build Kernel (5-10 minutes)

```bash
cd kernel
make build
```

Downloads Linux 6.8.5, configures, and compiles the kernel.

**Output**: `output/vmlinuz-6.8.5`

## Step 3: Build Distribution (2 minutes)

```bash
cd ../distro
make build
```

Creates APT-compatible package repository and package database.

## Step 4: Build Desktop Environment (30 seconds)

```bash
cd ../desktop
make build
```

Compiles lightweight X11-based window manager.

**Output**: `bin/window-manager`

## Step 5: Build Kernel Modules (30 seconds)

```bash
cd ../modules
make build
```

Builds example kernel module.

**Output**: `*.ko` kernel module files

## Testing

### Test window manager

```bash
./desktop/bin/window-manager
# Press Alt+Return to open terminal (Xvfb only, or in X session)
# Press Alt+F4 to exit
```

### Test package manager

```bash
python3 distro/package-manager.py --help
python3 distro/package-manager.py search bash
```

### Test kernel module (if root)

```bash
sudo insmod modules/custom_module.ko
lsmod | grep custom_module
dmesg | tail
sudo rmmod custom_module
```

## Full Automation

Build everything in one command:

```bash
cd /workspaces/web-pc
make build
```

## Next Steps

- **Read docs**: Check `docs/` folder for detailed guides
- **Customize kernel**: `cd kernel && make menuconfig`
- **Add packages**: Edit `distro/package-manager.py`
- **Extend desktop**: Modify `desktop/src/window-manager.c`
- **Create modules**: Add new modules in `modules/`

## Common Commands

```bash
# Setup
make setup

# Build all
make build

# Build specific component
make kernel
make distro
make desktop
make modules

# Test
make test

# Clean
make clean

# Help
make help

# Create ISO
make iso
```

## File Organization

```
/workspaces/web-pc/
├── kernel/              Kernel sources and build
├── distro/              Distribution and packages
├── desktop/             Window manager and UI
├── modules/             Kernel modules
├── build/               Build artifacts
├── output/              Final binaries
├── docs/                Detailed documentation
└── README.md            Main documentation
```

## Quick Troubleshooting

### Build fails: "Need X11 development files"
```bash
sudo apt-get install libx11-dev libgl1-mesa-dev
```

### Build fails: "Cannot read kernel headers"
```bash
sudo apt-get install linux-headers-$(uname -r)
```

### Out of disk space
```bash
make clean  # Remove build artifacts but keep downloads
```

### Start over completely
```bash
make distclean  # Remove everything including downloads
make setup
```

## Time Estimates

| Component | Time |
|-----------|------|
| Setup | 1 min |
| Kernel build | 5-15 min |
| Distribution | 2-5 min |
| Desktop | <1 min |
| Modules | <1 min |
| Total | 15-25 min |

Subsequent builds are typically 5-10 minutes (only changed files recompile).

## Support

- **Kernel issues**: See [docs/KERNEL.md](docs/KERNEL.md)
- **Package issues**: See [docs/DISTRO.md](docs/DISTRO.md)
- **Desktop issues**: See [docs/DESKTOP.md](docs/DESKTOP.md)
- **Module issues**: See [docs/MODULES.md](docs/MODULES.md)
- **Build issues**: See [docs/BUILD.md](docs/BUILD.md)

## What You Just Built

✓ **Custom Linux Kernel** - Debian-styled bootable kernel
✓ **Debian Distribution** - APT-compatible package management
✓ **Desktop Environment** - X11 window manager with widget system
✓ **Kernel Modules** - Loadable system extensions
✓ **Complete Build System** - Automated compilation and packaging

Ready to install, test, or extend!
