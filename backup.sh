#!/usr/bin/env bash
# Maintainer: Fran
#
# Taiga backup script — cron-ready (absolute paths, backup rotation)
#
# Install (weekly, Sundays 3 AM — well clear of the 6:25 AM daily restart):
#   echo "0 3 * * 0 root /root/taiga-docker2/backup.sh" > /etc/cron.d/taiga-backup
#
# For monthly instead (1st of month, 3 AM):
#   echo "0 3 1 * * root /root/taiga-docker2/backup.sh" > /etc/cron.d/taiga-backup
#

set -euo pipefail

# ── Tweakable variables ──────────────────────────────────────────
TAIGA_DIR="/root/taiga-docker2"
BACKUP_DIR="${TAIGA_DIR}/backups"
COMPOSE_FILE="${TAIGA_DIR}/docker-compose.yml"
COMPOSE_PROD="${TAIGA_DIR}/production.yml"
MAX_BACKUPS=3          # keep at most this many backups
DB_USER="heartyjax"
DB_NAME="heartyjax"
# ─────────────────────────────────────────────────────────────────

DIR_NAME=$(date +%Y%m%d-%H%M%S)
COMPOSE="docker compose -f ${COMPOSE_FILE} -f ${COMPOSE_PROD}"

# ── Rotate old backups ───────────────────────────────────────────
mkdir -p "$BACKUP_DIR"

# count existing backup dirs (oldest first by name, which is date-sortable)
EXISTING=( $(ls -1d "$BACKUP_DIR"/[0-9]* 2>/dev/null | sort) )
TO_DELETE=$(( ${#EXISTING[@]} - MAX_BACKUPS + 1 ))   # +1 to make room for the new one

if (( TO_DELETE > 0 )); then
  for dir in "${EXISTING[@]:0:$TO_DELETE}"; do
    rm -rf "$dir"
  done
fi

# ── Run backup ───────────────────────────────────────────────────
mkdir "$BACKUP_DIR/$DIR_NAME"

$COMPOSE exec -T taiga-db pg_dump -OU "$DB_USER" "$DB_NAME" \
  > "$BACKUP_DIR/$DIR_NAME/taiga-db-backup.sql"

$COMPOSE exec -T taiga-back tar czf taiga-media-backup.tar.gz media

$COMPOSE cp taiga-back:/taiga-back/taiga-media-backup.tar.gz \
  "$BACKUP_DIR/$DIR_NAME"

$COMPOSE exec -T taiga-back rm taiga-media-backup.tar.gz


