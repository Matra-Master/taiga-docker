#!/bin/sh

SERVICE=taiga-back
PROJECT_NAME=tuxditaiga/taiga-back:latest
SAVE_LOCATION=builds
SERVER_NAME=tuxdi_tools
SERVER_LOCATION=~/taiga-docker2


docker compose -f docker-compose.yml -f build.yml build --no-cache $SERVICE \
&& docker save -o "$SERVICE.tar" $PROJECT_NAME
#&& rsync -vzr -e ssh "$SAVE_LOCATION/$SERVICE.tar" $SERVER_NAME:~/images \
#&& ssh $SERVER_NAME -t "cd $SERVER_LOCATION && docker load -i $SERVICE.tar && docker compose up -d --force-recreate webapp && rm $SERVICE.tar" \
#&& rm "$SAVE_LOCATION/$SERVICE.tar" \
