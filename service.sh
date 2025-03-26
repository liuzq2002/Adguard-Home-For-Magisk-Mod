#!/system/bin/sh

SCRIPT_DIR="/data/adb/agh/scripts"

# 等待系统启动完成
while [ "$(getprop init.svc.bootanim)" != "stopped" ]; do sleep 3; done

# 启动 AdGuardHome 和 iptables（如需要）
"$SCRIPT_DIR/service.sh" start
grep -q '^enable_iptables=true' "$SCRIPT_DIR/config.sh" && "$SCRIPT_DIR/iptables.sh" enable

# 启动 inotify 监听
pgrep -f "$SCRIPT_DIR/inotify.sh" || inotifyd "$SCRIPT_DIR/inotify.sh" "$MOD_PATH:d,n" &