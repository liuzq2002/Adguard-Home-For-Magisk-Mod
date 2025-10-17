#!/system/bin/sh
# 删除AGH主目录
[ -d "/data/adb/agh" ] && rm -rf "/data/adb/agh"

# 解除锁定并删除屏蔽文件
chattr_path() {
    [ -e "$1" ] && chattr -i "$1" 2>/dev/null
    rm -rf "$1"
}

# 应用路径处理
# 哔哩哔哩
chattr_path "/data/data/tv.danmaku.bili/files/res_cache"
chattr_path "/data/data/tv.danmaku.bili/files/update"
chattr_path "/data/data/tv.danmaku.bili/app_mod_resource"
chattr_path "/data/data/com.bilibili.app.in/app_mod_resource"
chattr_path "/data/media/0/Android/data/tv.danmaku.bili/cache/default/journal"

#知乎
chattr_path "/data/data/com.zhihu.android/files/ad"

# 中国广电
chattr_path "/data/data/com.ai.obc.cbn.app/files/splashShow"

# 美团外卖
chattr_path "/data/data/com.sankuai.meituan.takeoutnew/files/cips/common/waimai/assets/ad"
chattr_path "/data/media/0/Android/data/com.sankuai.meituan.takeoutnew/files/cips/common/waimai/assets/promotion"

# 酷我音乐
chattr_path "/data/media/0/Android/data/cn.kuwo.player/files/KuwoMusic/.screenad"
chattr_path "/data/data/cn.kuwo.player/app_adnet"
chattr_path "/data/media/0/Android/data/cn.kuwo.player/files/KuwoMusic/.ad"

# 网易云音乐
chattr_path "/data/media/0/Android/data/com.netease.cloudmusic/cache/Ad"
chattr_path "/data/data/com.netease.cloudmusic/cache/MusicWebApp"
    
# 大麦App
chattr_path "/data/data/cn.damai/files/ad_dir"
    
# 顺丰速递
chattr_path "/data/data/com.sf.activity/files/openScreenADsImg"
    
# 丰云行App
chattr_path "/data/media/0/Android/data/com.yongyou/files/Pictures"
    
# 猫耳FM
chattr_path "/data/data/cn.missevan/cache/splash"
    
# 小米有品
chattr_path "/data/data/com.xiaomi.youpin/shared_prefs/ad_prf.xml"

# 小爱音箱
chattr_path "/data/media/0/Android/data/com.xiaomi.mico/files/log/VoipSdk"
chattr_path "/data/media/0/Android/data/com.xiaomi.mico/files/data_cache/journal"

# 高德地图
chattr_path "/data/data/com.autonavi.minimap/files/LaunchDynamicResource"
chattr_path "/data/media/0/Android/data/com.autonavi.minimap/cache/ajxFileDownload"

# 抖音App
chattr_path "/data/data/com.ss.android.ugc.aweme/files/im_common_resource/common_resource/scene_strategy/incentive_chat_group_panel_alpha_video_festival"

# 腾讯QQ
chattr_path "/data/media/0/Android/data/com.tencent.mobileqq/files/vas_ad"

# 安居客App
chattr_path "/data/data/com.anjuke.android.app/cache/splash_ad"

# 买单吧App
chattr_path "/data/data/com.bankcomm.maidanba/files/imageCachePath"
chattr_path "/data/data/com.bankcomm.maidanba/files/tabAdsPath"

# 中国移动
chattr_path "/data/data/com.greenpoint.android.mc10086.activity/shared_prefs/default.xml"

exit 0