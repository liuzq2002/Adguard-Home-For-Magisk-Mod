#!/system/bin/sh
AGH_DIR="/data/adb/agh"
PROXY_SCRIPT="$AGH_DIR/scripts/ProxyConfig.sh"

# 检查并停止运行中的进程
pkill -9 -f "NoAdsService"
pkill -9 -f "ProxyConfig"
sleep 1

# 还原代理模块修改
[ -f "$PROXY_SCRIPT" ] && sed -n '/^PROXY_CONFIGS=(/,/^)/p' "$PROXY_SCRIPT" | sed '1d;$d' | while IFS='|' read -r config_file _; do
    [ -z "$config_file" ] && continue
    config_file=$(echo "$config_file" | sed 's/"//g;s/#.*//;s/^[[:space:]]*//;s/[[:space:]]*$//')
    [ ! -f "$config_file" ] && continue   
    sed -i '
    /^[[:space:]]*direct-nameserver:/,/^[^[:space:]]/{/^[[:space:]]*#\{0,1\}[[:space:]]*-[[:space:]]*127\.0\.0\.1:[0-9][0-9]*$/d;s/^\([[:space:]]*\)#[[:space:]]*\(-[[:space:]]*[^#].*\)/\1\2/}
    /^[[:space:]]*proxy-server-nameserver:/,/^[^[:space:]]/{/^[[:space:]]*#\{0,1\}[[:space:]]*-[[:space:]]*127\.0\.0\.1:[0-9][0-9]*$/d;s/^\([[:space:]]*\)#[[:space:]]*\(-[[:space:]]*[^#].*\)/\1\2/}
    /^[[:space:]]*nameserver:/,/^[^[:space:]]/{/^[[:space:]]*#\{0,1\}[[:space:]]*-[[:space:]]*127\.0\.0\.1:[0-9][0-9]*$/d;s/^\([[:space:]]*\)#[[:space:]]*\(-[[:space:]]*[^#].*\)/\1\2/}
    /^[[:space:]]*default-nameserver:/,/^[^[:space:]]/{/^[[:space:]]*#\{0,1\}[[:space:]]*-[[:space:]]*127\.0\.0\.1:[0-9][0-9]*$/d;s/^\([[:space:]]*\)#[[:space:]]*\(-[[:space:]]*[^#].*\)/\1\2/}
    /^[[:space:]]*nameserver-policy:/,/^[^[:space:]]/{/^[[:space:]]*#\{0,1\}[[:space:]]*-[[:space:]]*127\.0\.0\.1:[0-9][0-9]*$/d;s/^\([[:space:]]*\)#[[:space:]]*\(-[[:space:]]*[^#].*\)/\1\2/}
    /^[[:space:]]*\"[Rr][Uu][Ll][Ee]-[Ss][Ee][Tt]/,/^[^[:space:]]/{/^[[:space:]]*#\{0,1\}[[:space:]]*-[[:space:]]*127\.0\.0\.1:[0-9][0-9]*$/d;s/^\([[:space:]]*\)#[[:space:]]*\(-[[:space:]]*[^#].*\)/\1\2/}
    ' "$config_file"
done

# 解除锁定并删除残留文件
grep 'block_ad' "$AGH_DIR/scripts/NoAdsService.sh"|grep -o '".*"'|tr -d '"'|while IFS= read -r p;do [ -n "$p" ]&&[ -e "$p" ]&&find "$p" \( -type f -o -type d \) |while IFS= read -r f;do if [ -d "$f" ];then lsattr -d "$f"|grep -q "i-"&&{ chattr -i "$f";rmdir "$f";};else lsattr "$f"|grep -q "i-"&&{ chattr -i "$f";rm -f "$f";};fi;done;done

# 删除AGH主目录
[ -d "/data/adb/agh" ] && rm -rf "/data/adb/agh"