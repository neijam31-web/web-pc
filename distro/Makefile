.PHONY: build install-base create-repo package-list help

DISTRO_NAME=DebianCustom
DISTRO_VERSION=1.0
ARCH=amd64
REPO_DIR=$(PWD)/repo
PKG_DIR=$(PWD)/packages
METADATA_DIR=$(REPO_DIR)/metadata

build: create-repo install-base package-list
	@echo "Distribution $(DISTRO_NAME) $(DISTRO_VERSION) built successfully!"

# Create repository structure
create-repo:
	@echo "Creating repository structure..."
	mkdir -p $(REPO_DIR)/{pool,dists,metadata}
	mkdir -p $(REPO_DIR)/pool/main
	mkdir -p $(REPO_DIR)/dists/stable/{main,contrib,non-free}
	mkdir -p $(METADATA_DIR)
	@echo "Repository structure created"

# List of base system packages
install-base: create-repo
	@echo "Installing base system packages..."
	@echo "Base packages would include:"
	@echo "  - base-files"
	@echo "  - base-passwd"
	@echo "  - bash"
	@echo "  - coreutils"
	@echo "  - util-linux"
	@echo "  - findutils"
	@echo "  - grep"
	@echo "  - gzip"
	@echo "  - sed"
	@echo "  - tar"

# Create package metadata
package-list:
	@echo "Creating package metadata..."
	./scripts/generate-metadata.sh

# Build .deb files for packages
build-packages:
	@echo "Building Debian packages..."
	cd $(PKG_DIR) && for pkg in */; do \
		echo "Building package: $$pkg"; \
		cd "$$pkg" && make build && cd ..; \
	done

# Create APT index
create-index:
	@echo "Creating APT package index..."
	mkdir -p $(REPO_DIR)/dists/stable/main/binary-$(ARCH)
	./scripts/create-index.sh

# Clean
clean:
	@echo "Cleaning distribution..."
	rm -rf $(REPO_DIR)
	echo "Cleaned!"

help:
	@echo "Debian-styled Distribution Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  build              Full distribution build"
	@echo "  create-repo        Create repository structure"
	@echo "  install-base       List base packages"
	@echo "  package-list       Generate package metadata"
	@echo "  build-packages     Build all .deb packages"
	@echo "  create-index       Create APT package index"
	@echo "  clean              Clean build"
	@echo "  help               Show this help"
