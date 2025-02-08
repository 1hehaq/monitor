#!/bin/bash

TOOLS_BIN="${TOOLS_BIN:-tools/bin}"
mkdir -p "$TOOLS_BIN"

if [ -f "$TOOLS_BIN/httpx" ]; then
    echo "httpx is already installed"
    exit 0
fi

go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

HTTPIX_PATH=$(find ~/go/bin /usr/local/go/bin /usr/bin /usr/local/bin -name httpx 2>/dev/null | head -n1)
if [ -n "$HTTPIX_PATH" ]; then
    mv "$HTTPIX_PATH" "$TOOLS_BIN/"
    chmod +x "$TOOLS_BIN/httpx"
fi

"$TOOLS_BIN/httpx" -version