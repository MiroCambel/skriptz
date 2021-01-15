#!/bin/bash

MODE=""
WANTED_DEV=""
GETTING_ADDR=""
ADDR=""
MACHINE=""

if [ -z "$1" ]; then
	echo "gimmeh machine, bitch" >&2
	exit 1
fi

MACHINE="$1"

# I am in the office by default
if [ -z "$2" ]; then
	MODE="cable"
else
	MODE="$2"
fi

if [ "$MODE" = "cable" ]; then
	WANTED_DEV="enp0s31f6:"
elif [ "$MODE" = "vpn" ]; then
	WANTED_DEV="tun0:"
else
	echo "bad option: use either 'vpn' or 'cable'" >&2
	exit 1
fi

while read NUM_TYPE DEV_ADDR REST; do
	if [ -n "$GETTING_ADDR" ]; then
		GREP_OUT=$(echo "$NUM_TYPE" | egrep '^[0-9]+:' -)
		if [ -n "$GREP_OUT" ]; then
			break
		fi
		if [ "$NUM_TYPE" = "inet" ]; then
			ADDR="$DEV_ADDR"
			break
		fi
		continue
	fi
	if [ "$DEV_ADDR" = "$WANTED_DEV" ]; then
		GETTING_ADDR='1'
	fi
done < <(ip addr) 

if [ -z "$ADDR" ]; then
	echo "get connected, bitch" >&2
	exit 1
fi

EXPORTS=$(echo "/root/ttt_repos/ttt-mmsci ${ADDR}(rw,sync)")

ssh "root@${MACHINE}" "echo \"$EXPORTS\" > /etc/exports; exportfs -rav"
sudo mount -t nfs "${MACHINE}:/root/ttt_repos/ttt-mmsci" "/home/miro/work/nfs"
