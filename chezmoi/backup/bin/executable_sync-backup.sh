#!/bin/bash

RSYNC_BASE="rsync://storage"
PHOTOS_SRC_DIR="/mnt/data/photos"
PHOTOS_RSYNC="$RSYNC_BASE/photos"
PHOTOS_IMPORT_RSYNC="$RSYNC_BASE/backup-local/photos-import"
MOVIES_SRC_DIR="/mnt/data/movies"
MOVIES_RSYNC="$RSYNC_BASE/movies"
EBOOKS_SRC_DIR="/mnt/data/ebooks"
EBOOKS_RSYNC="$RSYNC_BASE/ebooks"
PRIVATE_SRC_DIR="/home/piontec/backup"
PRIVATE_3D_SRC_DIR_1="/mnt/data/diy/laser"
PRIVATE_3D_SRC_DIR_2="/mnt/data/diy/freecad"
PRIVATE_RSYNC="$RSYNC_BASE/backup/piontec-t495"
IF=wlp98s0

sync_dir() {
	SRC_DIR=$1
	RMT_DIR=$2
	FILTER=$3
	EXTRA=$4
	echo "Syncing from $SRC_DIR to $RMT_DIR with filter $FILTER"
	[ ! -d "$SRC_DIR" ] && echo "Directory $SRC_DIR DOES NOT exists." && exit 1
	rsync --bwlimit=30M -rlptoDvxP "$SRC_DIR/" "$RMT_DIR/" --include="$FILTER" --exclude="*" $EXTRA
}

uid=$(id -u $USER)
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${uid}/bus

connection_name=$(nmcli device show $IF | awk '/GENERAL\.CONNECTION/ {print $2}')
connection_state=$(nmcli device show $IF | awk -F "[()]" '/GENERAL\.STATE/ {print $2}')
if [[ ! (((("$connection_name" == "konet" || "$connection_name" == "konet5")) && "$connection_state" == "connected")) ]]; then
	notify-send "Not doing backups as not connected to 'konet'or 'konet5'"
	exit 1
fi

notify-send "Starting rsync backup"
# photos
sync_dir $PHOTOS_SRC_DIR $PHOTOS_RSYNC "/__imp_*/***"
sync_dir "$PHOTOS_SRC_DIR/___import" $PHOTOS_IMPORT_RSYNC "/***" --delete
# movies
sync_dir $MOVIES_SRC_DIR $MOVIES_RSYNC "/nasze/***"
sync_dir $MOVIES_SRC_DIR $MOVIES_RSYNC "/others/***"
sync_dir $MOVIES_SRC_DIR $MOVIES_RSYNC "/_import/***" --delete
# ebooks
# sync_dir $EBOOKS_SRC_DIR $EBOOKS_RSYNC "/calibre/***"
sync_dir $EBOOKS_SRC_DIR $EBOOKS_RSYNC "/audiobooks/***"
sync_dir $EBOOKS_SRC_DIR $EBOOKS_RSYNC "/_import/***" --delete
# private backup
sync_dir $PRIVATE_SRC_DIR $PRIVATE_RSYNC "/***"
sync_dir $PRIVATE_3D_SRC_DIR_1 $PRIVATE_RSYNC/diy/laser "/***"
sync_dir $PRIVATE_3D_SRC_DIR_2 $PRIVATE_RSYNC/diy/freecad "/***"
# done
API_KEY="$(cat /home/piontec/.immich-key)"
immich-go upload from-folder \
	--no-ui \
	--folder-as-album FOLDER \
	--manage-raw-jpeg=StackCoverJPG \
	--server http://immich:2283 \
	--api-key "$API_KEY" \
	--admin-api-key "$(cat /home/piontec/.immich-key-admin)" \
	--manage-raw-jpeg StackCoverJPG \
	--manage-burst Stack /mnt/data/photos/my*
immich-go upload from-folder \
	--no-ui \
	--folder-as-album FOLDER \
	--manage-raw-jpeg=StackCoverJPG \
	--server http://immich:2283 \
	--api-key "$API_KEY" \
	--admin-api-key "$(cat /home/piontec/.immich-key-admin)" \
	--manage-raw-jpeg StackCoverJPG \
	--manage-burst Stack /mnt/data/photos/mix*
node ~/backup/bin/immich-add-user-to-all-albums.js http://immich:2283 "$API_KEY" krystyna.m.piatkowska@gmail.com editor
notify-send "Rsync backup done"
