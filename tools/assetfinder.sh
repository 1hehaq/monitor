#!/bin/bash

TOOLS_BIN="${TOOLS_BIN:-tools/bin}"
mkdir -p "$TOOLS_BIN"

if [ -f "$TOOLS_BIN/assetfinder" ]; then
    echo "assetfinder is already installed"
    exit 0
fi

go install github.com/tomnomnom/assetfinder@latest

ASSETFINDER_PATH=$(find ~/go/bin /usr/local/go/bin /usr/bin /usr/local/bin -name assetfinder 2>/dev/null | head -n1)
if [ -n "$ASSETFINDER_PATH" ]; then
    mv "$ASSETFINDER_PATH" "$TOOLS_BIN/"
    chmod +x "$TOOLS_BIN/assetfinder"
fi

"$TOOLS_BIN/assetfinder" -h
