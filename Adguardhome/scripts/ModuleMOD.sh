#!/system/bin/sh
MOD_PATH=${MODPATH:-/data/adb/modules/AdGuardHome}
LAST_LOCALE="INIT"

# 防止重复启动
[ $(pgrep -f "$0" | wc -l) -gt 1 ] && exit

# 语言检测相关
while true; do
  CURRENT_LOCALE=$(getprop persist.sys.locale || getprop ro.product.locale || getprop persist.sys.language)
  [ -z "$CURRENT_LOCALE" ] && CURRENT_LOCALE="zh"
  if [ "$LAST_LOCALE" = "INIT" ] || [ "$LAST_LOCALE" != "$CURRENT_LOCALE" ]; then

    # 根据语言设置变量
    case "$CURRENT_LOCALE" in *[eE][nN]*)
      AUTHOR="ChunmengWuhen (branch/Config)"
      DESC="DNS-level ad blocking. Access via button in manager or browser:127.0.0.1:3000. Do not modify built-in rules/config. Login: root/root."
      ;; *)
      AUTHOR="春梦无痕（分支作者/更改内置规则和配置）"
      DESC="DNS层面过滤广告、防DNS劫持，管理器页面点击操作按钮或浏览器输入127.0.0.1:3000，不要私自更改内置规则和配置，账号和密码均为root"
    esac

    # 开机时属性更新
    content=$(printf '%s\n' \
      "id=AdGuardHome" \
      "name=AdGuard Home For Android" \
      "version=20260206" \
      "versionCode=2026020600" \
      "author=$AUTHOR" \
      "description=$DESC" \
      "updateJson=https://raw.githubusercontent.com/liuzq2002/Adguard-Home-For-Magisk-Mod/main/Update.json")

    # 写入文件
    printf '%s\n' "$content" > "$MOD_PATH/module.prop"
    LAST_LOCALE="$CURRENT_LOCALE"
  fi
 
  # 延迟
  sleep 5
done