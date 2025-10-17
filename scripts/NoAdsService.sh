#!/system/bin/sh
AGH_DIR="/data/adb/agh"

# 静默运行
exec 0</dev/null
exec 1>/dev/null
exec 2>/dev/null

# 清除旧模块残留
rm -rf "$AGH_DIR/ifw"
rm -rf "$AGH_DIR/scripts/service.sh" 
rm -rf "$AGH_DIR/scripts/inotify.sh"

# 广告屏蔽核心函数
block_ad() {
    [ -f "$1" ] && [ ! -s "$1" ] && lsattr "$1" 2>/dev/null | grep -q "i" && return
    rm -rf "$1" 2>/dev/null; touch "$1" 2>/dev/null; chattr +i "$1" 2>/dev/null
}

# 执行循环
while true; do

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
    block_ad "/data/media/0/Android/data/tv.danmaku.bili/cache/default/journal"
    
    # 中国广电
    block_ad "/data/data/com.ai.obc.cbn.app/files/splashShow"
    
    # 酷我音乐
    block_ad "/data/media/0/Android/data/cn.kuwo.player/files/KuwoMusic/.screenad"
    block_ad "/data/data/cn.kuwo.player/app_adnet"
    block_ad "/data/media/0/Android/data/cn.kuwo.player/files/KuwoMusic/.ad"
    
    # 网易云音乐
    block_ad "/data/media/0/Android/data/com.netease.cloudmusic/cache/Ad"
    block_ad "/data/data/com.netease.cloudmusic/cache/MusicWebApp"    
    
    # 大麦App
    block_ad "/data/data/cn.damai/files/ad_dir"
    
    # 顺丰速递
    block_ad "/data/data/com.sf.activity/files/openScreenADsImg"
    
    # 丰云行App
    block_ad "/data/media/0/Android/data/com.yongyou/files/Pictures"
    
    # 猫耳FM
    block_ad "/data/data/cn.missevan/cache/splash"
    
    # 小米有品
    block_ad "/data/data/com.xiaomi.youpin/cache/image_manager_disk_cache"
    
    # 小爱音箱
    block_ad "/data/media/0/Android/data/com.xiaomi.mico/files/log/VoipSdk"
    block_ad "/data/media/0/Android/data/com.xiaomi.mico/files/data_cache/journal"
    
    # 高德地图
    block_ad "/data/data/com.autonavi.minimap/files/LaunchDynamicResource"
    block_ad "/data/media/0/Android/data/com.autonavi.minimap/cache/ajxFileDownload"
    
    # 抖音App
    block_ad "/data/data/com.ss.android.ugc.aweme/files/im_common_resource/common_resource/scene_strategy/incentive_chat_group_panel_alpha_video_festival"
    
    # 腾讯QQ
    block_ad "/data/media/0/Android/data/com.tencent.mobileqq/files/vas_ad"
    
    # 安居客App
    block_ad "/data/data/com.anjuke.android.app/cache/splash_ad"
    
    # 买单吧App
    block_ad "/data/data/com.bankcomm.maidanba/files/imageCachePath"
    block_ad "/data/data/com.bankcomm.maidanba/files/tabAdsPath"
    
    # 中国移动
    block_ad "/data/data/com.greenpoint.android.mc10086.activity/shared_prefs/default.xml"

# 自动关闭私人DNS
settings get global private_dns_mode | grep off || settings put global private_dns_mode off

# 自动清空IFW文件夹
[ -n "$(ls -A /data/system/ifw/ 2>/dev/null)" ] && rm -rf /data/system/ifw/*

# 专清/data/data卸载残留
find /data/data -maxdepth 1 -type d -name "*==deleted==" -exec sh -c '
    for dir; do
        chattr -R -i "$dir" 2>/dev/null
        rm -rf "$dir"
    done
' _ {} +

# 延迟启动
  sleep 5
done