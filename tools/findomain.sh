#!/bin/bash

TOOLS_BIN="${TOOLS_BIN:-tools/bin}"
mkdir -p "$TOOLS_BIN"

if [ -f "$TOOLS_BIN/findomain" ]; then
    echo "findomain is already installed"
    exit 0
fi

curl -LO https://github.com/findomain/findomain/releases/latest/download/findomain-linux-i386.zip && unzip findomain-linux-i386.zip && chmod +x findomain && mv findomain "$TOOLS_BIN/"

"$TOOLS_BIN/findomain" --help