#!/bin/bash

TOOLS_BIN="${TOOLS_BIN:-tools/bin}"
mkdir -p "$TOOLS_BIN"

if [ -f "$TOOLS_BIN/dnsx" ]; then
    echo "dnsx is already installed"
    exit 0
fi

go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest

DNSX_PATH=$(find ~/go/bin /usr/local/go/bin /usr/bin /usr/local/bin -name dnsx 2>/dev/null | head -n1)
if [ -n "$DNSX_PATH" ]; then
    mv "$DNSX_PATH" "$TOOLS_BIN/"
    chmod +x "$TOOLS_BIN/dnsx"
fi

"$TOOLS_BIN/dnsx" -version