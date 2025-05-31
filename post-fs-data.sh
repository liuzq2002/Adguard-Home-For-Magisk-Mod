#清空IFW系统目录文件并创建文件夹
rm -rf /data/system/ifw
mkdir /data/system/ifw
#去除中国联通的广告
cp /data/adb/agh/ifw/com.sinovatech.unicom.ui.xml /data/system/ifw
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
#去除中国广电的开屏广告
rm -rf /data/user/0/com.ai.obc.cbn.app/files/splashShow
touch /data/user/0/com.ai.obc.cbn.app/files/splashShow
chattr +i /data/user/0/com.ai.obc.cbn.app/files/splashShow