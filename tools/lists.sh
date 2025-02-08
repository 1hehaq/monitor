#!/bin/bash

# mkdir -p ../lists

# curl -LO https://github.com/and0x00/resolvers.txt/raw/refs/heads/main/resolvers.txt
# cat resolvers.txt | grep -E -o "([0-9]{1,3}\.){3}[0-9]{1,3}" | anew ../lists/resolvers.txt

# curl -LO https://github.com/trickest/resolvers/raw/refs/heads/main/resolvers-trusted.txt
# cat resolvers-trusted.txt | grep -E -o "([0-9]{1,3}\.){3}[0-9]{1,3}" | anew ../lists/trusted.txt

# curl -LO https://raw.githubusercontent.com/assetnote/commonspeak2-wordlists/refs/heads/master/subdomains/subdomains.txt
# cat subdomains.txt | sort -u > ../lists/subdomains.txt
# cat ../lists/subdomains.txt | shuf -n 1000 | anew ../lists/subdomains1000.txt

# rm -f resolvers.txt resolvers-trusted.txt subdomains.txt

echo 'Hello haq'