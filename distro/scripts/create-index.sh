#!/bin/bash
# Create APT-compatible package index

REPO_DIR="${1:-.}/repo"
DISTS_DIR="$REPO_DIR/dists/stable/main"
BINARY_DIR="$DISTS_DIR/binary-amd64"

mkdir -p "$BINARY_DIR"

# Create Packages file
echo "Creating package index..."

cat > "$BINARY_DIR/Packages" << 'EOF'
Package: base-files
Version: 1.0
Installed-Size: 64
Maintainer: Debian Custom <dev@debiancustom.org>
Architecture: amd64
Description: Debian base system files

Package: bash
Version: 5.2
Installed-Size: 1500
Maintainer: Debian Custom <dev@debiancustom.org>
Depends: base-files
Architecture: amd64
Description: GNU Bourne Again SHell
 Bash is a shell and command language
EOF

# Compress
gzip -9 < "$BINARY_DIR/Packages" > "$BINARY_DIR/Packages.gz"

echo "✓ Package index created"
