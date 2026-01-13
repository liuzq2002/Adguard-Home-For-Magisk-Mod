# Adguard Home For Android
 **简体中文** | [English](README.en.md)
- 通过重定向并过滤DNS请求来屏蔽广告且带有模块系统的Root管理器通用
- 在Twoone3的基础上增加了删除/占用广告文件夹的方法禁用广告
- 内置了8680的拦截规则并在此基础上增加了自定义规则
- 重构了模块几乎所有的底层脚本，带来更低的延迟更好的性能以及功耗优化
- 已经兼容了Surfing、Box、AkashaProxy代理模块，其余的暂不兼容
- 代理兼容脚本目前存在问题，正在解决这个问题 ~只需要在/data/adb/agh/scripts/config.prop配置文件中填入你的机场订阅保存重启即可自动兼容，剩下的交给模块自行处理就行~ 代理兼容脚本目前存在问题，正在解决这个问题
- 不看教程不要来找我反馈，点此链接直接跳转到教程：[点击跳转](https://github.com/liuzq2002/Adguard-Home-For-Magisk-Mod/tree/main?tab=readme-ov-file#-%E6%95%99%E7%A8%8B%E4%B8%8D%E7%9C%8B%E7%9A%84%E8%AF%9D%E5%87%BA%E4%BA%8B%E5%88%AB%E5%88%B0%E5%A4%84%E6%89%BE%E6%88%91%E9%97%AE%E9%A2%98)
## ⚠️ 风险提示，不看请别怪我没提醒
- 模块会导致优惠券无法正常领取，如无法正常领取这并非误杀
- 部分软件的看广告领金币无法正常领取，如无法使用这并非误杀
- 模块不可以与同类模块同时使用，更详细的请看教程那一栏
- 模块无法拦截广告与内容为同一域名的，比如QQ、微信、支付宝等部分广告
## 💡 模块相比于其他的方案有哪些优点？
### 相比于私人DNS有哪些优点？
1. 私人dns需要不断的向服务器进行访问，一旦服务器超负荷或过载以及服务器连不上的话就会导致断网
2. 由于私人dns需要向服务器进行访问，所以存在很大的网络延迟问题（因为需要向服务器请求过滤以后再返回到你的设备上）
3. 私人DNS由于数据都交由服务器处理，存在的数据泄露的隐患（因为私人DNS的置信度不高）
4. 数据都在本地处理，隐私保障性更高
### 相比于Hosts有哪些优点？
1. 数据都是加密传输，并且经过Doh
2. 防止DNS劫持，防止网页被劫持的风险
3. 不容易被检测，原因同第一点
4. 不需要刷入元模块，隐藏性更好
### 相比于李跳跳等无障碍跳过软件有哪些优点？
1. 不用担心会掉后台，不用担心杀后台会导致无障碍失效等问题
2. 不会因为无障碍而导致手机掉帧卡顿，因为无障碍跳过软件是实时扫描页面元素
3. 轻量化运行不用担心耗电过快的问题
4. 模块不存在应用包名被检测的问题
### 相比于Lsposed模块去广告有哪些优点？
1. 不容易被检测到，因为Lsposed去广告插件需要Hook函数注入应用
2. 本模块虽屏蔽精度不高，相比于此类插件屏蔽的广啊（因为此类模块只能屏蔽一个或十几个应用）
## 📖 教程，不看的话出事别到处找我问题
- 一定要关闭或卸载其他广告拦截模块、无障碍跳过软件、VPN代理去广告、浏览器自带广告拦截、爱玩机以及Scene相关模块、ZN---Audit-Patch、Zygisk - Sui等等
- 如果遇到广告拦截不掉的，请先尝试清除该应用的全部缓存并杀掉后台重试（如果再不行的话，清除该应用的全部数据后重试）
- 如果你使用的是Magisk框架，那么点击模块旁边的操作按钮就可以进入Web UI管理器
- 使用Chash Meta导致无法正常过滤的，可以去Chash Meta设置-网络中关闭系统代理（我测试依然可以正常代理，并且广告可以过滤了）
- 中国科学大学测速网：[点击跳转](https://test.ustc.edu.cn)
- 测试广告拦截率（达到96%或以上是正常）：[点击跳转](https://paileactivist.github.io/toolz/adblock.html)
## 💬 获取联系方式
- 聊天闲聊群：[点击链接加入群聊](https://qun.qq.com/universal-share/share?ac=1&authKey=l2FNOfui75SDr9n8qTfNjibiF1aTpQ%2B0cmJrw7iKnj%2B95dyExNG5LrdCJu5%2FEKrQ&busi_data=eyJncm91cENvZGUiOiI3NDY2NDA0NjQiLCJ0b2tlbiI6ImhOUWgzVTFPYnRUcEw1ZEJ1TnhkOGI4b0ZQSFV6cmtuVkludk5EcDR4WTFXSU5PelVmdnZoUHIwOGEreHVnNEYiLCJ1aW4iOiIzMzEzODI0NTc1In0%3D&data=8QbRVdmvcvuIPhoaZYMQRNm8tdG9QvQ_d6dLJvGEW_XEOWLbexxs8SgTRPfW51Tpe7IGWAu3PpizEpFa9oO1LQ&svctype=4&tempid=h5_group_info)
- 反馈测试组：[点击链接加入群聊](https://qun.qq.com/universal-share/share?ac=1&authKey=xuYEMvAvyzLDhQ58xxwN71dyblHMrMB9YSG4ZpFpKrFz1NT4WdL19uSE4XJE1dt6&busi_data=eyJncm91cENvZGUiOiI1ODQwNjM0NDMiLCJ0b2tlbiI6Im9aM2R1ejBUeDJSWDVJaWNFdmE3bE5YdDdUam5OczZ3R2Z1MmFrYTlpZXNGV2EySFlZRVQrQ0NDOEhoSGZhTHEiLCJ1aW4iOiIzMzEzODI0NTc1In0%3D&data=e5gCMNYudfN2GeBXHTj6s3dwh37WNTWTcpws90_eZ_huBBXuanzL6MQ1FvfjRxLxN3oraEJUF8QAhN0oYAErKA&svctype=4&tempid=h5_group_info)
- 绮梦社区友情链接：[点击链接进入官网](https://vlink.cc/ceromis)
## 🙏 鸣谢项目名单
- [AdguardHome_magisk](https://github.com/410154425/AdGuardHome_magisk)
- [akashaProxy](https://github.com/ModuleList/akashaProxy)
- [box_for_magisk](https://github.com/taamarin/box_for_magisk)
- [AdGuardHomeForMagisk](https://github.com/twoone-3/AdGuardHomeForMagisk)
