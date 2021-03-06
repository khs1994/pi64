# pi64

pi64 is an experimental 64-bit OS for the Raspberry Pi 3. It is based on Debian Buster(10) and backed by a 5.8 Linux kernel.

## Compare upstream

* https://github.com/bamarni/pi64/compare/master...khs1994:buster

## 提示

### [iptables is being replaced by nftables starting with Debian Buster](https://wiki.debian.org/iptables)

由于 Docker 不支持 nftables,切换到原始 iptables 命令

```bash
# update-alternatives --set iptables /usr/sbin/iptables-legacy
# update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
# update-alternatives --set arptables /usr/sbin/arptables-legacy
# update-alternatives --set ebtables /usr/sbin/ebtables-legacy
```

* https://github.com/moby/moby/issues/38099
* https://github.com/moby/moby/issues/26824
* https://github.com/docker/libnetwork/pull/2285
* https://github.com/docker/libnetwork/pull/2343
* https://github.com/moby/moby/issues/39590

### Docker 所需内核参数

* https://github.com/moby/moby/pull/3052/files#diff-79691434980a21ca457789938a9410c3

### debug

系统首次启动失败(初始化失败)

`SD` 卡插入电脑,查看 `boot/pi64-config-debug.txt` 文件内容.

## Releases

The latest images are always available in the [releases](https://github.com/bamarni/pi64/releases) section.

There are 2 versions : `lite` and `desktop`. The desktop version is based on [LXDE](http://lxde.org/).

## Installation

Once downloaded, you can follow [these instructions](https://www.raspberrypi.org/documentation/installation/installing-images/README.md) for writing the image to your SD card.

During first boot the installation process will continue for a few minutes, then the Raspberry Pi will reboot and you'll be ready to go.

## Getting started

The default user is `pi` and its password `raspberry`, it has passwordless root privileges escalation through `sudo`.

Once logged in, you might want to run `sudo pi64-config` in order to get assisted with your setup!

On the lite version, SSH is enabled by default.

## FAQ

### How do I update the Linux Kernel?

You can upgrade the Linux Kernel using this command :

    sudo pi64-update

This would make sure the latest release from https://github.com/bamarni/pi64-kernel is installed.

*Do not use `apt-get` to install or update a kernel, kernel modules or kernel headers as this is not supported.*

### Can I still run 32-bit programs with pi64?

You should be able to run 32-bit programs out of the box as long as they're statically linked. You can check this with the `file` command :

    $ file ./my-executable
    ./my-executable: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), statically linked, not stripped

If your 32-bit program is shown as dynamically linked instead, you should still be able to run it by enabling [multiarch](https://wiki.debian.org/Multiarch/HOWTO) and installing program's required libraries :

    sudo dpkg --add-architecture armhf
    sudo apt-get update
    sudo apt-get install libc6:armhf

Here we're only installing the GNU C Library, but your program might need additional libraries.

### How can I remove SSH?

On the lite version and for convenience, SSH is installed and enabled by default. This allows you to plug your Raspberry Pi to your home router and get started without the need
of an extra monitor / keyboard. If you want to remove it, just run :

    sudo apt-get autoremove --purge -y ssh avahi-daemon

### Is there a way to run custom post-installation steps?

You can just drop a file called `setup` on the boot partition. When the installer notices that file at `/boot/setup`, it will automatically execute it using bash when installation finishes.

This can be useful if you want to distribute your own image based on pi64.
