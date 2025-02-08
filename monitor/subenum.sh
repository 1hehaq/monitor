#!/bin/bash

target=$1
save_dir="save/$target"
output_dir="output"

TOOLS_BIN="${TOOLS_BIN:-tools/bin}"

mkdir -p "$save_dir" "$output_dir"
rm -f "$output_dir"/*.txt

export PATH="$TOOLS_BIN:$PATH"

"$TOOLS_BIN/subfinder" -d $target -all -recursive -silent | "$TOOLS_BIN/anew" "$output_dir/subfinder.txt"
"$TOOLS_BIN/assetfinder" -subs-only $target | "$TOOLS_BIN/anew" "$output_dir/assetfinder.txt"
"$TOOLS_BIN/findomain" -t $target --quiet | "$TOOLS_BIN/anew" "$output_dir/findomain.txt"

ct_urls=$(curl -s "https://crt.sh/?q=%.$target&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u)
echo "$ct_urls" | "$TOOLS_BIN/anew" "$output_dir/crtsh.txt"
wayback_urls=$(curl -s "http://web.archive.org/cdx/search/cdx?url=*.$target/*&output=text&fl=original&collapse=urlkey" | sed -e 's/^.*:\/\///g' | cut -d '/' -f1 | sort -u)
rootdomain=$(echo $target | cut -d '.' -f 1)
echo "$wayback_urls" | grep ${rootdomain} | "$TOOLS_BIN/anew" "$output_dir/wayback.txt"

cat "$output_dir"/*.txt | sort -u | "$TOOLS_BIN/dnsx" -silent -t 1000 -resp -a -aaaa | cut -d ' ' -f1 | "$TOOLS_BIN/anew" "$output_dir/dns_validated.txt"
"$TOOLS_BIN/puredns" resolve "$output_dir/dns_validated.txt" --threads 250 --resolvers lists/resolvers.txt --resolvers-trusted lists/trusted.txt --rate-limit 1000 --bin "$TOOLS_BIN/massdns" | "$TOOLS_BIN/anew" "$output_dir/resolved.txt"

cat "$output_dir"/*.txt | grep -E ".*\.${target}$" | sort -u > "$save_dir/current.txt"

if [ -f "$save_dir/subdomains.txt" ]; then
    cat "$save_dir/current.txt" "$save_dir/subdomains.txt" | sort -u > "$save_dir/subdomains.txt"
else
    mv "$save_dir/current.txt" "$save_dir/subdomains.txt"
fi

rm -f "$output_dir"/*.txt "$save_dir/current.txt"