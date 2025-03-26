#!/system/bin/sh

AGH_DIR="/data/adb/agh"
source "$AGH_DIR/scripts/config.sh"

# 应用/清理规则
apply_iptables_rules() {
[ "$enable_iptables" != "true" ] && [ "$enable_iptables" != "1" ] && return
if [ "$1" = "-A" ]; then
$iptables -t nat -N ADGUARD 2>/dev/null
$iptables -t nat -F ADGUARD 2>/dev/null
handle_uid_rules
handle_dns_redirection
$iptables -t nat -C OUTPUT -j ADGUARD 2>/dev/null || $iptables -t nat -A OUTPUT -j ADGUARD
return
fi
$iptables -t nat -D OUTPUT -j ADGUARD 2>/dev/null
$iptables -t nat -F ADGUARD 2>/dev/null
$iptables -t nat -X ADGUARD 2>/dev/null
$ip6tables -D OUTPUT -p udp -m multiport --dports 53 -j DROP 2>/dev/null
$ip6tables -D OUTPUT -p tcp -m multiport --dports 53 -j DROP 2>/dev/null
}

# DNS 重定向
handle_dns_redirection() {
[ "$enable_iptables" != "true" ] && [ "$enable_iptables" != "1" ] && return
$iptables -t nat -N ADGUARD 2>/dev/null
$iptables -t nat -F ADGUARD 2>/dev/null
$iptables -t nat -A ADGUARD -p udp -m multiport --dports 53 -j REDIRECT --to-ports "$redir_port"
$iptables -t nat -A ADGUARD -p tcp -m multiport --dports 53 -j REDIRECT --to-ports "$redir_port"
if [ "$block_ipv6_dns" = "true" ] || [ "$block_ipv6_dns" = "1" ]; then
$ip6tables -A OUTPUT -p udp -m multiport --dports 53 -j DROP
$ip6tables -A OUTPUT -p tcp -m multiport --dports 53 -j DROP
fi
}

# 应用 UID 规则
handle_uid_rules() {
[ "$enable_iptables" != "true" ] && [ "$enable_iptables" != "1" ] && return
uids=$( [ "${#packages_list[@]}" -gt 0 ] && grep -E "$(IFS="|"; echo "${packages_list[*]}")" /data/system/packages.list | awk '{print $2}' )
$iptables -t nat -A ADGUARD -m owner --uid-owner "$adg_user" --gid-owner "$adg_group" -j RETURN
for uid in $uids; do
rule="-j REDIRECT --to-ports $redir_port"
[ "$use_blacklist" = "true" ] || [ "$use_blacklist" = "1" ] && rule="-j RETURN"
$iptables -t nat -A ADGUARD -m owner --uid-owner "$uid" $rule
done
}

case "$1" in
enable) apply_iptables_rules "-A" ;;
disable) apply_iptables_rules "-D" ;;
*) echo "Usage: $0 {enable|disable}" ;;
esac