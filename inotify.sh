#!/bin/bash

AGH_DIR="/data/adb/agh"
SCRIPT_DIR="$AGH_DIR/scripts"

exec >>"$AGH_DIR/agh.log" 2>&1

# 加载配置并检查必要文件
[[ ! -x "$AGH_DIR/scripts/config.sh" ]] && echo "Error: config.sh not found" >&2 && exit 1
source "$AGH_DIR/scripts/config.sh"

[ "$monitor_file" = "disable" ] && exit 0
: ${enable_iptables=true}

case "$1" in
d|n) 
for script in "$SCRIPT_DIR/service.sh" "$SCRIPT_DIR/iptables.sh"; do
[[ ! -x "$script" ]] && echo "Error: $script not found or not executable" >&2 && exit 1
done
if [ "$1" = "d" ]; then "$SCRIPT_DIR/service.sh" start; [ "$enable_iptables" = true ] && "$SCRIPT_DIR/iptables.sh" enable; 
else "$SCRIPT_DIR/service.sh" stop; [ "$enable_iptables" = true ] && "$SCRIPT_DIR/iptables.sh" disable; fi
;;
*) echo "Usage: $0 {d|n}" >&2 && exit 1 ;;
esac