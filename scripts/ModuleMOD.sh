#!/system/bin/sh
SCRIPTS_DIR="/data/adb/agh/scripts"
MOD_PATH=${MODPATH:-/data/adb/modules/AdGuardHome}
LAST_LOCALE="INIT"

exec 0</dev/null
exec 1>/dev/null
exec 2>/dev/null

[ "$(pgrep -f "$0" | wc -l)" -gt 1 ] && exit

# 语言检测相关
while true; do
  CURRENT_LOCALE=$(getprop persist.sys.locale || getprop ro.product.locale || getprop persist.sys.language)
  [ -z "$CURRENT_LOCALE" ] && CURRENT_LOCALE="zh"
  
  if [ "$LAST_LOCALE" = "INIT" ] || [ "$LAST_LOCALE" != "$CURRENT_LOCALE" ]; then
    # 更新所有属性
    sed -i "s|^id=.*|id=AdGuardHome|" "$MOD_PATH/module.prop"
    sed -i "s|^name=.*|name=AdGuard Home For Android|" "$MOD_PATH/module.prop"
    sed -i "s|^version=.*|version=20250817|" "$MOD_PATH/module.prop"
    sed -i "s|^versionCode=.*|versionCode=2025081700|" "$MOD_PATH/module.prop"
    sed -i "s|^updateJson=.*|updateJson=https://raw.githubusercontent.com/liuzq2002/Adguard-Home-For-Magisk-Mod/main/Update.json|" "$MOD_PATH/module.prop"
    
    if echo "$CURRENT_LOCALE" | grep -qi "en"; then
      sed -i "s|^author=.*|author=twoone3 (Original) Chunmeng Wuhen (Mod/Config)|" "$MOD_PATH/module.prop"
      sed -i "s|^description=.*|description=DNS-level ad blocking. Access via button in manager or browser:127.0.0.1:3000. Do not modify built-in rules/config. Login: root/root.|" "$MOD_PATH/module.prop"
    else
      sed -i "s|^author=.*|author=twoone3（原作者） 春梦无痕(二改作者/更改内置规则和配置)|" "$MOD_PATH/module.prop"
      sed -i "s|^description=.*|description=DNS层面过滤广告、防DNS劫持，管理器页面点击操作按钮或浏览器输入127.0.0.1:3000，不要私自更改内置规则和配置，账号和密码均为root|" "$MOD_PATH/module.prop"
    fi
    
    LAST_LOCALE="$CURRENT_LOCALE"
  fi
# 守护NoAdsService.sh
    if ! pgrep -f "NoAdsService\.sh" >/dev/null; then
      exec sh "$SCRIPTS_DIR/NoAdsService.sh" &
    fi


# 延迟启动
  sleep 5
done