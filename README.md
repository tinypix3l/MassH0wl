To parse the output of 'waf_details.txt' into a CSV, run this one-liner in the terminal:
$ awk -F" : " '{gsub(/\x1b\[[0-9;]*m/,"",$2); print $1 "," $2}' waf_details.txt > waf_details.csv
