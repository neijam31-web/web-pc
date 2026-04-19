#!/bin/bash
# This script generates package metadata for the distribution

METADATA_DIR="${1:-.}/metadata"
REPO_DIR="${1:-.}/repo"

mkdir -p "$METADATA_DIR"

cat > "$METADATA_DIR/packages.json" << 'EOF'
{
  "available": [
    {
      "name": "base-files",
      "version": "1.0",
      "depends": [],
      "provides": [],
      "installed": false
    },
    {
      "name": "base-passwd",
      "version": "1.0",
      "depends": ["base-files"],
      "provides": [],
      "installed": false
    },
    {
      "name": "bash",
      "version": "5.2",
      "depends": ["base-files"],
      "provides": ["sh"],
      "installed": false
    },
    {
      "name": "coreutils",
      "version": "9.1",
      "depends": [],
      "provides": [],
      "installed": false
    },
    {
      "name": "util-linux",
      "version": "2.39",
      "depends": [],
      "provides": [],
      "installed": false
    },
    {
      "name": "grep",
      "version": "3.11",
      "depends": [],
      "provides": [],
      "installed": false
    },
    {
      "name": "gzip",
      "version": "1.13",
      "depends": [],
      "provides": [],
      "installed": false
    },
    {
      "name": "curl",
      "version": "7.88",
      "depends": ["libc6"],
      "provides": [],
      "installed": false
    },
    {
      "name": "libc6",
      "version": "2.37",
      "depends": [],
      "provides": [],
      "installed": false
    }
  ],
  "installed": []
}
EOF

echo "Package metadata generated: $METADATA_DIR/packages.json"
