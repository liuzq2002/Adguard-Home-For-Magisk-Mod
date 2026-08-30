#!/system/bin/sh
AGH_DIR="/data/adb/agh"
ADGPATH="/data/adb/modules/AdGuardHome"
PROXY_SCRIPT="$AGH_DIR/scripts/ProxyConfig.sh"

# 检查并停止运行中的进程
for i in 1 2; do
    found=0
    for p in /proc/[0-9]*; do
        IFS= read -r cmd < "$p/cmdline"
        case "$cmd" in
            "$AGH_DIR/bin/AdGuardHome"*|*"$AGH_DIR/scripts/"*)
                kill -9 "${p#/proc/}"
                found=1
                ;;
        esac
    done
    [ "$found" -eq 0 ] && break
    sleep 1
done

# 还原代理模块修改
[ -f "$PROXY_SCRIPT" ] && "$PROXY_SCRIPT" --clean

# 清理iptables规则残留
iptables -w 2 -t nat -D OUTPUT -j ADGUARD
iptables -w 2 -t nat -F ADGUARD
iptables -w 2 -t nat -X ADGUARD
ip6tables -w 2 -D OUTPUT -p udp --dport 53 -j DROP
ip6tables -w 2 -D OUTPUT -p tcp --dport 53 -j DROP
iptables -w 2 -D OUTPUT -p tcp --dport 853 -j DROP
iptables -w 2 -D OUTPUT -p udp --dport 853 -j DROP
ip6tables -w 2 -D OUTPUT -p tcp --dport 853 -j DROP
ip6tables -w 2 -D OUTPUT -p udp --dport 853 -j DROP

# 解除锁定并删除残留文件
grep 'block_ad' "$AGH_DIR/scripts/NoAdsService.sh"|grep -o '".*"'|tr -d '"'|while IFS= read -r p;do [ -n "$p" ]&&[ -e "$p" ]&&find "$p" \( -type f -o -type d \) |while IFS= read -r f;do if [ -d "$f" ];then lsattr -d "$f"|grep -q "i-"&&{ chattr -i "$f";rmdir "$f";};else lsattr "$f"|grep -q "i-"&&{ chattr -i "$f";rm -f "$f";};fi;done;done

# 解除脚本防篡改保护
find "$AGH_DIR/scripts" "$ADGPATH" -type f -name "*.sh" -exec chattr -i {} \;

# 删除AGH残留目录
[ -d "$AGH_DIR" ] && rm -rf "$AGH_DIR"
[ -d "$ADGPATH" ] && rm -rf "$ADGPATH"