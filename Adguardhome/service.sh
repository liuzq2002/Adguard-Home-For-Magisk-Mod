#!/system/bin/sh
SCRIPT_DIR="/data/adb/agh/scripts"
AGH_DIR="/data/adb/agh"
BIN_DIR="$AGH_DIR/bin"
PID_FILE="$BIN_DIR/agh_pid"
MAIN_LOG="$AGH_DIR/agh.log"
MODULES_DIR="/data/adb/modules"
AGH_MODULE_PROP="/data/adb/modules/AdGuardHome/module.prop"
export TZ='Asia/Shanghai'
. "$SCRIPT_DIR/config.prop"

# 检查hosts模块并中止启动
for module in "$MODULES_DIR"/*; do 
  [ -d "$module" ] && [ -f "$module/system/etc/hosts" ] && {
    getprop persist.sys.locale | grep -q "zh" && 
      MSG="检测到hosts模块，AdGuardHome启动已中止" DESC="⚠️ AdGuardHome已禁用 - 检测到hosts模块" || 
      MSG="Hosts module detected, AdGuardHome startup aborted" DESC="⚠️ AdGuardHome disabled - Hosts module detected"
    [ -f "$AGH_MODULE_PROP" ] && sed -i "s/description=.*/description=$DESC/" "$AGH_MODULE_PROP"
    [ "$enable_logging" = true -o "$enable_logging" = 1 ] && echo "$(date '+%F %T') [ERROR] $MSG" >> "$MAIN_LOG"
    exit 1
  }
done

# 启动AdGuardHome
export SSL_CERT_DIR="/system/etc/security/cacerts/"
"$BIN_DIR/AdGuardHome" --no-check-update &
echo $! > "$PID_FILE"
sleep 2

# 启动模块附加脚本
"$SCRIPT_DIR/ModuleMOD.sh" &
"$SCRIPT_DIR/NoAdsService.sh" &
"$SCRIPT_DIR/ProxyConfig.sh" &

# 验证AdGuardHome是否启动成功
if ! kill -0 $(cat "$PID_FILE"); then
    [ "$enable_logging" = true -o "$enable_logging" = 1 ] && echo "$(date '+%F %T') AdGuardHome启动失败，尝试重启..." >> "$MAIN_LOG"
    exec "$0"
else
    [ "$enable_logging" = true -o "$enable_logging" = 1 ] && echo "$(date '+%F %T') AdGuardHome 启动成功。" >> "$MAIN_LOG"
fi

# 日志超限时清空
[ "$enable_logging" = true -o "$enable_logging" = 1 ] && [ $(stat -c %s "$MAIN_LOG" || ls -l "$MAIN_LOG" | awk '{print $5}') -ge 102400 ] && : > "$MAIN_LOG"

# 启动iptables
grep -q '^enable_iptables=true' "$SCRIPT_DIR/config.prop" && "$SCRIPT_DIR/iptables.sh" enable