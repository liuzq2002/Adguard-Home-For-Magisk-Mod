#!/system/bin/sh
SCRIPTS_DIR="/data/adb/agh/scripts"

# 静默运行
exec 0</dev/null
exec 1>/dev/null
exec 2>/dev/null

# 防止重复启动
[ "$(pgrep -f "$0" | wc -l)" -gt 1 ] && exit

# 清空IFW系统目录
{
    rm -rf /data/system/ifw
    mkdir -p /data/system/ifw
    rm -rf /data/adb/agh/ifw
} 2>/dev/null

# 广告屏蔽核心函数
block_ad() {
        local target="$1"
        if [ -f "$target" ] && [ ! -s "$target" ] && (lsattr "$target" 2>/dev/null | grep -q "i"); then
            return 0
        fi        
        rm -rf "$target" 2>/dev/null
        touch "$target" 2>/dev/null
        chattr +i "$target" 2>/dev/null
  }

# 添加完屏蔽路径以后必须重启手机生效
    # 美团外卖
    block_ad "/data/data/com.sankuai.meituan.takeoutnew/files/cips/common/waimai/assets/ad"
    block_ad "/data/media/0/Android/data/com.sankuai.meituan.takeoutnew/files/cips/common/waimai/assets/promotion"
    
    # 知乎App
    block_ad "/data/data/com.zhihu.android/files/ad"
    
    # 哔哩哔哩
    block_ad "/data/data/tv.danmaku.bili/files/res_cache"
    block_ad "/data/data/tv.danmaku.bili/files/update"
    block_ad "/data/data/tv.danmaku.bili/app_mod_resource"
    block_ad "/data/data/com.bilibili.app.in/app_mod_resource"
    
    # 中国广电
    block_ad "/data/data/com.ai.obc.cbn.app/files/splashShow"
    
    #酷我音乐
    block_ad "/data/media/0/Android/data/cn.kuwo.player/files/KuwoMusic/.screenad"
    block_ad "/data/data/cn.kuwo.player/app_adnet"
    block_ad "/data/media/0/Android/data/cn.kuwo.player/files/KuwoMusic/.ad"
    
    #网易云音乐
    block_ad "/data/media/0/Android/data/com.netease.cloudmusic/cache/Ad"
    block_ad "/data/data/com.netease.cloudmusic/cache/MusicWebApp"    
    
    #大麦App
    block_ad "/data/data/cn.damai/files/ad_dir"
    
    #顺丰速递
    block_ad "/data/data/com.sf.activity/files/openScreenADsImg"
    
    #丰云行App
    block_ad "/data/media/0/Android/data/com.yongyou/files/Pictures"
    
    #猫耳FM
    block_ad "/data/data/cn.missevan/cache/splash"
    
    #小米有品
    block_ad "/data/data/com.xiaomi.youpin/cache/image_manager_disk_cache"
    
    #小爱音箱
    block_ad "/data/media/0/Android/data/com.xiaomi.mico/files/log/VoipSdk"
    
    #高德地图
    block_ad "/data/data/com.autonavi.minimap/files/LaunchDynamicResource"
    block_ad "/data/media/0/Android/data/com.autonavi.minimap/cache/ajxFileDownload"
    
    #抖音App
    block_ad "/data/data/com.ss.android.ugc.aweme/files/im_common_resource/common_resource/scene_strategy/incentive_chat_group_panel_alpha_video_festival"

# 守护ModuleMOD.sh
while true; do
  if ! pgrep -f "ModuleMOD\.sh" >/dev/null; then
    exec sh "$SCRIPTS_DIR/ModuleMOD.sh" &
  fi

# 延迟启动
  sleep 5
done  