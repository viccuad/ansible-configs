#!/bin/bash

#
# {{ ansible_managed }}
#

set -eu

BACKUPHOST={{ backup_server_host }}

HOSTNAME="$(hostname -f)"
if ! echo $HOSTNAME | grep -q . ; then
    echo \`hostname -f\` did not return a valid hostname >&2
    exit 1
fi

export BORG_REPO="${BACKUPHOST}:backups/${HOSTNAME}"
if [ -n "${ARCHIVE:-}" ]; then
    echo "Warning: using ARCHIVE name coming from the environment: '$ARCHIVE'" >&2
else
    ARCHIVE='General-{now:%Y-%m-%d}'
fi

BORG=borg

pwd_file='{{ pwfile }}'
if [ ! -f "$pwd_file" ]; then
    echo "$pwd_file does not exist" >&2
    exit 1
elif [ `stat --format='%u:%g_%U:%G_%a' "$pwd_file"` != "0:0_root:root_400" ]; then
    echo "$pwd_file doesn't have the correct permissions (root:root 400):" >&2
    stat "$pwd_file" >&2
    exit 1
else
    # finally the file is good enough for us
    export BORG_PASSPHRASE="$(< $pwd_file)"
    if [ -z "$BORG_PASSPHRASE" ]; then
        echo "$pwd_file is empty" >&2
        exit 1
    fi
fi

if ! wget -q --spider https://google.com ; then
    echo "Network not available, trying to wait two minutes and see if it's back" >&2
    sleep 2m
fi

b_init(){
    "$BORG" init -v --show-rc
}
b_list() {
    # XXX --list-format is not working as documented
    # https://github.com/borgbackup/borg/issues/1213
    set -x
    "$BORG" list \
        --list-format="{mode} {size:8d} {isomtime} {path}{extra}{NEWLINE}" \
        $@
}
b_create() {
    # `borg help patterns` for help with exclusion patterns
    "$BORG" create \
        -v \
        --stats \
        --show-rc \
        --progress \
        --compression zlib \
        --exclude-caches \
        --exclude-if-present .nobackup \
        --exclude '*.pyc' \
        --exclude '/var/cache/' \
        --exclude '/var/lib/apt/lists' \
        --exclude '/var/lib/munin/*.tmp' \
        --exclude '/home/*/Downloads' \
        --exclude '/home/*/tmp' \
        --exclude '/home/*/.cache' \
        --exclude '/home/*/.local/share/Trash' \
        "::${ARCHIVE}" \
        /etc \
        /home \
        /root \
        /srv \
        /var \
        $@
}
b_prune() {
    # Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
    # archives of THIS machine.
    "$BORG" prune \
        -v \
        --list \
        --stats \
        --show-rc \
        --keep-within 30d \
        --keep-daily 7 \
        --keep-weekly 4 \
        --keep-monthly 6 \
        --keep-yearly 20 \
        $@
}
b_break-lock() {
    exec "$BORG" break-lock -v --show-rc
}
b_delete() {
    exec "$BORG" delete -v --stat --show-rc $@
}


if [ $# -gt 0 ]; then
    case "$1" in
        init)
            b_init
            ;;
        list)
            shift
            b_list $@
            ;;
        create)
            shift
            b_create $@
            ;;
        prune)
            shift
            b_prune $@
            ;;
        break-lock)
            shift
            b_break-lock $@
            ;;
        delete)
            shift
            b_delete $@
            ;;
        --)
            shift
            set -x
            exec "$BORG" $@
            ;;
        *)
            exec "$BORG" $@
            ;;
    esac
    exit $?
fi

# default action with none specified
b_create
b_prune
