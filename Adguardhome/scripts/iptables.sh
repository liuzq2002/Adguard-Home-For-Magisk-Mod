#!/system/bin/sh
AGH_DIR="/data/adb/agh"
. "$AGH_DIR/scripts/config.prop"

# DNS重定向规则
case $1 in
enable)
    [ "$enable_iptables" = true -o "$enable_iptables" = 1 ] && {
        iptables -w 2 -t nat -L ADGUARD  2>&1 || { iptables -w 2 -t nat -N ADGUARD && iptables -w 2 -t nat -I OUTPUT -j ADGUARD; }
        iptables -w 2 -t nat -F ADGUARD
        iptables -w 2 -t nat -A ADGUARD -p udp --dport 53 -j REDIRECT --to-ports $redir_port
        iptables -w 2 -t nat -A ADGUARD -p tcp --dport 53 -j REDIRECT --to-ports $redir_port

# IPv6 DNS阻断
        [ "$block_ipv6_dns" = true -o "$block_ipv6_dns" = 1 ] && {
            ip6tables -w 2 -C OUTPUT -p udp --dport 53 -j DROP && ip6tables -w 2 -D OUTPUT -p udp --dport 53 -j DROP
            ip6tables -w 2 -C OUTPUT -p tcp --dport 53 -j DROP && ip6tables -w 2 -D OUTPUT -p tcp --dport 53 -j DROP
            ip6tables -w 2 -A OUTPUT -p udp --dport 53 -j DROP
            ip6tables -w 2 -A OUTPUT -p tcp --dport 53 -j DROP
        }
    }
    ;;
disable)

# 清理DNS规则
    [ "$enable_iptables" = true -o "$enable_iptables" = 1 ] && {
        iptables -w 2 -t nat -C OUTPUT -j ADGUARD && iptables -w 2 -t nat -D OUTPUT -j ADGUARD
        iptables -w 2 -t nat -F ADGUARD
        iptables -w 2 -t nat -X ADGUARD
        [ "$block_ipv6_dns" = true -o "$block_ipv6_dns" = 1 ] && {
            ip6tables -w 2 -C OUTPUT -p udp --dport 53 -j DROP && ip6tables -w 2 -D OUTPUT -p udp --dport 53 -j DROP
            ip6tables -w 2 -C OUTPUT -p tcp --dport 53 -j DROP && ip6tables -w 2 -D OUTPUT -p tcp --dport 53 -j DROP
        }
    }
    ;;
*)
    echo "Usage: $0 {enable|disable}"
    ;;
esac