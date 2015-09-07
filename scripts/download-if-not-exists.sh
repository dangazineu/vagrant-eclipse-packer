#!/bin/bash

FILE_NAME=$1
DESTINATION=$2
URL=$3
HEADER=$4

if [ -f "$DESTINATION/$FILE_NAME" ]
then
	echo "$DESTINATION/$FILE_NAME is already present, won't download it again."
elif [ -z "$HEADER" ]; then
	echo "$DESTINATION/$FILE_NAME not found. Downloading without header..."
	wget --no-cookies --no-check-certificate -O "$DESTINATION/$FILE_NAME" $URL
	echo "Downloaded $FILE_NAME"
else
	echo "$DESTINATION/$FILE_NAME not found. Downloading with header..."
	wget --no-cookies --no-check-certificate -O "$DESTINATION/$FILE_NAME" --header "$HEADER" $URL
	echo "Downloaded $FILE_NAME"
fi

