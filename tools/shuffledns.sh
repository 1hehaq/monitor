#!/bin/bash

TOOLS_BIN="${TOOLS_BIN:-tools/bin}"
mkdir -p "$TOOLS_BIN"

if [ -f "$TOOLS_BIN/shuffledns" ]; then
    echo "shuffledns is already installed"
    exit 0
fi

go install -v github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest

SHUFFLEDNS_PATH=$(find ~/go/bin /usr/local/go/bin /usr/bin /usr/local/bin -name shuffledns 2>/dev/null | head -n1)
if [ -n "$SHUFFLEDNS_PATH" ]; then
    mv "$SHUFFLEDNS_PATH" "$TOOLS_BIN/"
    chmod +x "$TOOLS_BIN/shuffledns"
fi

"$TOOLS_BIN/shuffledns" -version