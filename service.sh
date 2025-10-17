#!/system/bin/sh
SCRIPT_DIR="/data/adb/agh/scripts"
AGH_DIR="/data/adb/agh"
BIN_DIR="$AGH_DIR/bin"
PID_FILE="$BIN_DIR/agh_pid"
MAIN_LOG="$AGH_DIR/agh.log"
export TZ='Asia/Shanghai'

# 所有输出重定向到日志
exec >>"$MAIN_LOG" 2>&1

# 启动 AdGuardHome
export SSL_CERT_DIR="/system/etc/security/cacerts/"
"$BIN_DIR/AdGuardHome" --no-check-update >/dev/null 2>&1 &
echo $! > "$PID_FILE"
sleep 2

# 静默启动ModuleMOD和NoAdsService
"$SCRIPT_DIR/ModuleMOD.sh" >/dev/null 2>&1 &
"$SCRIPT_DIR/NoAdsService.sh" >/dev/null 2>&1 &

# 验证AdGuardHome是否启动成功
if ! kill -0 $(cat "$PID_FILE") 2>/dev/null; then
    echo "$(date '+%F %T') AdGuardHome启动失败，尝试重启..." >> "$MAIN_LOG"
    exec "$0"
else
    echo "$(date '+%F %T') AdGuardHome 启动成功。" >> "$MAIN_LOG"
fi

# 日志超限时清空
check_and_clear_log() {
    [ $(stat -c %s "$1" 2>/dev/null || ls -l "$1" | awk '{print $5}') -ge 102400 ] && : > "$1"
}
check_and_clear_log "$MAIN_LOG"

# 启动 iptables
grep -q '^enable_iptables=true' "$SCRIPT_DIR/config.sh" && "$SCRIPT_DIR/iptables.sh" enable