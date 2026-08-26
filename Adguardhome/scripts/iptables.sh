#!/system/bin/sh
AGH_DIR="/data/adb/agh"
. "$AGH_DIR/scripts/config.prop"
MAIN_LOG="$AGH_DIR/agh.log"

# VPN 网卡匹配名。tun+ 会匹配 tun0、tun1 等以 tun 开头的 TUN 网卡。
# 在 config.prop 中设置 vpn_interface="none" 可关闭 VPN 网卡放行。
VPN_INTERFACE="${vpn_interface:-tun+}"
[ "$VPN_INTERFACE" = "none" ] && VPN_INTERFACE=""

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

    # 发往 Clash VPN TUN 网卡的 DNS 请求先交给 Clash 处理。
    # 该规则必须位于 REDIRECT 规则之前，否则应用 DNS 会在进入 VPN 前
    # 被 AdGuardHome 截获。
    [ -n "$VPN_INTERFACE" ] && \
        iptables -w 2 -t nat -I ADGUARD -o "$VPN_INTERFACE" -j RETURN

    # 放行 AdGuardHome 自身的上游 DNS 请求，避免请求再次回到自身。
    iptables -w 2 -t nat -I ADGUARD -m owner --uid-owner "$adg_user" --gid-owner "$adg_group" -j RETURN
    iptables -w 2 -t nat -A ADGUARD -p udp --dport 53 -j REDIRECT --to-ports "$redir_port"
    iptables -w 2 -t nat -A ADGUARD -p tcp --dport 53 -j REDIRECT --to-ports "$redir_port"

    # IPv6 DNS 阻断
    # 在全局 IPv6 DNS 阻断前放行发往 Clash VPN 网卡的 DNS。
    # Clash 自身经物理网卡发出的 IPv6 DNS 仍会被阻断，建议使用 IPv4 上游 DNS。
    ensure_ipv6_vpn_bypass_rules

    # 阻断未进入 Clash VPN 的 IPv6 DNS，防止 DNS 绕过过滤。
    ip6tables -w 2 -A OUTPUT -p udp --dport 53 -j DROP
    ip6tables -w 2 -A OUTPUT -p tcp --dport 53 -j DROP

    # 刷新网络（开关飞行模式）
    for s in 1 0; do
        settings put global airplane_mode_on $s
        am broadcast -a android.intent.action.AIRPLANE_MODE
    done
}

# 规则守护循环
# 仅在规则缺失时添加 IPv6 VPN 放行规则，避免守护循环重复添加规则。
ensure_ipv6_vpn_bypass_rules() {
    [ -z "$VPN_INTERFACE" ] && return 0
    ip6tables -w 2 -C OUTPUT -o "$VPN_INTERFACE" -p udp --dport 53 -j RETURN >/dev/null 2>&1 || \
        ip6tables -w 2 -I OUTPUT 1 -o "$VPN_INTERFACE" -p udp --dport 53 -j RETURN
    ip6tables -w 2 -C OUTPUT -o "$VPN_INTERFACE" -p tcp --dport 53 -j RETURN >/dev/null 2>&1 || \
        ip6tables -w 2 -I OUTPUT 1 -o "$VPN_INTERFACE" -p tcp --dport 53 -j RETURN
}

# 检查所有 VPN 放行规则；任意规则缺失时触发完整修复。
vpn_bypass_rules_present() {
    [ -z "$VPN_INTERFACE" ] && return 0
    iptables -w 2 -t nat -C ADGUARD -o "$VPN_INTERFACE" -j RETURN >/dev/null 2>&1 || return 1
    ip6tables -w 2 -C OUTPUT -o "$VPN_INTERFACE" -p udp --dport 53 -j RETURN >/dev/null 2>&1 || return 1
    ip6tables -w 2 -C OUTPUT -o "$VPN_INTERFACE" -p tcp --dport 53 -j RETURN >/dev/null 2>&1 || return 1
    return 0
}

while true; do
    if ! pgrep -x "AdGuardHome" || \
       ! iptables -w 2 -t nat -C ADGUARD -p udp --dport 53 -j REDIRECT --to-ports "$redir_port" || \
       ! iptables -w 2 -t nat -C ADGUARD -p tcp --dport 53 -j REDIRECT --to-ports "$redir_port" || \
       ! ip6tables -w 2 -C OUTPUT -p udp --dport 53 -j DROP || \
       ! ip6tables -w 2 -C OUTPUT -p tcp --dport 53 -j DROP || \
       ! vpn_bypass_rules_present; then
        setup_rules
    fi
    sleep 5
done &
