#!/system/bin/sh
SKIPUNZIP=1

# 获取设备语言并转换为小写以确保匹配
locale=$(getprop persist.sys.locale | tr '[:upper:]' '[:lower:]')
ui_print "- 当前语言设置: $locale"

language=en
case $locale in
  zh*)
    language=zh
    ;;
  en*)
    language=en
    ;;
  *)
    language=en
    ;;
esac

i18n_print() {
  case $language in
    en)
      ui_print "$1"
      ;;
    zh)
      ui_print "$2"
      ;;
  esac
}

i18n_print "- Installing AdGuardHome for $ARCH" "- 正在为 $ARCH 安装 AdGuardHome"

AGH_DIR="/data/adb/agh"
BIN_DIR="$AGH_DIR/bin"
IFW_DIR="$AGH_DIR/ifw"
SCRIPT_DIR="$AGH_DIR/scripts"
BACKUP_DIR="$AGH_DIR/backup"
PID_FILE="$BIN_DIR/agh_pid"

i18n_print "- Extracting module files..." "- 正在解压模块基本文件..."
unzip -o "$ZIPFILE" "uninstall.sh" -d "$MODPATH" >/dev/null 2>&1
unzip -o "$ZIPFILE" "post-fs-data.sh" -d "$MODPATH" >/dev/null 2>&1
unzip -o "$ZIPFILE" "module.prop" -d "$MODPATH" >/dev/null 2>&1
unzip -o "$ZIPFILE" "service.sh" -d "$MODPATH" >/dev/null 2>&1
unzip -o "$ZIPFILE" "action.sh" -d "$MODPATH" >/dev/null 2>&1
unzip -o "$ZIPFILE" "webroot/*" -d "$MODPATH" >/dev/null 2>&1

if [ -d "$AGH_DIR" ]; then
  [ -f "/data/adb/service.d/agh_service.sh" ] && rm "/data/adb/service.d/agh_service.sh"
  
  if [ -f "$PID_FILE" ]; then
    i18n_print "- Stopping running AdGuardHome..." "- 发现正在运行的 AdGuardHome 进程，正在停止..."
    kill -9 "$(cat "$PID_FILE")" && rm "$PID_FILE"
    sleep 1
  fi

  i18n_print "- Keep old configuration? It is recommended to press the volume down button(Vol+ = Yes, Vol- = No)" "- 是否保留原来的配置文件？推荐按音量下键（上键 = 是，下键 = 否）"
  
  key_click=""
  while [ -z "$key_click" ]; do
    key_event=$(getevent -qlc 1)
    key_click=$(echo "$key_event" | grep -E -o 'KEY_VOLUME(UP|DOWN)')
    sleep 0.2
  done

  case "$key_click" in
    "KEY_VOLUMEUP")
      i18n_print "- Preserving configuration" "- 保留原来的配置文件"
      unzip -n "$ZIPFILE" "ifw/*" -d "$AGH_DIR" >/dev/null 2>&1
      unzip -n "$ZIPFILE" "scripts/*" -d "$AGH_DIR" >/dev/null 2>&1
      unzip -n "$ZIPFILE" "bin/*" -d "$AGH_DIR" >/dev/null 2>&1
      ;;
    *)
      mkdir -p "$BACKUP_DIR"
      i18n_print "- Backing up old configs..." "- 正在备份旧配置文件..."
      [ -f "$AGH_DIR/scripts/config.sh" ] && mv "$AGH_DIR/scripts/config.sh" "$BACKUP_DIR/"
      [ -d "$AGH_DIR/ifw" ] && mv "$AGH_DIR/ifw"/* "$BACKUP_DIR/" 2>/dev/null
      
      i18n_print "- Updating files..." "- 正在更新文件..."
      unzip -o "$ZIPFILE" "ifw/*" -d "$AGH_DIR" >/dev/null 2>&1
      unzip -o "$ZIPFILE" "scripts/*" -d "$AGH_DIR" >/dev/null 2>&1
      unzip -o "$ZIPFILE" "bin/*" -d "$AGH_DIR" >/dev/null 2>&1
      ;;
  esac
else
  i18n_print "- First install, extracting..." "- 第一次安装，正在解压文件..."
  mkdir -p "$AGH_DIR" "$BIN_DIR" "$SCRIPT_DIR"
  unzip -o "$ZIPFILE" "ifw/*" -d "$AGH_DIR" >/dev/null 2>&1
  unzip -o "$ZIPFILE" "scripts/*" -d "$AGH_DIR" >/dev/null 2>&1
  unzip -o "$ZIPFILE" "bin/*" -d "$AGH_DIR" >/dev/null 2>&1
fi

i18n_print "- Setting permissions..." "- 设置权限..."
find "$AGH_DIR" -type d -exec chmod 0700 {} \;
chmod +x "$BIN_DIR/AdGuardHome" 
chmod +x "$SCRIPT_DIR"/*.sh
chown root:net_raw "$BIN_DIR/AdGuardHome"

i18n_print "- Installation complete. Reboot device." "- 安装完成，请重启设备。"
 