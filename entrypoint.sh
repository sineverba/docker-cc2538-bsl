#!/usr/bin/env sh
set -e
python ./cc2538-bsl.py -p /dev/USB0 -evw /home/flash/app/$FILENAME
