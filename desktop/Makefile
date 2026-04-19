.PHONY: build clean run test help

CC=gcc
CFLAGS=-Wall -Wextra -O2 -fPIC
LDFLAGS=-lX11 -lGL -lm
SRC_DIR=src
BUILD_DIR=build
BIN_DIR=bin

SOURCES=$(wildcard $(SRC_DIR)/*.c)
OBJECTS=$(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(SOURCES))

all: build

build: $(BIN_DIR)/window-manager
	@echo "Desktop environment built successfully!"

$(BIN_DIR)/window-manager: $(OBJECTS)
	@mkdir -p $(BIN_DIR)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
	@echo "Window manager compiled: $@"

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	@echo "Cleaning desktop build..."
	rm -rf $(BUILD_DIR) $(BIN_DIR)
	echo "Cleaned!"

run: build
	@echo "Starting window manager..."
	./$(BIN_DIR)/window-manager

test:
	@echo "Running tests..."
	./test/run_tests.sh

help:
	@echo "Desktop Environment Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  build    Compile window manager"
	@echo "  clean    Clean build files"
	@echo "  run      Run window manager"
	@echo "  test     Run tests"
	@echo "  help     Show this message"
