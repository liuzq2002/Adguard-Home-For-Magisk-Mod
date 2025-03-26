#去除中国联通的广告
cp /data/adb/agh/ifw/com.sinovatech.unicom.ui.xml /data/system/ifw
#去除知乎的开屏广告
rm -rf /data/data/com.zhihu.android/files/ad
touch /data/data/com.zhihu.android/files/ad
chmod 000 /data/data/com.zhihu.android/files/ad
#去除中国移动云盘的开屏广告
rm -rf /storage/emulated/0/Android/data/com.chinamobile.mcloud/files/boot_logo
touch /storage/emulated/0/Android/data/com.chinamobile.mcloud/files/boot_logo
chmod 000 /storage/emulated/0/Android/data/com.chinamobile.mcloud/files/boot_logo
#去除中国电信的开屏广告。
cp /data/adb/agh/ifw/com.ct.client.xml /data/system/ifw
#去除飞猪App的广告
cp /data/adb/agh/ifw/com.taobao.trip.xml /data/system/ifw