.PHONY: build clean install modules help

KERNEL_SRC=/lib/modules/$(shell uname -r)/build
PWD=$(shell pwd)
MODULE_NAME=custom_module
OBJ_M=$(PWD)/src/$(MODULE_NAME).o

build:
	@echo "Building kernel modules..."
	make -C $(KERNEL_SRC) M=$(PWD) modules
	@echo "Modules built successfully!"

clean:
	@echo "Cleaning kernel module build..."
	make -C $(KERNEL_SRC) M=$(PWD) clean
	rm -f *.ko *.mod.c *.mod.o

install: build
	@echo "Installing modules..."
	sudo insmod src/$(MODULE_NAME).ko

remove:
	@echo "Removing modules..."
	sudo rmmod $(MODULE_NAME)

help:
	@echo "Kernel Modules Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  build      Build kernel modules"
	@echo "  clean      Clean build"
	@echo "  install    Build and insmod"
	@echo "  remove     Remove installed module"
	@echo "  help       Show this message"
