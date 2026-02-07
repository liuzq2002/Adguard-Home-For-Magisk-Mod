#!/system/bin/sh
AGH_DIR="/data/adb/agh"
PROXY_SCRIPT="$AGH_DIR/scripts/ProxyConfig.sh"

# 检查并停止运行中的进程
pkill -9 "NoAdsService"
pkill -9 "ProxyConfig"

# 还原代理模块修改
[ -f "$PROXY_SCRIPT" ] && "$PROXY_SCRIPT" --clean

# 解除锁定并删除残留文件
grep 'block_ad' "$AGH_DIR/scripts/NoAdsService.sh"|grep -o '".*"'|tr -d '"'|while IFS= read -r p;do [ -n "$p" ]&&[ -e "$p" ]&&find "$p" \( -type f -o -type d \) |while IFS= read -r f;do if [ -d "$f" ];then lsattr -d "$f"|grep -q "i-"&&{ chattr -i "$f";rmdir "$f";};else lsattr "$f"|grep -q "i-"&&{ chattr -i "$f";rm -f "$f";};fi;done;done

# 删除AGH主目录
[ -d "/data/adb/agh" ] && rm -rf "/data/adb/agh"