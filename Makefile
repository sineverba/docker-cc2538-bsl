IMAGE_NAME=sineverba/cc2538-bsl
CONTAINER_NAME=cc2538-bsl
VERSION=1.3.0-dev
PYTHON_VERSION=3.12.1
ALPINE_VERSION=3.19.0
TOPDIR=$(PWD)


devbuild:
	docker build \
		--tag $(IMAGE_NAME):$(VERSION) \
		--file dockerfiles/development/Dockerfile \
		"."

devspin:
	docker run \
		--rm -it \
		--name $(CONTAINER_NAME) \
		--entrypoint /bin/sh \
		$(IMAGE_NAME):$(VERSION)

build:
	docker build \
		--build-arg PYTHON_VERSION=$(PYTHON_VERSION) \
		--tag $(IMAGE_NAME):$(VERSION) .

upgrade:
	mkdir req
	cp requirements.txt req/
	docker run --rm -v $(TOPDIR)/req:/usr/src/app \
		python:$(PYTHON_VERSION)-alpine3.19 /bin/sh \
		-c "cd /usr/src/app && pip install --upgrade pip && pip install -r requirements.txt && pip freeze > requirements.txt && cat requirements.txt"
	# Copy requirements
	rm -rf requirements.txt
	cp req/requirements.txt requirements.txt
	rm -rf req/

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
	docker run --rm -it --name $(CONTAINER_NAME) $(IMAGE_NAME):$(VERSION) pip3 --version | grep "pip 23.2.1"
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
