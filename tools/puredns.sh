#!/bin/bash

TOOLS_BIN="${TOOLS_BIN:-tools/bin}"
mkdir -p "$TOOLS_BIN"

if [ -f "$TOOLS_BIN/puredns" ]; then
    echo "puredns is already installed"
    exit 0
fi

go install -v github.com/d3mondev/puredns/v2@latest

PUREDNS_PATH=$(find ~/go/bin /usr/local/go/bin /usr/bin /usr/local/bin -name puredns 2>/dev/null | head -n1)
if [ -n "$PUREDNS_PATH" ]; then
    mv "$PUREDNS_PATH" "$TOOLS_BIN/"
    chmod +x "$TOOLS_BIN/puredns"
fi

"$TOOLS_BIN/puredns" --version