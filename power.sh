#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <CPU_USAGE> <MEMORY_USAGE>"
    exit 1
fi

CPU_USAGE=$1
MEMORY_USAGE=$2

if ! [[ $CPU_USAGE =~ ^[0-9]+$ ]]; then
    echo "CPU_USAGE should be a positive integer"
    exit 1
fi

if ! [[ $MEMORY_USAGE =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    echo "MEMORY_USAGE should be a number between 0 and 1"
    exit 1
fi

POWERSTAT_OUTPUT="powerstat_report.txt"


sudo powerstat -d 1 600 > $POWERSTAT_OUTPUT &
POWERSTAT_PID=$!
echo "powerstat started with PID $POWERSTAT_PID"

sleep 2

if ! ps -p $POWERSTAT_PID > /dev/null; then
    echo "Failed to start powerstat."
    exit 1
fi

echo "Starting stress test"
stress --cpu $CPU_USAGE --timeout 600s > cpu_usage.log &
stress --vm 2 --vm-bytes $(awk -v mem_usage=$MEMORY_USAGE '/MemFree/{printf "%d\n", $2 * mem_usage;}' < /proc/meminfo)k --timeout 600s > memory_usage.log &

wait

if ps -p $POWERSTAT_PID > /dev/null; then
    sudo kill $POWERSTAT_PID
fi

wait $POWERSTAT_PID 2>/dev/null

echo "Stress tests and power monitoring completed."
echo "Power consumption data saved to $POWERSTAT_OUTPUT"

if [ ! -f $POWERSTAT_OUTPUT ]; then
    echo "Power consumption data file not found."
    exit 1
fi
