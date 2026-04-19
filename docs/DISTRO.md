# Distribution Creation Guide

Building a Debian-styled Linux distribution.

## Overview

A distribution consists of:
- Kernel (from kernel/ directory)
- Package management system
- Core utilities and libraries
- Package repositories
- Installation tools

## Architecture

```
Distribution Structure:
├── Repository (APT-compatible)
│   ├── pool/          # Binary packages
│   ├── dists/         # Distribution releases
│   └── metadata/      # Package metadata
├── Base System
│   ├── Essential packages
│   ├── Libraries
│   └── Utilities
└── Package Manager
    └── Dependency resolution
```

## Building from Scratch

### 1. Create repository structure

```bash
cd distro
make create-repo
```

Creates:
- `repo/pool/main/` - Package repository
- `repo/dists/stable/` - Distribution releases
- `repo/metadata/` - Package metadata

### 2. Install base packages

Packages typically included:
- base-files - Root filesystem
- base-passwd - User/group databases
- bash - Shell
- coreutils - Core utilities
- util-linux - System utilities
- findutils - File utilities
- grep - Text search
- gzip - Compression
- sed - Stream editor
- tar - Archiver

### 3. Generate package list

```bash
make package-list
```

Creates package metadata in JSON format.

### 4. Build packages

```bash
make build-packages
```

Compiles all packages from source.

## Package Manager

### Basic Commands

```bash
# Install package
./distro/package-manager.py install bash

# Remove package
./distro/package-manager.py remove nano

# List installed
./distro/package-manager.py list

# Search packages
./distro/package-manager.py search util

# Upgrade all
./distro/package-manager.py upgrade
```

### Dependency Resolution

Packages can specify dependencies:

```python
Package("curl", "7.88", depends=["libc6", "libcrypto"])
```

The package manager automatically installs dependencies.

## Creating .deb Packages

### Package structure

```
package-name/
├── debian/
│   ├── control       # Package metadata
│   ├── postinst      # Post-install script
│   ├── postrm        # Post-remove script
│   └── conffiles     # Configuration files
├── src/
│   └── *.c           # Source code
└── Makefile
```

### debian/control format

```
Package: curl
Version: 7.88-1
Architecture: amd64
Maintainer: Debian Custom <dev@debiancustom.org>
Depends: libc6 (>= 2.30), libcrypto3
Description: Command line tool for URLs
 curl is a tool for transferring data using URLs
```

### Build package

```bash
dpkg-buildpackage -b
```

## APT Repository Setup

### Create package index

```bash
make create-index
```

Generates Packages, Packages.gz files.

### Add custom repository

On target system:
```bash
echo "deb [file:///path/to/distro/repo] stable main" | sudo tee /etc/apt/sources.list.d/custom.list
sudo apt-get update
```

## Filesystem Hierarchy

Follow Debian/FHS standards:

```
/
├── bin/              # Essential executables
├── boot/             # Kernel and bootloader
├── dev/              # Device files
├── etc/              # Configuration
├── home/             # User home directories
├── lib/              # System libraries
├── media/            # Removable media mount
├── mnt/              # Temporary mounts
├── opt/              # Optional packages
├── proc/             # Process information
├── root/             # Root home
├── run/              # Runtime data
├── sbin/             # System binaries
├── srv/              # Service data
├── sys/              # System information
├── tmp/              # Temporary files
├── usr/              # User programs/data
└── var/              # Variable data
```

## Building a Custom Image

### Create filesystem

```bash
# Create minimal filesystem
mkdir -p rootfs/{bin,etc,lib,usr,var,sys,proc,dev}

# Install core packages
./distro/package-manager.py install base-files base-passwd bash coreutils
```

### Create ISO

```bash
# Create initramfs
mkinitramfs -o build/initrd.img

# Create ISO
mkisofs -o output/distro.iso \
  -b boot/grub/stage2_eltorito \
  -no-emul-boot -boot-load-size 4 -boot-info-table \
  -R -J rootfs/
```

## Configuration Files

### /etc/os-release

```bash
NAME="Debian Custom"
VERSION="1.0"
ID=debian-custom
ID_LIKE=debian
HOME_URL="https://example.com"
DOCUMENTATION_URL="https://docs.example.com"
```

### /etc/lsb-release-codename

```
CODENAME=stable
DISTRIB_ID=DebianCustom
DISTRIB_RELEASE=1.0
```

## Package Signing

### Create GPG key

```bash
gpg --gen-key
```

### Sign packages

```bash
dpkg-sig -k <key-id> -s builder package.deb
```

### Verify signatures

```bash
dpkg-sig --verify package.deb
```

## Testing Distribution

### Install in VM

```bash
qemu-system-x86_64 -cdrom output/distro.iso -m 2G
```

### Boot from USB

```bash
sudo dd if=output/distro.iso of=/dev/sdX
```

## Troubleshooting

### Dependency conflicts

```bash
apt-cache depends package-name
apt-cache rdepends package-name
```

### Missing libraries

Check library dependencies:
```bash
ldd /usr/bin/program
```

## References

- Debian Packaging Guide: https://www.debian.org/doc/manuals/debmake-doc/
- APT Documentation: https://wiki.debian.org/Apt
- Filesystem Hierarchy Standard: https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.pdf
