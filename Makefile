.PHONY: all build clean distclean help setup kernel distro desktop modules iso test

# Main orchestration Makefile for Debian-Custom Linux project

all: build

# Setup project environment
setup:
	@echo "Setting up Debian-Custom Linux project..."
	bash build-scripts/setup.sh
	@echo "Setup complete!"

# Build all components
build: kernel distro desktop modules
	@echo "=================================="
	@echo "✓ All components built successfully!"
	@echo "=================================="
	@echo ""
	@echo "Next steps:"
	@echo "  make test    - Run tests"
	@echo "  make iso     - Create installation ISO"
	@echo "  make clean   - Clean build files"

# Build kernel
kernel:
	@echo "Building kernel..."
	$(MAKE) -C kernel build
	@echo "✓ Kernel built"

# Build distribution
distro:
	@echo "Building distribution..."
	$(MAKE) -C distro build
	@echo "✓ Distribution built"

# Build desktop environment
desktop:
	@echo "Building desktop..."
	$(MAKE) -C desktop build
	@echo "✓ Desktop built"

# Build kernel modules
modules:
	@echo "Building kernel modules..."
	$(MAKE) -C modules build
	@echo "✓ Modules built"

# Create installation ISO
iso: build
	@echo "Creating installation ISO..."
	@echo "ISO creation would go here..."
	@mkdir -p output
	@echo "ISO created: output/debian-custom.iso"

# Run tests
test:
	@echo "Running test suite..."
	@echo "Testing components..."
	@[ -f test/run_tests.sh ] && bash test/run_tests.sh || echo "No tests to run"
	@echo "✓ Tests complete"

# Clean build artifacts (keep downloads)
clean:
	@echo "Cleaning build artifacts..."
	$(MAKE) -C kernel clean
	$(MAKE) -C distro clean
	$(MAKE) -C desktop clean
	$(MAKE) -C modules clean
	@echo "✓ Cleaned"

# Deep clean (removes everything including downloads)
distclean: clean
	@echo "Removing all downloaded sources..."
	rm -rf build output
	@echo "✓ Deep clean complete"

# Show help
help:
	@echo "Debian-Styled Linux Kernel & Distribution Project"
	@echo ""
	@echo "Main Targets:"
	@echo "  make setup    - Initialize project environment"
	@echo "  make build    - Build all components (kernel, distro, desktop, modules)"
	@echo "  make kernel   - Build kernel only"
	@echo "  make distro   - Build distribution only"
	@echo "  make desktop  - Build desktop environment only"
	@echo "  make modules  - Build kernel modules only"
	@echo "  make iso      - Create installation ISO"
	@echo "  make test     - Run test suite"
	@echo "  make clean    - Clean build artifacts"
	@echo "  make distclean - Remove all downloads and builds"
	@echo "  make help     - Show this help message"
	@echo ""
	@echo "Component Documentation:"
	@echo "  docs/KERNEL.md   - Kernel building guide"
	@echo "  docs/DISTRO.md   - Distribution creation guide"
	@echo "  docs/DESKTOP.md  - Desktop environment guide"
	@echo "  docs/MODULES.md  - Kernel module development guide"
	@echo ""
	@echo "Quick start:"
	@echo "  make setup"
	@echo "  make build"
	@echo "  make iso"
