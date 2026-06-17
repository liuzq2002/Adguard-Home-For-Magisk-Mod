#!/system/bin/sh
AGH_DIR="/data/adb/agh"
. "$AGH_DIR/scripts/config.prop"
MAIN_LOG="$AGH_DIR/agh.log"

# 防止重复启动
[ $(pgrep -f "$0" | wc -l) -gt 1 ] && exit

setup_rules() {
    # 启动 AdGuardHome（掉进程重启）
    pgrep -x "AdGuardHome" || {
        {
            case "$(getprop persist.sys.locale)" in
                zh*) echo "$(date '+%F %T') AdGuardHome 进程丢失，正在重启..." ;;
                *)   echo "$(date '+%F %T') AdGuardHome process lost, restarting..." ;;
            esac
        } >> "$MAIN_LOG"
        export SSL_CERT_DIR="/system/etc/security/cacerts/"
        "$AGH_DIR/bin/AdGuardHome" --no-check-update &
    }

    # DNS重定向规则
    iptables -w 2 -t nat -L ADGUARD || {
        iptables -w 2 -t nat -N ADGUARD
        iptables -w 2 -t nat -I OUTPUT -j ADGUARD
    }
    iptables -w 2 -t nat -F ADGUARD
    iptables -w 2 -t nat -I ADGUARD -m owner --uid-owner "$adg_user" --gid-owner "$adg_group" -j RETURN
    iptables -w 2 -t nat -A ADGUARD -p udp --dport 53 -j REDIRECT --to-ports "$redir_port"
    iptables -w 2 -t nat -A ADGUARD -p tcp --dport 53 -j REDIRECT --to-ports "$redir_port"

    # IPv6 DNS 阻断
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
    if ! pgrep -x "AdGuardHome" || \
       ! iptables -w 2 -t nat -C ADGUARD -p udp --dport 53 -j REDIRECT --to-ports "$redir_port" || \
       ! iptables -w 2 -t nat -C ADGUARD -p tcp --dport 53 -j REDIRECT --to-ports "$redir_port" || \
       ! ip6tables -w 2 -C OUTPUT -p udp --dport 53 -j DROP || \
       ! ip6tables -w 2 -C OUTPUT -p tcp --dport 53 -j DROP; then
        setup_rules
    fi
    sleep 5
done &