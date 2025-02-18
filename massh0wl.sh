#!/bin/bash
# run_wafw00f.sh
# This script reads targets (one per line) from everything.txt,
# removes any Windows-style carriage returns, and then runs wafw00f
# on each target. Based on the output, it classifies the target as:
#  - with a WAF (and extracts the WAF name)
#  - without a WAF
#  - or down

# Input file with one IP/domain/subdomain per line.
input_file="newdomains.txt"

# Output files:
with_waf_file="with_waf.txt"
without_waf_file="without_waf.txt"
waf_details_file="waf_details.txt"
down_file="down.txt"

# Clear (or create empty) the output files before starting
> "$with_waf_file"
> "$without_waf_file"
> "$waf_details_file"
> "$down_file"

# Process each target in the input file.
while IFS= read -r target; do
    # Remove carriage return characters (Windows CRLF issue)
    target="${target//$'\r'/}"
    
    # Skip empty lines.
    [[ -z "$target" ]] && continue

    echo "Processing: $target"

    # Run wafw00f and capture both stdout and stderr.
    output=$(wafw00f "$target" 2>&1)

    # 1. If the output indicates the site appears to be down, record it.
    if echo "$output" | grep -qi "appears to be down"; then
        echo "Site appears to be down: $target"
        echo "$target" >> "$down_file"

    # 2. Check for a positive WAF detection.
    elif echo "$output" | grep -Fq "[+] The site"; then
        echo "$target" >> "$with_waf_file"
        # Extract the first detection line.
        waf_line=$(echo "$output" | grep -F "[+] The site" | head -n1)
        # Extract the WAF name between "is behind" and "WAF".
        waf_name=$(echo "$waf_line" | sed -n 's/.*is behind[[:space:]]*\(.*\)[[:space:]]WAF.*/\1/p')
        [ -z "$waf_name" ] && waf_name="Unknown"
        echo "$target : $waf_name" >> "$waf_details_file"

    # 3. Check if the output indicates that no WAF was detected.
    elif echo "$output" | grep -qi "no waf detected"; then
        echo "$target" >> "$without_waf_file"

    # 4. Fallback: if none of the conditions match, log as unclear (treated as down).
    else
        echo "Unclear result, treating as down: $target"
        echo "$target" >> "$down_file"
    fi

done < "$input_file"

echo "Scanning complete."
echo "Results:"
echo "  Targets without WAF: $without_waf_file"
echo "  Targets with WAF:    $with_waf_file"
echo "  WAF details:         $waf_details_file"
echo "  Sites down:          $down_file"
