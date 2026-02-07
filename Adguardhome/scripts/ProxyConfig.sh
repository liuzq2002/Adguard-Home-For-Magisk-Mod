#!/system/bin/sh
CONFIG_FILE="$(dirname "$0")/config.prop"
[ -f "$CONFIG_FILE" ] && . "$CONFIG_FILE"
LOCAL_DNS="127.0.0.1:${redir_port}"

# 防止重复启动
[ $(pgrep -f "$0" | wc -l) -gt 1 ] && exit

# 在这里添加需要处理的配置文件
# 格式: "配置文件路径|服务重启命令"
PROXY_CONFIGS=(
    "/data/adb/box_bll/clash/*.yaml|/data/adb/box_bll/scripts/box.service restart"
    "/data/adb/box/mihomo/*.yaml|/data/adb/box/scripts/box.service restart"
    "/data/clash/*.yaml|/data/clash/scripts/clash.service -k && /data/clash/scripts/clash.service -s"
)

# 提取共用section列表
ALL_SECTIONS="direct-nameserver: proxy-server-nameserver: nameserver: default-nameserver: \"[Rr][Uu][Ll][Ee]-[Ss][Ee][Tt] \"[Gg][Ee][Oo][Ss][Ii][Tt][Ee] "

# 重启服务并刷新网络
restart_service() {
    $1
    for s in 1 0; do
        settings put global airplane_mode_on $s
        am broadcast -a android.intent.action.AIRPLANE_MODE
    done
}

# 处理代理配置中的订阅
process_proxy_url() {
    [ -z "$PROXY_URL" ] || [ ! -f "$1" ] && return 1
    grep -q "$PROXY_URL" "$1" && return 1
    sed -i "/proxy-providers:/,/url:/s|url:.*|url: \"$PROXY_URL\"|" "$1"
}

# 检查是否是标准情况 
is_standard_config() {
    [ ! -f "$1" ] && return 1
    for section in $ALL_SECTIONS; do
        if grep -q "^[[:space:]]*${section}" "$1"; then
            section_content=$(sed -n "/^[[:space:]]*${section}/,/^[^[:space:]#]/p" "$1")
            has_local_dns=$(echo "$section_content" | grep -c "^[[:space:]]*-[[:space:]]*$LOCAL_DNS")
            other_dns=$(echo "$section_content" | grep "^[[:space:]]*- " | grep -v "^[[:space:]]*- *#" | grep -v "$LOCAL_DNS" | wc -l)
            commented_local_dns=$(echo "$section_content" | grep -c "^[[:space:]]*#.*-[[:space:]]*$LOCAL_DNS")
            [ $commented_local_dns -gt 0 ] && return 1
            [ $has_local_dns -eq 0 ] || [ $other_dns -gt 0 ] && return 1
        fi
    done  
    return 0
}

# 清理配置文件中的旧DNS设置
clean_config() {
    [ ! -f "$1" ] && return 1
    for section in $ALL_SECTIONS; do
        sed -i "/^[[:space:]]*${section}/,/^[^[:space:]]/{/^[[:space:]]*#\{0,1\}[[:space:]]*-[[:space:]]*127\.0\.0\.1:[0-9][0-9]*$/d;s/^\([[:space:]]*\)#[[:space:]]*\(-[[:space:]]*[^#].*\)/\1\2/}" "$1"
    done
}

# 通用配置文件处理
process_config() {
    [ ! -f "$1" ] && return 1
    is_standard_config "$1" && return 1
    clean_config "$1"
    for section in $ALL_SECTIONS; do
        sed -i "/^[[:space:]]*${section}/,/^[[:space:]]*[^[:space:]#-]/{/- $LOCAL_DNS/! s/^\\([[:space:]]*\\)\\(-[[:space:]]*[^#].*\\)/\\1# \\2/;/- $LOCAL_DNS/b;/^[[:space:]]*${section}/{n;:l;/^[[:space:]]*#*[[:space:]]*-/!{n;bl};/- $LOCAL_DNS/!{s/^\\([[:space:]]*\\)\\(#*[[:space:]]*-[[:space:]]*.*\\)/\\1- $LOCAL_DNS\\
\\1# \\2/}}}" "$1"
    done
    grep -q "$LOCAL_DNS" "$1"
}

# 主函数
i=0
while :; do
    IFS='|' read -r config_file restart_cmd <<< "${PROXY_CONFIGS[$i]}"
    need_restart=0
    for config_file in $config_file; do
        [ ! -f "$config_file" ] && continue
        [ "$1" = "--clean" ] && clean_config "$config_file" && continue
        process_proxy_url "$config_file"
        [ $? -eq 0 ] && need_restart=1
        process_config "$config_file"
        [ $? -eq 0 ] && need_restart=1
    done
    if [ "$1" = "--clean" ]; then
        if [ $((i+1)) -eq ${#PROXY_CONFIGS[@]} ]; then
            exit 0
        fi
        i=$((i+1))
        continue
    fi
    [ $need_restart -eq 1 ] && restart_service "$restart_cmd"
    i=$(( (i+1) % ${#PROXY_CONFIGS[@]} ))
    sleep 5
done