#!/system/bin/sh
CONFIG_FILE="$(dirname "$0")/config.prop"
[ -f "$CONFIG_FILE" ] && . "$CONFIG_FILE"
LOCAL_DNS="127.0.0.1:${redir_port}"

# 防止重复启动
[ $(pgrep -f "$0" | wc -l) -gt 1 ] && exit

# 在这里添加需要处理的配置文件
# 格式: "配置文件路径|服务重启命令"
PROXY_CONFIGS=(
    # Surfing/Clash配置
    "/data/adb/box_bll/clash/*.yaml|/data/adb/box_bll/scripts/box.service restart"
    # Box/Mihomo配置
    "/data/adb/box/mihomo/*.yaml|/data/adb/box/scripts/box.service restart"
    # AkashaProxy/Clash配置
    "/data/clash/*.yaml|/data/clash/scripts/clash.service -k && /data/clash/scripts/clash.service -s"
)

# 重启服务并刷新网络
restart_service() {
    local service_cmd="$1"
    $service_cmd
    for s in 1 0; do
        settings put global airplane_mode_on "$s"
        am broadcast -a android.intent.action.AIRPLANE_MODE
    done
}

# 处理代理配置中的订阅
process_proxy_url() {
    local config_file="$1"
    [ -z "$PROXY_URL" ] || [ ! -f "$config_file" ] && return 1
    grep -q "$PROXY_URL" "$config_file" && return 1
    sed -i "/proxy-providers:/,/url:/{s|url:.*|url: \"$PROXY_URL\"|}" "$config_file"
    return 0
}

# 检查是否是标准情况
is_standard_config() {
    local config_file="$1"
    [ ! -f "$config_file" ] && return 1
    local sections="direct-nameserver: proxy-server-nameserver: nameserver: default-nameserver:"    
    for section in $sections; do
        if grep -q "^[[:space:]]*${section}" "$config_file"; then
            local section_content=$(sed -n "/^[[:space:]]*${section}/,/^[[:space:]]*[^[:space:]#]/p" "$config_file")
            local has_local_dns=$(echo "$section_content" | grep -c "^[[:space:]]*-[[:space:]]*$LOCAL_DNS")
            local other_dns=$(echo "$section_content" | grep "^[[:space:]]*-[[:space:]]*[^#]" | grep -v "^[[:space:]]*-[[:space:]]*$LOCAL_DNS" | wc -l)
            [ $has_local_dns -eq 0 ] || [ $other_dns -gt 0 ] && return 1
        fi
    done    
    return 0
}

