To parse the output of 'waf_details.txt' into a CSV, run this one-liner in the terminal:
$ awk -F" : " '{gsub(/\x1b\[[0-9;]*m/,"",$2); print $1 "," $2}' waf_details.txt > waf_details.csv

# MassH0wl

MassH0wl is a lightweight Bash script that automates the use of wafw00f on a list of domains. It helps you quickly determine whether a target is protected by a Web Application Firewall (WAF) or not, and organizes the results for further analysis.

## Overview

The script processes a list of targets (IP addresses, domains, or subdomains) from an input file (`newdomains.txt`) and classifies each target based on the wafw00f output into one of the following categories:
- **With WAF:** Targets where a WAF is detected.
- **Without WAF:** Targets where no WAF is detected.
- **Down:** Targets that are unreachable or appear to be down.
- **WAF Details:** Detailed information about the detected WAF for further review.

## How It Works

1. **Input Handling:**  
   The script reads targets from `newdomains.txt`, ensuring that any Windows-style carriage returns are removed.

2. **Running wafw00f:**  
   For each target, the script runs the `wafw00f` command and captures its output.

3. **Output Analysis:**  
   - If the output includes the phrase `"appears to be down"`, the target is recorded in `down.txt`.
   - If the output contains a line starting with `[+] The site`, it indicates a WAF is present. The target is logged in `with_waf.txt`, and the script extracts the WAF name—saving this detail in `waf_details.txt`.
   - If the output mentions `"no waf detected"`, the target is saved in `without_waf.txt`.
   - If none of these conditions are met, the script treats the result as unclear and logs the target as down.

4. **Results Summary:**  
   After processing all targets, the script displays a summary of the results by indicating which files contain the targets with WAFs, without WAFs, detailed WAF information, or that are down.

## Prerequisites
- **wafw00f:** Ensure wafw00f is installed and available in your system's PATH.

## Setup and Usage

1. **Prepare the Input File:**
   - Create a file named `newdomains.txt` in the same directory as `massh0wl.sh`.
   - Add one target per line (e.g., domain, IP address, or subdomain).

2. **Run the Script:**
   - Open your terminal and navigate to the project directory.
   - Make the script executable:
     ```bash
     chmod +x massh0wl.sh
     ```
   - Run the script:
     ```bash
     ./massh0wl.sh
     ```

3. **Review the Results:**
   - `with_waf.txt` - Contains targets where a WAF is detected.
   - `without_waf.txt` - Contains targets where no WAF is detected.
   - `waf_details.txt` - Lists targets along with the detected WAF names.
   - `down.txt` - Contains targets that appear to be down or unreachable.

** To parse the output of 'waf_details.txt' into a CSV:
   - run this one-liner in the terminal:
     ```bash
     awk -F" : " '{gsub(/\x1b\[[0-9;]*m/,"",$2); print $1 "," $2}' waf_details.txt > waf_details.csv
     ```


## Ethical Considerations

**Disclaimer:** MassH0wl is intended for use in environments where you have explicit permission to perform security testing. Unauthorized scanning or probing of systems is unethical and may be illegal. Use this tool responsibly.
.
