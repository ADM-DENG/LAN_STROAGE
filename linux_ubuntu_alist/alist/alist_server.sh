#!/bin/bash

cd /opt/alist

ALIST_BIN="/opt/alist/alist"
ALIST_LOG="/opt/alist/data/log/alist_start.log"
ALIST_URL="http://127.0.0.1:5200"

if ! pgrep -f "$ALIST_BIN server" > /dev/null; then
    nohup "$ALIST_BIN" server >> "$ALIST_LOG" 2>&1 &
    sleep 5
fi

xdg-open "$ALIST_URL"