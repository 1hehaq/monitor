#!/bin/bash

TOOLS_BIN="${TOOLS_BIN:-tools/bin}"
mkdir -p "$TOOLS_BIN"

if [ -f "$TOOLS_BIN/anew" ]; then
    echo "anew is already installed"
    exit 0
fi

go install github.com/tomnomnom/anew@latest

ANEW_PATH=$(find ~/go/bin /usr/local/go/bin /usr/bin /usr/local/bin -name anew 2>/dev/null | head -n1)
if [ -n "$ANEW_PATH" ]; then
    mv "$ANEW_PATH" "$TOOLS_BIN/"
    chmod +x "$TOOLS_BIN/anew"
fi

echo "Say haq" | "$TOOLS_BIN/anew"