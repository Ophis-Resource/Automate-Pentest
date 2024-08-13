#!/bin/bash

# Check if the necessary tools are installed
if ! command -v searchsploit &> /dev/null; then
    echo "searchsploit is required but not installed. Please install it."
    exit 1
fi

if ! command -v msfconsole &> /dev/null; then
    echo "msfconsole is required but not installed. Please install Metasploit."
    exit 1
fi

# Function to search in searchsploit
search_in_searchsploit() {
    local cve=$1
    echo "Searching for $cve in Exploit-DB (searchsploit)..."
    searchsploit $cve
}

# Function to search in Metasploit
search_in_metasploit() {
    local cve=$1
    echo "Searching for $cve in Metasploit..."
    msfconsole -q -x "search $cve; exit"
}

# Function to prompt user for double enter
wait_for_double_enter() {
    echo "Press Enter twice to start searching for CVEs..."

    read -r input1
    read -r input2

    if [ -z "$input1" ] && [ -z "$input2" ]; then
        echo "Starting the search..."
    else
        echo "Double Enter not detected. Exiting..."
        exit 1
    fi
}

# Function to process CVEs with a selected tool
process_cves() {
    local tool_choice=$1
    for cve in "${cves[@]}"; do
        echo "---------------------------------------------"
        echo "Processing CVE: $cve"
        echo "---------------------------------------------"

        if [ "$tool_choice" == "searchsploit" ]; then
            search_in_searchsploit $cve
        elif [ "$tool_choice" == "metasploit" ]; then
            search_in_metasploit $cve
        fi

        echo ""
    done
}

# Main script logic
echo "Enter all the CVEs, one per line. Press Enter twice when done."

# Read CVEs from user input into an array
cves=()
while read -r cve; do
    if [ -z "$cve" ]; then
        break
    fi
    cves+=("$cve")
done

# Ask the user whether to use searchsploit or metasploit first
echo "Which tool do you want to use to search for the CVEs first? (Enter 'searchsploit' or 'metasploit')"
read -r tool_choice

if [[ "$tool_choice" != "searchsploit" && "$tool_choice" != "metasploit" ]]; then
    echo "Invalid choice. Please enter 'searchsploit' or 'metasploit'."
    exit 1
fi

# Wait for double enter before proceeding
wait_for_double_enter

# Process CVEs with the selected tool
process_cves "$tool_choice"

# Ask if the user wants to run the search with the second tool
if [ "$tool_choice" == "searchsploit" ]; then
    second_tool="metasploit"
else
    second_tool="searchsploit"
fi

echo "Do you want to search the CVEs using $second_tool as well? (y/n)"
read -r use_second_tool

if [[ "$use_second_tool" == "y" || "$use_second_tool" == "Y" ]]; then
    echo "Searching CVEs using $second_tool..."
    process_cves "$second_tool"
else
    echo "Exiting. No further searches will be performed."
    exit 0
fi
