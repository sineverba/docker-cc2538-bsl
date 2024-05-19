ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}-alpine3.19
# Update and upgrade
RUN apk update && \
    apk add --upgrade apk-tools && \
    apk upgrade --available && \
    rm -rf /var/cache/apk/*
# Set env variable
ENV FILENAME firmware.hex
# Install requirements
COPY ../../requirements.txt .
RUN pip3 install -r requirements.txt
# Copy cc2538-bsl.py
COPY ../../cc2538-bsl.py .
COPY dockerfiles/production/entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
CMD [ "/entrypoint.sh" ]
