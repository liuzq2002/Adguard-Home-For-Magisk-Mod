# 配置路径
export PATH="/system/bin:/system/xbin:$PATH"
export TZ="Asia/Shanghai"

# AdGuardHome 运行用户和用户组
adg_user="root"
adg_group="net_raw"

# AdGuardHome DNS 重定向端口
redir_port=5591

# 是否启用 iptables 规则（true：启用，false：禁用）
enable_iptables=true

# 过滤模式（true：黑名单，false：白名单）
use_blacklist=true

# 是否阻止 IPv6 DNS 请求（true：阻止，false：允许）
block_ipv6_dns=true

# 需要过滤的应用包名列表，需要加英文引号（黑名单模式下拦截，白名单模式下放行）
packages_list=()

# 兼容脚本的 iptables 命令
iptables="iptables -w 64"
ip6tables="ip6tables -w 64"