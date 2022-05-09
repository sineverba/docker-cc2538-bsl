IMAGE_NAME=sineverba/cc2538-bsl
CONTAINER_NAME=cc2538-bsl
VERSION=1.0.0-dev
TOPDIR=$(PWD)

build:
	docker build --tag $(IMAGE_NAME):$(VERSION) .

inspect:
	docker run \
	--privileged \
	-e "FILENAME=CC2652RB_coordinator_20220219.hex" \
	-v $(TOPDIR)/firmware/:/home/flash/app \
	-v /dev/serial/by-id/usb-Silicon_Labs_slae.sh_cc2652rb_stick_-_slaesh_s_iot_stuff_00_12_4B_00_23_93_25_9F-if00-port0:/dev/USB0 \
	-v /run/udev:/run/udev:ro \
	--rm -it \
	--name $(CONTAINER_NAME) \
	$(IMAGE_NAME):$(VERSION) \
	/bin/sh

spin:
	docker run \
	--privileged \
	-e "FILENAME=CC2652RB_coordinator_20220219.hex" \
	-v $(TOPDIR)/firmware/:/home/flash/app \
	-v /dev/serial/by-id/usb-Silicon_Labs_slae.sh_cc2652rb_stick_-_slaesh_s_iot_stuff_00_12_4B_00_23_93_25_9F-if00-port0:/dev/USB0 \
	-v /run/udev:/run/udev:ro \
	--rm -it \
	--name $(CONTAINER_NAME) \
	$(IMAGE_NAME):$(VERSION)

test:
	docker run --rm -it --name $(CONTAINER_NAME) $(IMAGE_NAME):$(VERSION) cat /etc/os-release | grep "Alpine Linux"
	docker run --rm -it --name $(CONTAINER_NAME) $(IMAGE_NAME):$(VERSION) cat /etc/os-release | grep "3.15"
	docker run --rm -it --name $(CONTAINER_NAME) $(IMAGE_NAME):$(VERSION) python --version | grep "Python 3.10.4"
	docker run --rm -it --name $(CONTAINER_NAME) $(IMAGE_NAME):$(VERSION) pip3 --version | grep "pip 22.0.4"
	docker run --rm -it --name $(CONTAINER_NAME) $(IMAGE_NAME):$(VERSION) python ./cc2538-bsl.py --version | grep "2.1"
	
destroy:
	docker image rm $(IMAGE_NAME):$(VERSION)
