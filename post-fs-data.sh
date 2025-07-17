#清空IFW系统目录文件并创建文件夹
rm -rf /data/system/ifw
mkdir /data/system/ifw
#去除中国联通的广告
cp /data/adb/agh/ifw/com.sinovatech.unicom.ui.xml /data/system/ifw
#去除美团外卖的开屏广告
rm -rf data/data/com.sankuai.meituan.takeoutnew/files/cips/common/waimai/assets/ad
touch data/data/com.sankuai.meituan.takeoutnew/files/cips/common/waimai/assets/ad
chattr +i data/data/com.sankuai.meituan.takeoutnew/files/cips/common/waimai/assets/ad
rm -rf /data/media/0/Android/data/com.sankuai.meituan.takeoutnew/files/cips/common/waimai/assets/promotion
touch /data/media/0/Android/data/com.sankuai.meituan.takeoutnew/files/cips/common/waimai/assets/promotion
chattr +i /data/media/0/Android/data/com.sankuai.meituan.takeoutnew/files/cips/common/waimai/assets/promotion
#去除知乎的开屏广告
rm -rf /data/data/com.zhihu.android/files/ad
touch /data/data/com.zhihu.android/files/ad
chattr +i /data/data/com.zhihu.android/files/ad
#去除中国电信的开屏广告
cp /data/adb/agh/ifw/com.ct.client.xml /data/system/ifw
#去除哔哩哔哩的开屏广告
rm -rf /data/user/0/tv.danmaku.bili/files/res_cache
touch /data/user/0/tv.danmaku.bili/files/res_cache
chattr +i /data/user/0/tv.danmaku.bili/files/res_cache
#去除哔哩哔哩的更新推送
rm -rf /data/user/0/tv.danmaku.bili/files/update
touch /data/user/0/tv.danmaku.bili/files/update
chattr +i /data/user/0/tv.danmaku.bili/files/update
#禁止哔哩哔哩下载基础组件库
rm -rf /data/user/0/tv.danmaku.bili/app_mod_resource
touch /data/user/0/tv.danmaku.bili/app_mod_resource
chattr +i /data/user/0/tv.danmaku.bili/app_mod_resource
#禁止谷歌版BiliBili下载基础组件库
rm -rf /data/user/0/com.bilibili.app.in/app_mod_resource
touch /data/user/0/com.bilibili.app.in/app_mod_resource
chattr +i /data/user/0/com.bilibili.app.in/app_mod_resource
#去除中国广电的开屏广告
rm -rf /data/user/0/com.ai.obc.cbn.app/files/splashShow
touch /data/user/0/com.ai.obc.cbn.app/files/splashShow
chattr +i /data/user/0/com.ai.obc.cbn.app/files/splashShow