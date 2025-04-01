#!/system/bin/sh
AGH_DIR="/data/adb/agh"
. "$AGH_DIR/scripts/config.sh"

# DNS重定向
handle_dns() {
case $enable_iptables in
true|1)
for p in udp tcp; do
$iptables -t nat -A ADGUARD -p $p --dport 53 -j REDIRECT --to-ports $redir_port
case $block_ipv6_dns in
true|1) $ip6tables -C OUTPUT -p $p --dport 53 -j DROP >/dev/null 2>&1 ||
$ip6tables -A OUTPUT -p $p --dport 53 -j DROP ;;
esac
done ;;
esac
}

# 规则管理
apply_rules() {
case $enable_iptables in
true|1) case $1 in
-A)
$iptables -t nat -N ADGUARD 2>/dev/null
$iptables -t nat -F ADGUARD
handle_dns
$iptables -t nat -C OUTPUT -j ADGUARD >/dev/null 2>&1 ||
$iptables -t nat -A OUTPUT -j ADGUARD ;;
-D)
$iptables -t nat -D OUTPUT -j ADGUARD >/dev/null 2>&1
$iptables -t nat -F ADGUARD >/dev/null 2>&1
$iptables -t nat -X ADGUARD >/dev/null 2>&1
case $block_ipv6_dns in
true|1) for p in udp tcp; do
$ip6tables -D OUTPUT -p $p --dport 53 -j DROP >/dev/null 2>&1
done ;;
esac ;;
esac ;;
esac
}

# 主入口
case $1 in
enable) apply_rules -A ;;
disable) apply_rules -D ;;
*) echo "Usage: $0 {enable|disable}" ;;
esac