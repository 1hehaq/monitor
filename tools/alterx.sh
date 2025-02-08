#!/bin/bash

TOOLS_BIN="${TOOLS_BIN:-tools/bin}"
mkdir -p "$TOOLS_BIN"

if [ -f "$TOOLS_BIN/alterx" ]; then
    echo "alterx is already installed"
    exit 0
fi

go install -v github.com/projectdiscovery/alterx/cmd/alterx@latest

ALTERX_PATH=$(find ~/go/bin /usr/local/go/bin /usr/bin /usr/local/bin -name alterx 2>/dev/null | head -n1)
if [ -n "$ALTERX_PATH" ]; then
    mv "$ALTERX_PATH" "$TOOLS_BIN/"
    chmod +x "$TOOLS_BIN/alterx"
fi

"$TOOLS_BIN/alterx" -version