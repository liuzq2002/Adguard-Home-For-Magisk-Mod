#!/system/bin/sh
SKIPUNZIP=1

# 简化版多语言检测：合并属性检测和小写转换
locale=$( (getprop persist.sys.locale || getprop ro.product.locale || getprop ro.product.locale.language) | tr '[:upper:]' '[:lower:]')
ui_print "- 当前语言设置: ${locale:-未检测到}"

case $locale in
  zh*) language=zh ;;
  *)   language=en ;;
esac

i18n_print() {
  [ "$language" = "zh" ] && ui_print "$2" || ui_print "$1"
}

i18n_print "- Installing AdGuardHome for $ARCH" "- 正在为 $ARCH 安装 AdGuardHome"

AGH_DIR="/data/adb/agh"
BIN_DIR="$AGH_DIR/bin"
IFW_DIR="$AGH_DIR/ifw"
SCRIPT_DIR="$AGH_DIR/scripts"
BACKUP_DIR="$AGH_DIR/backup"
PID_FILE="$BIN_DIR/agh_pid"

i18n_print "- Extracting module files..." "- 正在解压模块基本文件..."
for file in uninstall.sh post-fs-data.sh module.prop service.sh action.sh; do
  unzip -o "$ZIPFILE" "$file" -d "$MODPATH" >/dev/null 2>&1
done

# 检查是否第一次安装
if [ -d "$AGH_DIR" ]; then
  # 升级安装
  if [ -f "$PID_FILE" ]; then
    i18n_print "- Stopping running AdGuardHome..." "- 发现正在运行的 AdGuardHome 进程，正在停止..."
    kill -9 "$(cat "$PID_FILE")" && rm "$PID_FILE"
    sleep 1
  fi

  i18n_print "- Press Volume UP to keep config, default: update and backup in 5s" \
             "- 按音量上键保留配置，默认5秒后覆盖更新并备份"
  
  # 简化的按键检测逻辑
  key_click=""
  end_time=$(( $(date +%s) + 5 ))
  while [ $(date +%s) -lt $end_time ]; do
    getevent -qlc 1 | grep -q 'KEY_VOLUMEUP' && key_click=1 && break
    sleep 0.1
  done

  # 处理配置选项
  if [ "$key_click" = "1" ]; then
    i18n_print "- Preserving configuration" "- 保留配置"
    unzip -n "$ZIPFILE" "ifw/*" -d "$AGH_DIR" >/dev/null 2>&1
    unzip -n "$ZIPFILE" "scripts/*" -d "$AGH_DIR" >/dev/null 2>&1
    unzip -n "$ZIPFILE" "bin/*" -d "$AGH_DIR" >/dev/null 2>&1
  else
    i18n_print "- Updating configuration (default)" "- 更新配置（默认操作）"
    mkdir -p "$BACKUP_DIR"
    [ -f "$AGH_DIR/scripts/config.sh" ] && cp -f "$AGH_DIR/scripts/config.sh" "$BACKUP_DIR/" 2>/dev/null
    [ -d "$AGH_DIR/ifw" ] && cp -Rf "$AGH_DIR/ifw" "$BACKUP_DIR/" 2>/dev/null
    unzip -o "$ZIPFILE" "ifw/*" -d "$AGH_DIR" >/dev/null 2>&1
    unzip -o "$ZIPFILE" "scripts/*" -d "$AGH_DIR" >/dev/null 2>&1
    unzip -o "$ZIPFILE" "bin/*" -d "$AGH_DIR" >/dev/null 2>&1
  fi
else
  # 第一次安装
  i18n_print "- First install, extracting..." "- 第一次安装，正在解压文件..."
  mkdir -p "$AGH_DIR" "$BIN_DIR" "$SCRIPT_DIR" "$BACKUP_DIR"
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