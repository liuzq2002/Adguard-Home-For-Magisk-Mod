#!/system/bin/sh

AGH_DIR="/data/adb/agh" 

if [ -d "${AGH_DIR}" ]; then
rm -rf "${AGH_DIR}"
fi

#卸载时还原被阻止的文件
rm /data/data/com.zhihu.android/files/ad
rm /data/system/ifw/com.sinovatech.unicom.ui.xml
rm -rf /storage/emulated/0/Android/data/com.chinamobile.mcloud/files/boot_logo
rm /data/system/ifw/com.ct.client.xml
rm /data/system/ifw/com.taobao.trip.xml