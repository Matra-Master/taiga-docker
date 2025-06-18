#!/bin/sh
# Build front image, send it to the server and load image into server
# Cleanup after
SERVER_NAME=tuxdi_tools
SERVER_LOCATION=/root/taiga-docker2

SELECTION=$(gum choose --selected="Both" "Front" "Both" "Back")
case $SELECTION in
  "Front")
    docker compose -f ../docker-compose.yml -f ../build.yml build taiga-front \
    && docker save -o taiga-front.tar tuxditaiga/taiga-front:latest \
    && rsync -vzr -e ssh taiga-front.tar "$SERVER_NAME:$SERVER_LOCATION" \
    && ssh $SERVER_NAME -t "cd $SERVER_LOCATION && docker load -i taiga-front.tar && rm taiga-front.tar" \
    && rm taiga-front.tar
    ;;
  "Back")
    docker compose -f ../docker-compose.yml -f ../build.yml build taiga-back \
    && docker save -o taiga-back.tar tuxditaiga/taiga-back:latest \
    && rsync -vzr -e ssh taiga-back.tar "$SERVER_NAME:$SERVER_LOCATION" \
    && ssh $SERVER_NAME -t "cd $SERVER_LOCATION && docker load -i taiga-back.tar && rm taiga-back.tar" \
    && rm taiga-back.tar \
    ;;
  "Both")
    docker compose -f ../docker-compose.yml -f ../build.yml build taiga-back taiga-front \
    && docker save -o taiga-back.tar tuxditaiga/taiga-back:latest \
    && docker save -o taiga-front.tar tuxditaiga/taiga-front:latest \
    && rsync -vzr -e ssh taiga-back.tar taiga-front.tar "$SERVER_NAME:$SERVER_LOCATION" \
    && ssh $SERVER_NAME -t "cd $SERVER_LOCATION && docker load -i taiga-back.tar && docker load -i taiga-front.tar && rm taiga-front.tar taiga-back.tar" \
    && rm taiga-back.tar taiga-front.tar
    ;;
esac
