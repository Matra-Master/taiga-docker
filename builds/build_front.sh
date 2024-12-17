#!/bin/sh
# Build front image, send it to the server and load image into server
# Cleanup after

SERVICE=taiga-front
IMAGE_NAME=tuxditaiga/taiga-front:latest
SERVER_NAME=tuxdi_tools
#SERVER_LOCATION=~/taiga-docker2


docker compose -f ../docker-compose.yml -f ../build.yml build $SERVICE \
&& docker save -o "$SAVE_LOCATION/$SERVICE.tar" $IMAGE_NAME \
&& rsync -vzr -e ssh "$SAVE_LOCATION/$SERVICE.tar" $SERVER_NAME:~/images \
&& ssh $SERVER_NAME -t "cd images && docker load -i $SERVICE.tar && rm $SERVICE.tar" \
&& rm "$SAVE_LOCATION/$SERVICE.tar"
