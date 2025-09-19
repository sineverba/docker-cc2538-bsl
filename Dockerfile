ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}-alpine3.22

# Update and upgrade system packages
RUN apk update && \
    apk add --upgrade apk-tools && \
    apk upgrade --available && \
    rm -rf /var/cache/apk/*

# Declare PIP_VERSION after FROM to make it available in subsequent RUN instructions
ARG PIP_VERSION

# Upgrade pip to specific version
RUN pip3 install --upgrade pip==${PIP_VERSION}

# Set working directory
WORKDIR /app

# Set env variable
ENV FILENAME firmware.hex

# Install requirements
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Copy cc2538-bsl.py
COPY cc2538-bsl.py .

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

CMD [ "/entrypoint.sh" ]