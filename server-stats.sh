#!/bin/bash

# server-stats.sh
# Author: Beksulton
# Description: Display basic server performance statistics

echo "======================================"
echo "        SERVER PERFORMANCE STATS      "
echo "======================================"

# Stretch: OS version & uptime
echo "OS Version: $(lsb_release -d 2>/dev/null | cut -f2 || cat /etc/*release | head -n 1)"
echo "Uptime: $(uptime -p)"
echo "Load Average: $(uptime | awk -F'load average:' '{ print $2 }')"
echo "Logged in users: $(who | wc -l)"
echo

# CPU Usage
echo "----- CPU Usage -----"
mpstat 1 1 | awk '/Average:/ {printf "CPU Usage: %.2f%%\n", 100 - $NF}' 2>/dev/null || \
top -bn1 | grep "Cpu(s)" | awk '{print "CPU Usage: " 100 - $8 "%"}'
echo

# Memory Usage
echo "----- Memory Usage -----"
free -h | awk '/Mem:/ {printf "Used: %s / Total: %s (%.2f%%)\n", $3, $2, $3/$2 * 100}'
echo

# Disk Usage
echo "----- Disk Usage -----"
df -h --total | awk '/total/ {printf "Used: %s / Total: %s (%s Used)\n", $3, $2, $5}'
echo

# Top 5 processes by CPU
echo "----- Top 5 Processes by CPU Usage -----"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
echo

# Top 5 processes by Memory
echo "----- Top 5 Processes by Memory Usage -----"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6
echo

# Stretch: Failed login attempts (needs sudo for /var/log)
if [ -f /var/log/auth.log ]; then
    echo "----- Failed Login Attempts (Last 10) -----"
    sudo grep "Failed password" /var/log/auth.log | tail -n 10
    echo
fi

echo "======================================"
echo "         End of Report"
echo "======================================"

