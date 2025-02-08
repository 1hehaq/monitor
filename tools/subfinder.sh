#!/bin/bash

TOOLS_BIN="${TOOLS_BIN:-tools/bin}"
mkdir -p "$TOOLS_BIN"

if [ -f "$TOOLS_BIN/subfinder" ]; then
    echo "subfinder is already installed"
    exit 0
fi

go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

SUBFINDER_PATH=$(find ~/go/bin -name subfinder 2>/dev/null | head -n1)
if [ -n "$SUBFINDER_PATH" ]; then
    mv "$SUBFINDER_PATH" "$TOOLS_BIN/"
    chmod +x "$TOOLS_BIN/subfinder"
fi

"$TOOLS_BIN/subfinder" -version