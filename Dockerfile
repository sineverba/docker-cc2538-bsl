ARG PYTHON_VERSION=3.12.1
FROM python:${PYTHON_VERSION}-alpine3.19
# Update and upgrade
# Update and upgrade
RUN apk update && \
    apk add --upgrade apk-tools && \
    apk upgrade --available && \
    rm -rf /var/cache/apk/*
# Set env variable
ENV FILENAME firmware.hex
# Install requirements
COPY requirements.txt .
RUN pip3 install -r requirements.txt
# Copy cc2538-bsl.py
COPY cc2538-bsl.py .
# Run image
COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
CMD [ "/entrypoint.sh" ]
