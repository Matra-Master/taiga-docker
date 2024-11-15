#!/bin/sh

IMAGE=taiga-front
PROJECT_NAME=ttaiga
SAVE_LOCATION=builds
SERVER_NAME=tuxdi_tools
SERVER_LOCATION=~/taiga-docker2


docker compose -f docker-compose.prod.yml build --no-cache $IMAGE \
&& docker save -o "$SAVE_LOCATION/$IMAGE.tar" $PROJECT_NAME-$IMAGE:latest
#&& rsync -vzr -e ssh "$SAVE_LOCATION/$IMAGE.tar" $SERVER_NAME:~/images \
#&& ssh $SERVER_NAME -t "cd $SERVER_LOCATION && docker load -i $IMAGE.tar && docker compose up -d --force-recreate webapp && rm $IMAGE.tar" \
#&& rm "$SAVE_LOCATION/$IMAGE.tar" \
