#!/bin/bash

if [ -z "$DISCORD_WEBHOOK" ]; then
    echo "Error: DISCORD_WEBHOOK environment variable is not set"
    exit 1
fi

send_to_discord() {
    local content="$1"
    local file="$2"
    local thread_id="$3"
    
    if [ -n "$file" ] && [ -f "$file" ]; then
        if [ -n "$thread_id" ]; then
            curl -s -F "payload_json={\"content\":\"$content\", \"message_reference\":{\"message_id\":\"$thread_id\"}}" \
                 -F "file=@$file;filename=subdomains.txt" \
                 "$DISCORD_WEBHOOK"
        else
            curl -s -F "payload_json={\"content\":\"$content\"}" \
                 -F "file=@$file;filename=subdomains.txt" \
                 "$DISCORD_WEBHOOK"
        fi
    else
        if [ -n "$thread_id" ]; then
            curl -s -H "Content-Type: application/json" \
                 -d "{\"content\":\"$content\", \"message_reference\":{\"message_id\":\"$thread_id\"}}" \
                 "$DISCORD_WEBHOOK"
        else
            curl -s -H "Content-Type: application/json" \
                 -d "{\"content\":\"$content\"}" \
                 "$DISCORD_WEBHOOK"
        fi
    fi
}

current_target=$(cat target.txt 2>/dev/null)
if [ -z "$current_target" ]; then
    echo "No target specified in target.txt"
    exit 1
fi

current_file="save/$current_target/subdomains.txt"
if [ ! -f "$current_file" ]; then
    echo "No subdomain file found for $current_target"
    exit 1
fi

prev_file="save/$current_target/previous.txt"
if [ ! -f "$prev_file" ]; then
    touch "$prev_file"
fi

temp_file=$(mktemp)
comm -23 <(sort "$current_file") <(sort "$prev_file") > "$temp_file"

if [ -s "$temp_file" ]; then
    count=$(wc -l < "$temp_file")
    timestamp=$(date '+%Y-%m-%d %H:%M:%S UTC')
    message="Found **$count** new subdomains of **$current_target**\nTime: **$timestamp**"
    
    if [ $(wc -c < "$temp_file") -gt 7900 ]; then
        response=$(send_to_discord "$message")
        thread_id=$(echo "$response" | grep -o '"id":"[0-9]*"' | head -1 | cut -d'"' -f4)
        
        split_dir=$(mktemp -d)
        cd "$split_dir"
        split -b 7900 "$temp_file" "part_"
        
        part=1
        total=$(ls part_* | wc -l)
        for chunk in part_*; do
            if [ -s "$chunk" ]; then
                mv "$chunk" "${chunk}.txt"
                send_to_discord "Part $part of $total:" "${chunk}.txt" "$thread_id"
                sleep 1
            fi
            ((part++))
        done
        
        cd - > /dev/null
        rm -rf "$split_dir"
    else
        send_to_discord "$message" "$temp_file"
    fi
    
    echo "Sent notification for $count new subdomains of $current_target"
    cp "$current_file" "$prev_file"
else
    echo "No new subdomains found for $current_target"
fi

rm -f "$temp_file"