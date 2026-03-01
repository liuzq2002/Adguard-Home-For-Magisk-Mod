#!/system/bin/sh
SCRIPTS_DIR="/data/adb/agh/scripts"
MOD_PATH=${MODPATH:-/data/adb/modules/AdGuardHome}
LAST_LOCALE="INIT"

# 防止重复启动
[ "$(pgrep -f "$0" | wc -l)" -gt 1 ] && exit

# 语言检测相关
while true; do
  CURRENT_LOCALE=$(getprop persist.sys.locale || getprop ro.product.locale || getprop persist.sys.language)
  [ -z "$CURRENT_LOCALE" ] && CURRENT_LOCALE="zh" 
  if [ "$LAST_LOCALE" = "INIT" ] || [ "$LAST_LOCALE" != "$CURRENT_LOCALE" ]; then
    if echo "$CURRENT_LOCALE" | grep -qi "en"; then
      sed -i "s|^author=.*|author=ChunmengWuhen (branch/Config)|" "$MOD_PATH/module.prop"
      sed -i "s|^description=.*|description=DNS-level ad blocking. Access via button in manager or browser:127.0.0.1:3000. Do not modify built-in rules/config. Login: root/root.|" "$MOD_PATH/module.prop"
    else
      sed -i "s|^author=.*|author=春梦无痕（分支作者/更改内置规则和配置）|" "$MOD_PATH/module.prop"
      sed -i "s|^description=.*|description=DNS层面过滤广告、防DNS劫持，管理器页面点击操作按钮或浏览器输入127.0.0.1:3000，不要私自更改内置规则和配置，账号和密码均为root|" "$MOD_PATH/module.prop"
    fi    
    LAST_LOCALE="$CURRENT_LOCALE"
  fi

# 延迟启动
  sleep 5
done