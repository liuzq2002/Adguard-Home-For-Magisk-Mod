#!/system/bin/sh
AGH_DIR="/data/adb/agh"

# 防止重复启动
[ $(pgrep -f "$0" | wc -l) -gt 1 ] && exit

# 广告屏蔽核心函数
block_ad(){ [ ! -e "$1" ]&&return;lsattr -d "$1"|grep -q "i.*$1"&&return;[ -d "$1" ]&&(rm -rf "$1"&&mkdir -p "$1")&&chattr +i "$1"&&return;[ -f "$1" ]&&> "$1"&&chattr +i "$1"; }

# 执行循环
while :;do

# 添加完屏蔽路径以后必须重启手机生效
    # 美团外卖
    block_ad "/data/data/com.sankuai.meituan.takeoutnew/files/cips/common/waimai/assets/ad"
    block_ad "/data/media/0/Android/data/com.sankuai.meituan.takeoutnew/files/cips/common/waimai/assets/promotion"
    
    # 知乎App
    block_ad "/data/data/com.zhihu.android/files/ad"
    
    # 哔哩哔哩
    block_ad "/data/data/tv.danmaku.bili/files/res_cache"
    block_ad "/data/data/tv.danmaku.bili/files/update"
    block_ad "/data/media/0/Android/data/tv.danmaku.bili/cache/default/journal"
    block_ad "/data/data/tv.danmaku.bili/files/splash2"
    block_ad "/data/data/tv.danmaku.bili/files/splash_top_view"
    block_ad "/data/data/tv.danmaku.bili/files/resmanager_resource_1"
    block_ad "/data/data/tv.danmaku.bili/files/resmanager_resource_2"
    block_ad "/data/data/tv.danmaku.bili/files/resmanager_resource_3"
    
    # 中国广电
    block_ad "/data/data/com.ai.obc.cbn.app/files/splashShow"
    
    # 酷我音乐
    block_ad "/data/media/0/Android/data/cn.kuwo.player/files/KuwoMusic/.screenad"
    block_ad "/data/media/0/Android/data/cn.kuwo.player/files/KuwoMusic/.ad"
    block_ad "/data/media/0/Android/data/cn.kuwo.kwmusichd/files/KwPlayerHD/.screenad"
    
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
    block_ad "/data/data/com.xiaomi.youpin/shared_prefs/ad_prf.xml"
    
    # 小爱音箱
    block_ad "/data/media/0/Android/data/com.xiaomi.mico/files/data_cache/journal"
    
    # 高德地图
    block_ad "/data/data/com.autonavi.minimap/files/LaunchDynamicResource"
    block_ad "/data/data/com.autonavi.minimap/files/splash"
    
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
    
    # YY App
    block_ad "/data/data/com.duowan.mobile/shared_prefs/CommonPref.xml"
    
    # 米家App
    block_ad "/data/data/com.xiaomi.smarthome/files/sh_ads_file"
    
    # 米游社
    block_ad "/data/media/0/Android/data/com.mihoyo.hyperion/cache/splash"
    
    # 天翼云盘
    block_ad "/data/data/com.cn21.ecloud/files/ecloud_current_screenad.obj"
    
    # 闲鱼App
    block_ad "/data/media/0/Android/data/com.taobao.idlefish/files/splash_ad_assets"
    block_ad "/data/media/0/Android/data/com.taobao.idlefish/files/ad"
    block_ad "/data/data/com.taobao.idlefish/cache/beizi"
    
    # 航旅纵横
    block_ad "/data/data/com.umetrip.android.msky.app/files/ad"
    
    # 携程旅行
    block_ad "/data/media/0/Android/data/ctrip.android.view/cache/CTADCache"
    block_ad "/data/data/ctrip.android.view/files/CTAD"
    
    # 智行火车票
    block_ad "/data/media/0/Android/data/com.yipiao/files/CTADCache"
    block_ad "/data/media/0/Android/data/com.yipiao/files/CTADSet"
    
    # 京东App
    block_ad "/data/media/0/Android/data/com.jingdong.app.mall/cache/JDVideoFileDir"
    
    # 小福家App
    block_ad "/data/data/com.coocaa.familychat/app_e_qq_com_setting_7d767d052a5753acb54b111c8a40c128/sdkCloudSetting.cfg"
    
    # 堆糖广告
    block_ad "/data/data/com.duitang.main/shared_prefs/name.xml"
    
    # 同花顺App
    block_ad "/data/data/com.hexin.plat.android/cache/splash_images"
    
    # 锦江荟App
    block_ad "/data/data/com.plateno.botaoota/cache/image_manager_disk_cache"
    
    # 腾讯地图
    block_ad "/data/data/com.tencent.map/databases/splash.db"
    
    # 4399游戏盒
    block_ad "/data/data/com.m4399.gamecenter/shared_prefs/com.m4399.gamecenter.app.xml"
    
    # 今日头条
   block_ad "/data/data/com.ss.android.article.news/files/splashCache"
   
    # 驾考宝典
   block_ad "/data/data/com.handsgo.jiakao.android/shared_prefs/mucangData.db.xml"
   
   # Apkpure
   block_ad "/data/data/com.apkpure.aegon/cache/splash"
   
   # 酷狗音乐
   block_ad "/data/media/0/Android/data/com.kugou.android/files/kugou/.splash_v4"
   
   # 午夜AV
   block_ad "/data/data/com.aabbc.cc/files/cn_jiguang_union_ads/"
   block_ad "/data/data/com.aabbc.cc/shared_prefs/spUtils.xml"
   
   # 掌上无畏契约
   block_ad "/data/media/0/Android/data/com.tencent.apps.valorant/cache/splash"

   # WakeUp课程表
   block_ad "/data/data/com.suda.yzune.wakeupschedule/shared_prefs/com.baidu.homework.Preference.FastAdPreference.xml"
   block_ad "/data/data/com.suda.yzune.wakeupschedule/shared_prefs/mobads_aplist_status_new.xml"
   
   # 猫眼APP
   block_ad "/data/media/0/Android/data/com.sankuai.movie/cache/maoyan_downlaod"
   block_ad "/data/data/com.sankuai.movie/cache/cips/common/mtplatform_mtpicasso/assets/image_manager_disk_cache"
   
   # 心悦俱乐部
   block_ad "/data/data/com.tencent.tgclub/cache/image_manager_disk_cache"
   
   # 瓜子二手车
   block_ad "/data/data/com.ganji.android.haoche_c/files/guazi_theme_image"
   
   # 小象超市
   block_ad "/data/media/0/Android/data/com.meituan.retail.v.android/files/cips/common/waimai"
   block_ad "/data/data/com.meituan.retail.v.android/cache/cips/common/mtplatform_mtpicasso/assets/image_manager_disk_cache"
   
   # 中信银行
   block_ad "/data/data/com.ecitic.bank.mobile/files/citic/advs"
   
   # 江苏银行
   block_ad "/data/data/cn.jsb.china/cache/images"
   block_ad "/data/data/cn.jsb.china/files/jsbank/splash"  
   
   # 滴滴出行
   block_ad "/data/data/com.sdu.didi.psnger/cache/image_manager_disk_cache"
   
   # 盒马App
   block_ad "/data/data/com.wudaokou.hippo/shared_prefs/splash.xml"
   
   # 完美世界电竞
   block_ad "/data/data/com.pwrd.steam.esports/shared_prefs/advertisement_sp_name.xml"
   
   # 人卫App
   block_ad "/data/data/com.pmph.irenwei/cache/image_manager_disk_cache"
   block_ad "/data/data/com.pmph.irenwei/files/ad.gif"
   
   # 中国银河证券
   block_ad "/data/data/com.galaxy.stock/files"
   
   # 南方基金
   block_ad "/data/media/0/Android/data/com.nanfangjijin.app/files/ad"
   block_ad "/data/data/com.nanfangjijin.app/cache/image_manager_disk_cache"
   
   # 银华利生宝
   block_ad "/data/data/com.ihandy.fund/cache/image_manager_disk_cache"
   block_ad "/data/media/0/Android/data/com.ihandy.fund/cache/download/splash"
   
   # 中国移动云盘
   block_ad "/data/media/0/Android/data/com.chinamobile.mcloud/files/M_Cloud/temp/bigcloudimage"
   block_ad "/data/media/0/Android/data/com.chinamobile.mcloud/files/boot_logo"

# 自动关闭私人DNS
[ "$(settings get global private_dns_mode)" = "off" ] || settings put global private_dns_mode off

# 自动清空IFW文件夹
[ -d "/data/system/ifw" ]&&for f in /data/system/ifw/*;do [ -e "$f" ]&&rm -rf /data/system/ifw/*&&break;done

# 专清/data/data卸载残留
for d in /data/data/*==deleted==;do [ -d "$d" ]&&chattr -R -i "$d"&&rm -rf "$d";done

# 延迟启动
sleep 5
done