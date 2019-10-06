.PHONY: all validate release

all: build/pi64-lite.zip build/pi64-desktop.zip

build/pi64-lite.zip: build/pi64-lite.img
	zip -9 -j build/pi64-lite.zip build/pi64-lite.img

build/pi64-desktop.zip: build/pi64-desktop.img
	zip -9 -j build/pi64-desktop.zip build/pi64-desktop.img

build/pi64-lite.img: build/linux build/userland build/firmware
	apt update || sudo apt update || true
	pi64-build -build-dir ./build -version lite

build/pi64-desktop.img: build/linux build/userland build/firmware
	apt update || sudo apt update || true
	pi64-build -build-dir ./build -version desktop

build/linux.tar.gz.sig: build/linux.tar.gz
	cd build && gpg2 --output linux.tar.gz.sig --detach-sign linux.tar.gz

build/linux.tar.gz: build/linux
	cd build/linux && tar -zcvf ../linux.tar.gz .

build/linux: build/linux-src build/firmware build/userland
	bash make/linux
	touch build/linux # otherwise make will rebuild that target everytime (as build/linux-src gets altered by make/linux)

build/linux-src:
	bash make/linux-src

build/userland:
	bash make/videocore

build/firmware:
	bash make/firmware

validate:
	bash make/validate

release:
	bash make/release

release/kernel: build/linux.tar.gz
	bash make/release-kernel

test:
	apt update || sudo apt update || true
	bash make/test

check/kernel:
	curl https://raw.githubusercontent.com/docker/docker/master/contrib/check-config.sh \
		| CONFIG=build/linux-src/.config bash || true

kernelversion := 5.3.3
release := 2019-10-05.1570283848

get/linux:
	mkdir -p build/linux
	echo "skip_build_kernel=1" | tee .env
	curl -fsSL https://github.com/khs1994/pi64/releases/download/$(release)-kernel-$(kernelversion)/linux-$(kernelversion).tar.gz \
		| tar -zxvf - -C build/linux
	GOOS=linux GOARCH=arm64 go build -o ./build/linux/usr/bin/pi64-update github.com/bamarni/pi64/cmd/pi64-update
	GOOS=linux GOARCH=arm64 go build -o ./build/linux/usr/bin/pi64-config github.com/bamarni/pi64/cmd/pi64-config
