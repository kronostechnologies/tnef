SHELL = /bin/sh
TARGET = tnef
CHECKOUT = 1.4.18
DIST = buster
.PHONY: clean all

all: clean $(TARGET)

$(TARGET):
	@docker buildx build --build-arg CHECKOUT="$(CHECKOUT)" --build-arg DIST="$(DIST)" --platform=linux/arm64,linux/amd64 -o "dist/" .

clean:
	@rm -rf dist/