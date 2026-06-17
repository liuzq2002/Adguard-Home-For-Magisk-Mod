#!/system/bin/sh
SCRIPTS_DIR="/data/adb/agh/scripts"
MOD_PATH=${MODPATH:-/data/adb/modules/AdGuardHome}
LAST_LOCALE="INIT"

# 防止重复启动
[ "$(pgrep -f "$0" | wc -l)" -gt 1 ] && exit

# 语言检测相关
while true; do
  CURRENT_LOCALE=$(getprop persist.sys.locale)
  [ -z "$CURRENT_LOCALE" ] && CURRENT_LOCALE="zh" 
  if [ "$LAST_LOCALE" = "INIT" ] || [ "$LAST_LOCALE" != "$CURRENT_LOCALE" ]; then
    if echo "$CURRENT_LOCALE" | grep -qi "zh"; then
      sed -i "s|^author=.*|author=春梦无痕|" "$MOD_PATH/module.prop"
      sed -i "s|^description=.*|description=DNS层面过滤广告、防DNS劫持，开机时端口随机化，管理器页面点击操作按钮进入，不要私自更改内置规则和配置，账号和密码均为root|" "$MOD_PATH/module.prop"
    else
      sed -i "s|^author=.*|author=ChunmengWuhen |" "$MOD_PATH/module.prop"
      sed -i "s|^description=.*|description=DNS-level ad blocking and anti-DNS hijacking. Port Randomization at Startup. Click the action button on the Manager page to proceed. Do not modify built-in rules or configuration. login: root/root.|" "$MOD_PATH/module.prop"
    fi    
    LAST_LOCALE="$CURRENT_LOCALE"
fi

# 延迟启动
  sleep 5
done