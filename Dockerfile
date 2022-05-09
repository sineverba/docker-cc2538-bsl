FROM python:3.10.4-alpine3.15
# Update and upgrade
RUN apk update && apk upgrade --available
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
