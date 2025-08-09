IMAGE_NAME=sineverba/cc2538-bsl
CONTAINER_NAME=cc2538-bsl
VERSION=1.4.0-dev
PYTHON_VERSION=3.13.6
ALPINE_VERSION=3.22
TOPDIR=$(PWD)

build:
	docker build \
		--build-arg PYTHON_VERSION=$(PYTHON_VERSION) \
		--tag $(IMAGE_NAME):$(VERSION) \
		--file Dockerfile \
		"."

upgrade:
	docker run --rm -it \
		--name $(CONTAINER_NAME) \
		-v $(PWD)/requirements.txt:/app/requirements.txt \
		$(IMAGE_NAME):$(VERSION) \
		sh -c "pip install --upgrade pip --root-user-action=ignore \
		&& pip list --outdated \
		&& sed 's/==/>=/' /app/requirements.txt > /tmp/requirements_temp.txt \
		&& cat /tmp/requirements_temp.txt > /app/requirements.txt \
		&& pip install -r /app/requirements.txt --upgrade --root-user-action=ignore \
		&& pip freeze > /tmp/requirements_new.txt \
		&& sed 's/>=/==/' /tmp/requirements_new.txt > /app/requirements.txt"


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
	-e "FILENAME=CC2652RB_router_20221102.hex" \
	-v $(TOPDIR)/firmware/:/home/flash/app \
	-v /dev/serial/by-id/usb-Silicon_Labs_slae.sh_cc2652rb_stick_-_slaesh_s_iot_stuff_00_12_4B_00_23_93_25_9F-if00-port0:/dev/USB0 \
	-v /run/udev:/run/udev:ro \
	--rm -it \
	--name $(CONTAINER_NAME) \
	$(IMAGE_NAME):$(VERSION)

test:
	docker run --rm -it --name $(CONTAINER_NAME) $(IMAGE_NAME):$(VERSION) cat /etc/os-release | grep "Alpine Linux"
	docker run --rm -it --name $(CONTAINER_NAME) $(IMAGE_NAME):$(VERSION) cat /etc/os-release | grep $(ALPINE_VERSION)
	docker run --rm -it --name $(CONTAINER_NAME) $(IMAGE_NAME):$(VERSION) python --version | grep $(PYTHON_VERSION)
	docker run --rm -it --name $(CONTAINER_NAME) $(IMAGE_NAME):$(VERSION) pip3 --version | grep "pip 25.2"
	docker run --rm -it --name $(CONTAINER_NAME) $(IMAGE_NAME):$(VERSION) python ./cc2538-bsl.py --version | grep "2.1"
	
destroy:
	# Remove all images with no current tag
	docker rmi $$(docker images $(IMAGE_NAME):* --format "{{.Repository}}:{{.Tag}}" | grep -v '$(APP_VERSION)') || exit 0;
	# Remove all python images
	docker rmi $$(docker images python --format "{{.Repository}}:{{.Tag}}") || exit 0;
	# Remove all dangling images
	docker rmi $$(docker images -f "dangling=true" -q) || exit 0;
	# Remove cached builder
	docker builder prune -f
