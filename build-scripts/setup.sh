#!/bin/bash
# Setup script for Debian-styled Linux kernel and distribution project

set -e

PROJECT_NAME="Debian-Custom Linux"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=========================================="
echo "$PROJECT_NAME Project Setup"
echo "=========================================="
echo ""

# Check system requirements
check_requirements() {
    echo "Checking system requirements..."
    
    local missing=()
    
    for cmd in gcc make git wget python3; do
        if ! command -v "$cmd" &> /dev/null; then
            missing+=("$cmd")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo "Missing required tools: ${missing[*]}"
        echo "Install with: sudo apt-get install -y ${missing[*]}"
        exit 1
    fi
    
    echo "✓ All required tools found"
}

# Initialize directories
init_directories() {
    echo ""
    echo "Initializing directory structure..."
    
    mkdir -p "$PROJECT_ROOT"/{kernel,distro,desktop,modules,build-scripts,docs}
    mkdir -p "$PROJECT_ROOT"/build/{kernel,distro,desktop,modules}
    mkdir -p "$PROJECT_ROOT"/output/{kernel,distro,desktop,modules}
    
    echo "✓ Directories initialized"
}

# Set up scripts
setup_scripts() {
    echo ""
    echo "Setting up build scripts..."
    
    chmod +x "$PROJECT_ROOT"/build-scripts/*.sh
    chmod +x "$PROJECT_ROOT"/distro/package-manager.py
    
    echo "✓ Scripts ready"
}

# Initialize Git
init_git() {
    echo ""
    echo "Setting up Git repository..."
    
    cd "$PROJECT_ROOT"
    if [ ! -d .git ]; then
        git init
        git config user.email "dev@debiancustom.local" 2>/dev/null || true
        git config user.name "Debian Custom Developer" 2>/dev/null || true
    fi
    
    echo "✓ Git repository ready"
}

# Create environment file
create_env() {
    echo ""
    echo "Creating environment configuration..."
    
    cat > "$PROJECT_ROOT/.env" << 'EOF'
# Debian-Custom Linux Project Environment

# Project paths
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$PROJECT_ROOT/build"
OUTPUT_DIR="$PROJECT_ROOT/output"

# Build configuration
KERNEL_VERSION="6.8.5"
DISTRO_VERSION="1.0"
JOBS=$(nproc)
ARCH="x86_64"

# Installation paths
INSTALL_PREFIX="/opt/custom-linux"
KERNEL_INSTALL_PATH="/boot"

# Build flags
CFLAGS="-Wall -Wextra -O2 -march=native"
LDFLAGS="-ldl -lpthread"

export PROJECT_ROOT BUILD_DIR OUTPUT_DIR KERNEL_VERSION DISTRO_VERSION
export JOBS ARCH INSTALL_PREFIX KERNEL_INSTALL_PATH CFLAGS LDFLAGS
EOF
    
    echo "✓ Environment file created"
}

# Main setup flow
echo "Starting setup process..."
echo ""

check_requirements
init_directories
setup_scripts
init_git
create_env

echo ""
echo "=========================================="
echo "✓ Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. cd $PROJECT_ROOT"
echo "  2. source .env"
echo "  3. cd kernel && make build"
echo "  4. cd ../distro && make build"
echo "  5. cd ../desktop && make build"
echo ""
echo "For more information, see:"
echo "  - README.md (project overview)"
echo "  - docs/ (detailed documentation)"
echo ""
