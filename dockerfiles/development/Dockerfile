FROM python:3.12.1-alpine3.19
# Update and upgrade
RUN apk update && \
    apk add --upgrade apk-tools git openssh-client && \
    apk upgrade --available && \
    rm -rf /var/cache/apk/*
# Create a group and user
ENV USER=nonroot
ENV GROUPNAME=$USER
ENV UID=12345
ENV GID=23456

RUN addgroup \
    --gid "$GID" \
    "$GROUPNAME" \
&&  adduser \
    --disabled-password \
    --gecos "" \
    --ingroup "$GROUPNAME" \
    --uid "$UID" \
    $USER
# Tell docker that all future commands should run as the appuser user
USER nonroot
## Set env variable
#ENV FILENAME firmware.hex
## Install requirements
COPY ../../requirements.txt .
RUN pip3 install -r requirements.txt