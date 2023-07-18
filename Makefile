# Build the container image for the host platform, all platforms, and push
# the images to the registry.

IMAGE_NAME = gearlinux-pyserial-example
VERSION := $(shell git describe --always --tags --dirty)

all: host

# Build for the host platform
.PHONY: host
host: CMD = docker
host: BUILD_ARGS =
host: PLATFORMS =
host: build
	@true


.PHONY: multiarch-builder
multiarch-builder:
	-docker buildx create --name multiarch-builder --platform $(PLATFORMS) --bootstrap 2>/dev/null
	docker buildx use multiarch-builder

# Build for all platforms and push to the registry defined by IMAGE_NAME
.PHONY: push
push: BUILD_ARGS = --push
push: multiarch
	@true

# Build for the all platforms
.PHONY: multiarch
multiarch: CMD = docker buildx
multiarch: PLATFORMS = linux/amd64,linux/arm64,linux/arm/v7
multiarch: multiarch-builder build
	@true

.PHONY: build
build:
	$(CMD) build $(if $(PLATFORMS),--platform $(PLATFORMS)) \
		--tag="$(IMAGE_NAME):$(VERSION)" \
		--tag="$(IMAGE_NAME):latest" \
		$(BUILD_ARGS) .

# Run the container on the host. Set the TTY environment variable to the serial
# port on the host to test with, e.g. TTY=/dev/ttyUSB0
.PHONY: run
run: host
	docker run -it --rm --device=$(TTY):/dev/tty0:rw $(IMAGE_NAME):$(VERSION) $(ARGS)
