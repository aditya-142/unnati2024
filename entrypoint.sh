#!/bin/bash
if [ $# -lt 2 ]; then
    echo "Usage: $0 <CPU_USAGE> <MEMORY_USAGE>"
    echo "Example: $0 5 0.5"
    exit 1
fi

exec sudo /usr/local/bin/power.sh "$@"
