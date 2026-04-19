.PHONY: build config clean menuconfig install download-kernel

KERNEL_VERSION=6.8.5
KERNEL_DIR=linux-$(KERNEL_VERSION)
ARCH=x86_64
JOBS=$(shell nproc)
BUILD_DIR=$(PWD)/build
OUTPUT_DIR=$(PWD)/output

# Download kernel source
download-kernel:
	@echo "Downloading Linux kernel $(KERNEL_VERSION)..."
	mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && \
	wget -q https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-$(KERNEL_VERSION).tar.xz && \
	tar -xf linux-$(KERNEL_VERSION).tar.xz && \
	echo "Kernel downloaded to $(BUILD_DIR)/$(KERNEL_DIR)"

# Configure kernel
config: download-kernel
	@echo "Configuring kernel..."
	cd $(BUILD_DIR)/$(KERNEL_DIR) && \
	cp /boot/config-$$(uname -r) .config || make defconfig && \
	echo "Kernel configured"

# Interactive menu configuration
menuconfig: download-kernel
	@echo "Opening kernel configuration menu..."
	cd $(BUILD_DIR)/$(KERNEL_DIR) && \
	make menuconfig

# Build kernel
build: download-kernel config
	@echo "Building Linux kernel $(KERNEL_VERSION) with $(JOBS) jobs..."
	cd $(BUILD_DIR)/$(KERNEL_DIR) && \
	make -j$(JOBS) && \
	echo "Kernel build complete!"

# Install kernel
install: build
	@echo "Installing kernel..."
	cd $(BUILD_DIR)/$(KERNEL_DIR) && \
	sudo make modules_install && \
	sudo make install && \
	echo "Kernel installed!"

# Create minimal config for embedded system
minimal-config: download-kernel
	@echo "Creating minimal kernel configuration..."
	cd $(BUILD_DIR)/$(KERNEL_DIR) && \
	make tinyconfig && \
	echo "Minimal config created"

# Clean build directory
clean:
	@echo "Cleaning kernel build..."
	rm -rf $(BUILD_DIR)
	rm -rf $(OUTPUT_DIR)
	echo "Cleaned!"

# Build and package
package: build
	@echo "Packaging kernel..."
	mkdir -p $(OUTPUT_DIR)
	cd $(BUILD_DIR)/$(KERNEL_DIR) && \
	cp arch/$(ARCH)/boot/bzImage $(OUTPUT_DIR)/vmlinuz-$(KERNEL_VERSION) && \
	cp System.map $(OUTPUT_DIR)/System.map-$(KERNEL_VERSION) && \
	cp .config $(OUTPUT_DIR)/config-$(KERNEL_VERSION) && \
	echo "Kernel packaged to $(OUTPUT_DIR)"

help:
	@echo "Debian-styled Linux Kernel Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  download-kernel   Download Linux kernel source"
	@echo "  config            Configure kernel with existing config"
	@echo "  menuconfig        Interactive kernel configuration"
	@echo "  build             Build the kernel"
	@echo "  install           Build and install kernel"
	@echo "  minimal-config    Create minimal embedded config"
	@echo "  package           Build and package kernel"
	@echo "  clean             Clean build directory"
	@echo "  help              Show this help message"
