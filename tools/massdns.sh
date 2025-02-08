#!/bin/bash

TOOLS_BIN="${TOOLS_BIN:-tools/bin}"
mkdir -p "$TOOLS_BIN"

if [ -f "$TOOLS_BIN/massdns" ]; then
    echo "massdns is already installed"
    exit 0
fi

sudo apt-get update
sudo apt-get install -y make gcc

git clone https://github.com/blechschmidt/massdns.git
cd massdns
make

mv bin/massdns "$TOOLS_BIN/"
chmod +x "$TOOLS_BIN/massdns"
cd ..
rm -rf massdns

"$TOOLS_BIN/massdns" -h
