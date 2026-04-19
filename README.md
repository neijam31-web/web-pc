# Debian-Styled Linux Kernel & Distribution Project

A comprehensive project for building a custom Linux kernel, distribution, desktop environment, and kernel modules, styled after Debian.

## Project Structure

```
.
├── kernel/              # Linux kernel build & configuration
├── distro/              # Distribution package management
├── desktop/             # Desktop environment & window manager
├── modules/             # Loadable kernel modules
├── build-scripts/       # Build automation and orchestration
├── docs/                # Documentation
└── README.md            # This file
```

## Components

### 1. Custom Linux Kernel (`kernel/`)
- Minimal kernel configuration
- Build system and scripts
- Debian-compatible packaging
- Device drivers support

### 2. Debian-based Distribution (`distro/`)
- Package manager (APT-like)
- Package metadata
- Repository structure
- Dependency resolution

### 3. Desktop Environment (`desktop/`)
- Lightweight window manager
- Widget system
- Input handling
- Rendering engine

### 4. Kernel Modules (`modules/`)
- Example kernel modules
- Module installation system
- Device drivers template

## Quick Start

### Prerequisites
```bash
sudo apt-get update
sudo apt-get install -y build-essential git libncurses-dev bison flex libelf-dev
sudo apt-get install -y libssl-dev bc xfsprogs dosfstools libgmp3-dev libmpc-dev
sudo apt-get install -y autoconf automake libtool pkg-config x11-common x11-utils
```

### Building Everything

```bash
# Set up environment
bash build-scripts/setup.sh

# Build kernel
cd kernel && make build

# Build distribution
cd ../distro && make build

# Build desktop environment
cd ../desktop && make build

# Build kernel modules
cd ../modules && make build
```

## Development Workflow

1. **Kernel Development**: Edit in `kernel/src/`, rebuild with `make build`
2. **Distribution Packages**: Add packages in `distro/packages/`
3. **Desktop Work**: Modify window manager in `desktop/src/`
4. **Kernel Modules**: Create new modules in `modules/custom/`

## Documentation

See `docs/` directory for:
- [KERNEL.md](docs/KERNEL.md) - Kernel building guide
- [DISTRO.md](docs/DISTRO.md) - Distribution creation
- [DESKTOP.md](docs/DESKTOP.md) - Desktop environment guide
- [MODULES.md](docs/MODULES.md) - Kernel module development

## Architecture

- **Kernel**: Linux 6.x base
- **Distro**: APT package management
- **Desktop**: X11-based lightweight window manager
- **Init System**: systemd compatible

## Progress Tracking

- [ ] Kernel base setup and configuration
- [ ] Minimal buildable kernel
- [ ] Distribution package system
- [ ] Basic desktop environment
- [ ] Kernel module framework
- [ ] Integration testing
- [ ] ISO creation and deployment

## License

Educational project

## Support

For issues and questions, check the documentation files.