# 清理配置文件中的旧DNS设置
clean_config() {
    local config_file="$1"
    [ ! -f "$config_file" ] && return 1
    sed -i '
    /^[[:space:]]*direct-nameserver:/,/^[^[:space:]]/{/^[[:space:]]*#\{0,1\}[[:space:]]*-[[:space:]]*127\.0\.0\.1:[0-9][0-9]*$/d;s/^\([[:space:]]*\)#[[:space:]]*\(-[[:space:]]*[^#].*\)/\1\2/}
    /^[[:space:]]*proxy-server-nameserver:/,/^[^[:space:]]/{/^[[:space:]]*#\{0,1\}[[:space:]]*-[[:space:]]*127\.0\.0\.1:[0-9][0-9]*$/d;s/^\([[:space:]]*\)#[[:space:]]*\(-[[:space:]]*[^#].*\)/\1\2/}
    /^[[:space:]]*nameserver:/,/^[^[:space:]]/{/^[[:space:]]*#\{0,1\}[[:space:]]*-[[:space:]]*127\.0\.0\.1:[0-9][0-9]*$/d;s/^\([[:space:]]*\)#[[:space:]]*\(-[[:space:]]*[^#].*\)/\1\2/}
    /^[[:space:]]*default-nameserver:/,/^[^[:space:]]/{/^[[:space:]]*#\{0,1\}[[:space:]]*-[[:space:]]*127\.0\.0\.1:[0-9][0-9]*$/d;s/^\([[:space:]]*\)#[[:space:]]*\(-[[:space:]]*[^#].*\)/\1\2/}
    /^[[:space:]]*nameserver-policy:/,/^[^[:space:]]/{/^[[:space:]]*#\{0,1\}[[:space:]]*-[[:space:]]*127\.0\.0\.1:[0-9][0-9]*$/d;s/^\([[:space:]]*\)#[[:space:]]*\(-[[:space:]]*[^#].*\)/\1\2/}
    /^[[:space:]]*\"[Rr][Uu][Ll][Ee]-[Ss][Ee][Tt]/,/^[^[:space:]]/{/^[[:space:]]*#\{0,1\}[[:space:]]*-[[:space:]]*127\.0\.0\.1:[0-9][0-9]*$/d;s/^\([[:space:]]*\)#[[:space:]]*\(-[[:space:]]*[^#].*\)/\1\2/}
    ' "$config_file"
}

# 通用配置文件处理
process_config() {
    local config_file="$1"
    [ ! -f "$config_file" ] && return 1
    is_standard_config "$config_file"
    if [ $? -eq 0 ]; then
        return 1
    fi
    clean_config "$config_file"
    sed -i "
    /^[[:space:]]*direct-nameserver:/,/^[[:space:]]*[^[:space:]#]/{
        /- $LOCAL_DNS/! s/^\\([[:space:]]*\\)\\(-[[:space:]]*[^#].*\\)/\\1# \\2/
        /- $LOCAL_DNS/b
        /^[[:space:]]*direct-nameserver:/{n; /- $LOCAL_DNS/!{
            s/^\\([[:space:]]*\\)\\(-[[:space:]]*.*\\)/\\1- $LOCAL_DNS\\
\\1# \\2/
        }}
    }
    /^[[:space:]]*proxy-server-nameserver:/,/^[[:space:]]*[^[:space:]#]/{
        /- $LOCAL_DNS/! s/^\\([[:space:]]*\\)\\(-[[:space:]]*[^#].*\\)/\\1# \\2/
        /- $LOCAL_DNS/b
        /^[[:space:]]*proxy-server-nameserver:/{n; /- $LOCAL_DNS/!{
            s/^\\([[:space:]]*\\)\\(-[[:space:]]*.*\\)/\\1- $LOCAL_DNS\\
\\1# \\2/
        }}
    }
    /^[[:space:]]*nameserver:/,/^[[:space:]]*[^[:space:]#]/{
        /- $LOCAL_DNS/! s/^\\([[:space:]]*\\)\\(-[[:space:]]*[^#].*\\)/\\1# \\2/
        /- $LOCAL_DNS/b
        /^[[:space:]]*nameserver:/{n; /- $LOCAL_DNS/!{
            s/^\\([[:space:]]*\\)\\(-[[:space:]]*.*\\)/\\1- $LOCAL_DNS\\
\\1# \\2/
        }}
    }
    /^[[:space:]]*default-nameserver:/,/^[[:space:]]*[^[:space:]#]/{
        /- $LOCAL_DNS/! s/^\\([[:space:]]*\\)\\(-[[:space:]]*[^#].*\\)/\\1# \\2/
        /- $LOCAL_DNS/b
        /^[[:space:]]*default-nameserver:/{n; /- $LOCAL_DNS/!{
            s/^\\([[:space:]]*\\)\\(-[[:space:]]*.*\\)/\\1- $LOCAL_DNS\\
\\1# \\2/
        }}
    }
    /^[[:space:]]*\"[Rr][Uu][Ll][Ee]-[Ss][Ee][Tt]/,/^[[:space:]]*[^[:space:]#]/{
        /- $LOCAL_DNS/! s/^\\([[:space:]]*\\)\\(-[[:space:]]*[^#].*\\)/\\1# \\2/
        /- $LOCAL_DNS/b
        /\"[Rr][Uu][Ll][Ee]-[Ss][Ee][Tt]/{n; /- $LOCAL_DNS/!{
            s/^\\([[:space:]]*\\)\\(-[[:space:]]*.*\\)/\\1- $LOCAL_DNS\\
\\1# \\2/
        }}
    }
    /^[[:space:]]*\"[Gg][Ee][Oo][Ss][Ii][Tt][Ee]:[^\"]*\"[[:space:]]*:/,/^[[:space:]]*[^[:space:]#]/{
        /- $LOCAL_DNS/! s/^\\([[:space:]]*\\)\\(-[[:space:]]*[^#].*\\)/\\1# \\2/
        /- $LOCAL_DNS/b
        /^[[:space:]]*\"[Gg][Ee][Oo][Ss][Ii][Tt][Ee]:[^\"]*\"[[:space:]]*:/{n; /- $LOCAL_DNS/!{
            s/^\\([[:space:]]*\\)\\(-[[:space:]]*.*\\)/\\1- $LOCAL_DNS\\
\\1# \\2/
        }}
    }
    " "$config_file"   
    grep -q "$LOCAL_DNS" "$config_file" && return 0 || return 1
}

# 主函数
i=0
while :; do
    IFS='|' read -r config_file restart_cmd <<< "${PROXY_CONFIGS[$i]}"
    process_proxy_url "$config_file"
    res_sub=$?
    process_config "$config_file"
    res_dns=$?
    if [ $res_sub -eq 0 ] || [ $res_dns -eq 0 ]; then
        restart_service "$restart_cmd"
    fi
    i=$(( (i+1) % ${#PROXY_CONFIGS[@]} ))
    sleep 5
done