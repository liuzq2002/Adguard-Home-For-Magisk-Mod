#!/system/bin/sh
AGH_DIR="/data/adb/agh"
. "$AGH_DIR/scripts/config.prop"

# DNS重定向规则
iptables -w 2 -t nat -L ADGUARD || { iptables -w 2 -t nat -N ADGUARD && iptables -w 2 -t nat -I OUTPUT -j ADGUARD; }
iptables -w 2 -t nat -F ADGUARD
iptables -w 2 -t nat -I ADGUARD -m owner --uid-owner $adg_user --gid-owner $adg_group -j RETURN
iptables -w 2 -t nat -A ADGUARD -p udp --dport 53 -j REDIRECT --to-ports $redir_port
iptables -w 2 -t nat -A ADGUARD -p tcp --dport 53 -j REDIRECT --to-ports $redir_port

# IPv6 DNS 阻断
ip6tables -w 2 -C OUTPUT -p udp --dport 53 -j DROP && ip6tables -w 2 -D OUTPUT -p udp --dport 53 -j DROP
ip6tables -w 2 -C OUTPUT -p tcp --dport 53 -j DROP && ip6tables -w 2 -D OUTPUT -p tcp --dport 53 -j DROP
ip6tables -w 2 -A OUTPUT -p udp --dport 53 -j DROP
ip6tables -w 2 -A OUTPUT -p tcp --dport 53 -j DROP