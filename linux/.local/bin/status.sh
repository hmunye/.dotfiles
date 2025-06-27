#!/usr/bin/env bash

echo '{"version":1}'
echo '['
echo '[],'

while true; do
    ip=$(ip -4 addr show dev wlp12s0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' || echo "DISCONNECTED")
    clock=$(date '+%a %b %d %H:%M')
    cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8 "%"}')
    ram=$(free -h | awk '/Mem:/ {print $3 "/" $2}' | sed 's/Gi/G/g')
    bt_status=$(hciconfig | grep -q "UP RUNNING" && echo "BT: ON" || echo "BT: OFF")
    volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1)

    echo "["
        echo "  {\"full_text\": \"IP: $ip\", \"name\": \"ip\", \"separator\": false, \"separator_block_width\": 25},"
        echo "  {\"full_text\": \"CPU: $cpu\", \"name\": \"cpu\", \"separator\": false, \"separator_block_width\": 25},"
        echo "  {\"full_text\": \"RAM: $ram\", \"name\": \"ram\", \"separator\": false, \"separator_block_width\": 25},"
        echo "  {\"full_text\": \"$bt_status\", \"name\": \"bluetooth\", \"separator\": false, \"separator_block_width\": 25},"
        echo "  {\"full_text\": \"Vol: $volume\", \"name\": \"volume\", \"separator\": false, \"separator_block_width\": 25},"
        echo "  {\"full_text\": \"$clock\", \"name\": \"clock\"}"
    echo "],"

    sleep 5
done
