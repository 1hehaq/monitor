#!/bin/bash

discord_webhook="$DISCORD_WEBHOOK_URL"

targets_url="https://raw.githubusercontent.com/arkadiyt/bounty-targets-data/refs/heads/main/data/wildcards.txt"

echo "[+] Fetching a single target from HackerOne..."

target=$(curl -s "$targets_url" | shuf -n 1 | sed 's/^\*\.//')

echo "[*] Scanning: $target"

results=$(wget -qO- "https://web.archive.org/cdx/search/cdx?url=*.$target/*&collapse=urlkey&output=text&fl=original&filter=original:.*\.(db|sql|bak|log|key|pem|crt|backup|config|ini|asc|yml|yaml|gz|rar|7z)$")

if [ -n "$results" ]; then
    json_payload=$(jq -n --arg target "$target" --arg results "$results" '{content: "Wayback results for \($target):\n\($results)"}')
    curl -H "Content-Type: application/json" -X POST -d "$json_payload" "$discord_webhook"
else
    echo "[*] No sensitive files found for $target."
fi

echo "[+] Scan complete for $target. Results sent to Discord."
