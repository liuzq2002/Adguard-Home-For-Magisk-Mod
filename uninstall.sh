#!/system/bin/sh

AGH_DIR="/data/adb/agh" 

if [ -d "${AGH_DIR}" ]; then
rm -rf "${AGH_DIR}"
fi

#卸载时清空被阻止的文件
rm -rf /data/system/ifw
mkdir /data/system/ifw

#卸载时还原被替换的文件
#哔哩哔哩
chattr -i /data/user/0/tv.danmaku.bili/files/res_cache
rm -rf /data/user/0/tv.danmaku.bili/files/res_cache
#知乎
chattr -i /data/data/com.zhihu.android/files/ad
rm -rf /data/data/com.zhihu.android/files/ad
#中国广电
chattr -i /data/user/0/com.ai.obc.cbn.app/files/splashShow
rm -rf /data/user/0/com.ai.obc.cbn.app/files/splashShow