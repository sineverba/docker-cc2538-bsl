Docker CC2538 / CC2652 BSL Docker flash
=======================================

> Docker image to flash firmware on CC2538 - CC2652 Zigbee keys with the help of 2538bsl py.

Credits: https://github.com/JelmerT/cc2538-bsl.git

| CI / CD | Status |
| ------- | ------ |
| Semaphore | [![Build Status](https://sineverba.semaphoreci.com/badges/docker-cc2538-bsl/branches/master.svg?style=shields&key=177dc3d1-ccb5-43c5-95ad-06fb51346f81)](https://sineverba.semaphoreci.com/projects/docker-cc2538-bsl) |
| CircleCI | [![CircleCI](https://dl.circleci.com/status-badge/img/gh/sineverba/docker-cc2538-bsl/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/sineverba/docker-cc2538-bsl/tree/master) |


## Available architectures

+ linux/arm64
+ linux/arm/v6
+ linux/arm/v7

## Setup for development

[![Open in Dev Containers](https://img.shields.io/static/v1?label=Dev%20Containers&message=Open&color=blue&logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/sineverba/docker-cc2538-bsl)

Or

1. Install VSCode extension "Dev Containers"

2. Clone and open up the repository in VSCode, then, you should see the following notification:

![VSCode popup](./.devcontainer/folder.webp)

3. Click on "Reopen in Container"

4. Enjoy!


## How to use

1. Get the serial by ID `/dev/serial/by-id/`
2. Download the firmware to write
3. Run Docker with (replace your serial ID)

```shell
docker run \
	--privileged \
	-e "FILENAME=CC2652RB_coordinator_20220219.hex" \
	-v $(TOPDIR)/firmware/:/home/flash/app \
	-v /dev/serial/by-id/usb-Silicon_Labs_slae.sh_cc2652rb_stick_-_slaesh_s_iot_stuff_00_12_4B_00_23_93_25_9F-if00-port0:/dev/USB0 \
	-v /run/udev:/run/udev:ro \
	--rm -it \
	--name cc25838bsl \
	sineverba/cc2538-bsl:1.4.0
```
