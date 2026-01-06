#!/system/bin/sh
SKIPUNZIP=1

# 多语言检测
locale=$( (getprop persist.sys.locale || getprop ro.product.locale || getprop ro.product.locale.language || getprop persist.sys.language) | tr '[:upper:]' '[:lower:]')
ui_print "- 当前语言设置: ${locale:-未检测到}"
case $locale in
  en*) language=en ;;
  *)   language=zh ;;
esac
i18n_print() {
  [ "$language" = "zh" ] && ui_print "$2" || ui_print "$1"
}

# 检测所有Hosts模块
i18n_print "- Checking for Hosts modules" "- 正在检测Hosts模块"
found_hosts=false;for module in /data/adb/modules/*;do [ -f "$module/system/etc/hosts" ]&&[ -f "$module/module.prop" ]&&{ [ "$found_hosts" = false ]&&i18n_print "- Found Hosts modules:" "- 发现以下Hosts模块:"&&found_hosts=true;ui_print "  $(grep_prop name "$module/module.prop")";};done
[ "$found_hosts" = true ]&&{ i18n_print "- Please remove all Hosts modules before installing AdGuardHome for $ARCH." "- 请先卸载所有Hosts模块再安装AdGuardHome。";i18n_print "- Installation aborted." "- 安装已中止。";abort;}
i18n_print "- Installing AdGuardHome" "- 正在安装 AdGuardHome"

AGH_DIR="/data/adb/agh"
BIN_DIR="$AGH_DIR/bin"
SCRIPT_DIR="$AGH_DIR/scripts"
BACKUP_DIR="$AGH_DIR/backup"
PID_FILE="$BIN_DIR/agh_pid"
PROXY_SCRIPT="$AGH_DIR/scripts/ProxyConfig.sh"

i18n_print "- Extracting module files" "- 正在解压模块基本文件"
for file in uninstall.sh module.prop service.sh action.sh; do
  unzip -o "$ZIPFILE" "$file" -d "$MODPATH"
done

# 检查并停止运行中的进程
i18n_print "- Stopping all AdGuard Home processes" "- 正在终止AdGuard Home进程"
pkill -9 -f "AdGuardHome"
[ -f "$PID_FILE" ] && rm -f "$PID_FILE"
sleep 1

# 正在停止NoAdsService
[ -f "$AGH_DIR/scripts/NoAdsService.sh" ] && {
    i18n_print "- Stopping NoAdsService process" "- 正在终止NoAdsService进程"
    pkill -9 -f "NoAdsService"
    sleep 1
}

# 正在停止ProxyConfig
[ -f "$AGH_DIR/scripts/ProxyConfig.sh" ] && {
    i18n_print "- Stopping ProxyConfig process" "- 正在终止ProxyConfig进程"
    pkill -9 -f "ProxyConfig"
    sleep 1
}

# 删除被锁定的残留文件
[ -f "$AGH_DIR/scripts/NoAdsService.sh" ] && {
    i18n_print "- Removing locked residual files" "- 正在删除被锁定的残留文件"
    local c=0 u=0 p;while IFS= read -r p;do [ -n "$p" ]&&[ -e "$p" ]&&while IFS= read -r f;do c=$((c+1));if [ -d "$f" ];then lsattr -d "$f" |grep -q "i-"&&{ chattr -i "$f";rmdir "$f"&&u=$((u+1));} else lsattr "$f" |grep -q "i-"&&{ chattr -i "$f";rm -f "$f";u=$((u+1));};fi;done< <(find "$p" \( -type f -o -type d \));done< <(grep 'block_ad' "$AGH_DIR/scripts/NoAdsService.sh"|grep -o '".*"'|tr -d '"')
    i18n_print "- Removed $u locked files from $c scanned" "- 从 $c 个文件中删除了 $u 个锁定文件"
}

# 检查是否首次安装
if [ -d "$AGH_DIR" ]; then
  i18n_print "- Backing up configuration" "- 正在备份配置文件"
  mkdir -p "$BACKUP_DIR"
  [ -f "$BIN_DIR/AdGuardHome.yaml" ] && cp -f "$BIN_DIR/AdGuardHome.yaml" "$BACKUP_DIR/"
  [ -f "$SCRIPT_DIR/config.prop" ] && cp -f "$SCRIPT_DIR/config.prop" "$BACKUP_DIR/"
  [ -f "$SCRIPT_DIR/NoAdsService.sh" ] && cp -f "$SCRIPT_DIR/NoAdsService.sh" "$BACKUP_DIR/"
fi

# 清除旧模块残留
rm -rf "$AGH_DIR/ifw" "$AGH_DIR/scripts"

# 创建目录并解压文件
mkdir -p "$AGH_DIR" "$BIN_DIR" "$SCRIPT_DIR" "$BACKUP_DIR"
i18n_print "- Extracting AdGuardHome files" "- 正在解压 AdGuardHome 文件"
unzip -o "$ZIPFILE" "scripts/*" -d "$AGH_DIR"
unzip -o "$ZIPFILE" "bin/*" -d "$AGH_DIR"
i18n_print "- Setting permissions" "- 设置权限"
find "$AGH_DIR" -type d -exec chmod 0700 {} \;
chmod +x "$BIN_DIR/AdGuardHome" 
chmod +x "$SCRIPT_DIR"/*.sh
chown root:net_raw "$BIN_DIR/AdGuardHome"
i18n_print "- Installation complete. Reboot device." "- 安装完成，请重启设备。"