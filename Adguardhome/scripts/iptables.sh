#!/system/bin/sh
AGH_DIR="/data/adb/agh"
. "$AGH_DIR/scripts/config.prop"
MAIN_LOG="$AGH_DIR/agh.log"

# 防止重复启动
[ $(pgrep -f "$0" | wc -l) -gt 1 ] && exit

# 检测Adguardhome是否存活
agh_running() {
    for p in /proc/[0-9]*; do
        c=
        IFS= read -r c < "$p/cmdline"
        case "$c" in
        "$AGH_DIR/bin/AdGuardHome"*) return 0 ;;
        esac
    done
    return 1
}

# 启动AdGuardHome
start_agh() {
    {
        case "$(getprop persist.sys.locale)" in
            zh*) echo "$(date '+%F %T') AdGuardHome 进程丢失，正在重启..." ;;
            *)   echo "$(date '+%F %T') AdGuardHome process lost, restarting..." ;;
        esac
    } >> "$MAIN_LOG"
    export SSL_CERT_DIR="/system/etc/security/cacerts/"
    "$AGH_DIR/bin/AdGuardHome" --no-check-update &
}

# 重建iptables规则
rebuild_rules() {
    iptables -w 2 -t nat -L ADGUARD || {
        iptables -w 2 -t nat -N ADGUARD
        iptables -w 2 -t nat -I OUTPUT -j ADGUARD
    }
    iptables -w 2 -t nat -F ADGUARD
    iptables -w 2 -t nat -A ADGUARD -p udp --dport 53 -j REDIRECT --to-ports "$redir_port"
    iptables -w 2 -t nat -A ADGUARD -p tcp --dport 53 -j REDIRECT --to-ports "$redir_port"
    iptables -w 2 -A OUTPUT -p tcp --dport 853 -j DROP
    iptables -w 2 -A OUTPUT -p udp --dport 853 -j DROP
    ip6tables -w 2 -A OUTPUT -p tcp --dport 853 -j DROP
    ip6tables -w 2 -A OUTPUT -p udp --dport 853 -j DROP
    ip6tables -w 2 -A OUTPUT -p udp --dport 53 -j DROP
    ip6tables -w 2 -A OUTPUT -p tcp --dport 53 -j DROP

# 刷新网络（开关飞行模式）
    for s in 1 0; do
        settings put global airplane_mode_on $s
        am broadcast -a android.intent.action.AIRPLANE_MODE
    done
}

# 规则守护循环
while true; do
    . "$AGH_DIR/scripts/config.prop"
    need_restart=0
    agh_running || need_restart=1
    need_fix=0
    iptables -w 2 -t nat -C ADGUARD -p udp --dport 53 -j REDIRECT --to-ports "$redir_port" || need_fix=1
    iptables -w 2 -t nat -C ADGUARD -p tcp --dport 53 -j REDIRECT --to-ports "$redir_port" || need_fix=1
    iptables -w 2 -C OUTPUT -p tcp --dport 853 -j DROP || need_fix=1
    iptables -w 2 -C OUTPUT -p udp --dport 853 -j DROP || need_fix=1
    ip6tables -w 2 -C OUTPUT -p tcp --dport 853 -j DROP || need_fix=1
    ip6tables -w 2 -C OUTPUT -p udp --dport 853 -j DROP || need_fix=1
    ip6tables -w 2 -C OUTPUT -p udp --dport 53 -j DROP || need_fix=1
    ip6tables -w 2 -C OUTPUT -p tcp --dport 53 -j DROP || need_fix=1
    [ $need_restart -eq 1 ] && start_agh
    [ $need_restart -eq 1 ] || [ $need_fix -eq 1 ] && rebuild_rules
    sleep 5
done &