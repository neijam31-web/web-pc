#!/usr/bin/env python3
"""
Simple Debian-like package manager for custom distribution.
Handles package installation, dependency resolution, and metadata.
"""

import json
import os
import sys
import subprocess
from pathlib import Path
from typing import Dict, List, Set

class Package:
    """Represents a Debian package."""
    
    def __init__(self, name: str, version: str, depends: List[str] = None, 
                 provides: List[str] = None):
        self.name = name
        self.version = version
        self.depends = depends or []
        self.provides = provides or []
        self.installed = False
    
    def to_dict(self):
        return {
            'name': self.name,
            'version': self.version,
            'depends': self.depends,
            'provides': self.provides,
            'installed': self.installed
        }

class PackageManager:
    """Manages package installation and dependencies."""
    
    def __init__(self, repo_path: str = "/var/cache/apt"):
        self.repo_path = Path(repo_path)
        self.installed_packages: Dict[str, Package] = {}
        self.available_packages: Dict[str, Package] = {}
        self.load_package_database()
    
    def load_package_database(self):
        """Load package metadata from repository."""
        db_file = self.repo_path / "packages.json"
        if db_file.exists():
            with open(db_file, 'r') as f:
                data = json.load(f)
                for pkg_data in data.get('available', []):
                    pkg = Package(**pkg_data)
                    self.available_packages[pkg.name] = pkg
                for pkg_data in data.get('installed', []):
                    pkg = Package(**pkg_data)
                    self.installed_packages[pkg.name] = pkg
    
    def resolve_dependencies(self, package_name: str, 
                           resolved: Set[str] = None) -> Set[str]:
        """Recursively resolve package dependencies."""
        if resolved is None:
            resolved = set()
        
        if package_name in resolved:
            return resolved
        
        if package_name not in self.available_packages:
            raise ValueError(f"Package '{package_name}' not found in repository")
        
        pkg = self.available_packages[package_name]
        resolved.add(package_name)
        
        for dep in pkg.depends:
            self.resolve_dependencies(dep, resolved)
        
        return resolved
    
    def install(self, package_name: str, force: bool = False):
        """Install a package and its dependencies."""
        if package_name in self.installed_packages and not force:
            print(f"Package '{package_name}' already installed")
            return
        
        # Resolve dependencies
        print(f"Resolving dependencies for {package_name}...")
        deps = self.resolve_dependencies(package_name)
        
        print(f"Will install: {', '.join(sorted(deps))}")
        
        # Install packages
        for dep in sorted(deps):
            if dep not in self.installed_packages:
                print(f"Installing {dep}...")
                pkg = self.available_packages[dep]
                pkg.installed = True
                self.installed_packages[dep] = pkg
        
        self.save_package_database()
    
    def remove(self, package_name: str):
        """Remove an installed package."""
        if package_name not in self.installed_packages:
            print(f"Package '{package_name}' not installed")
            return
        
        # Check for dependents
        dependents = self._find_dependents(package_name)
        if dependents:
            print(f"Packages depending on {package_name}: {', '.join(dependents)}")
            print("Cannot remove without --force")
            return
        
        print(f"Removing {package_name}...")
        del self.installed_packages[package_name]
        self.save_package_database()
    
    def _find_dependents(self, package_name: str) -> List[str]:
        """Find packages that depend on this package."""
        dependents = []
        for pkg in self.installed_packages.values():
            if package_name in pkg.depends:
                dependents.append(pkg.name)
        return dependents
    
    def upgrade(self):
        """Upgrade all installed packages."""
        print("Checking for upgrades...")
        for pkg_name in self.installed_packages:
            installed = self.installed_packages[pkg_name]
            available = self.available_packages.get(pkg_name)
            
            if available and available.version > installed.version:
                print(f"Upgrading {pkg_name}: {installed.version} -> {available.version}")
                installed.version = available.version
        
        self.save_package_database()
    
    def list_installed(self):
        """List installed packages."""
        return sorted(self.installed_packages.items())
    
    def search(self, query: str) -> List[str]:
        """Search for packages."""
        results = []
        for name in self.available_packages:
            if query.lower() in name.lower():
                results.append(name)
        return sorted(results)
    
    def save_package_database(self):
        """Save package database."""
        os.makedirs(self.repo_path, exist_ok=True)
        
        data = {
            'installed': [pkg.to_dict() for pkg in self.installed_packages.values()],
            'available': [pkg.to_dict() for pkg in self.available_packages.values()]
        }
        
        db_file = self.repo_path / "packages.json"
        with open(db_file, 'w') as f:
            json.dump(data, f, indent=2)

def main():
    """Command-line interface for package manager."""
    import argparse
    
    parser = argparse.ArgumentParser(description='Debian-styled Package Manager')
    subparsers = parser.add_subparsers(dest='command', help='Command')
    
    # Install command
    install_parser = subparsers.add_parser('install', help='Install package')
    install_parser.add_argument('package', help='Package name')
    install_parser.add_argument('--force', action='store_true', help='Force reinstall')
    
    # Remove command
    remove_parser = subparsers.add_parser('remove', help='Remove package')
    remove_parser.add_argument('package', help='Package name')
    
    # Upgrade command
    subparsers.add_parser('upgrade', help='Upgrade all packages')
    
    # List command
    subparsers.add_parser('list', help='List installed packages')
    
    # Search command
    search_parser = subparsers.add_parser('search', help='Search packages')
    search_parser.add_argument('query', help='Search query')
    
    args = parser.parse_args()
    
    pm = PackageManager()
    
    if args.command == 'install':
        pm.install(args.package, args.force)
    elif args.command == 'remove':
        pm.remove(args.package)
    elif args.command == 'upgrade':
        pm.upgrade()
    elif args.command == 'list':
        for name, pkg in pm.list_installed():
            print(f"{name} ({pkg.version})")
    elif args.command == 'search':
        results = pm.search(args.query)
        for result in results:
            print(result)

if __name__ == '__main__':
    main()
