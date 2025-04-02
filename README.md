# Adguard Home For Magisk Mod
- 一个通过重定向并过滤 DNS 请求来屏蔽广告的 Magisk/KernelSU 模块
- 在官方的基础上增加了IFW规则、删除/占用广告文件夹等方法禁用广告
- 内置了8680的拦截规则并在此基础上增加了自定义规则
- 重构了模块几乎所有的底层脚本，带来更低的延迟更好的性能以及功耗优化
- 相比于私人DNS有哪些优点？私人dns需要不断的向服务器进行访问，一旦服务器超负荷或过载以及服务器连不上的话就会导致断网；由于私人dns需要向服务器进行访问，所以存在很大的网络延迟问题（因为需要向服务器请求过滤以后再返回到你的设备上，所以中间存在着很大延迟）；私人DNS由于数据都交由服务器处理，存在的数据泄露的隐患
- 相比于Hosts有哪些优点？一：数据都是加密传输，并且经过Doh；二：防止DNS劫持，防止网页被劫持的风险；三：不容易被检测，原因同第一点
# 教程
- 一定要关闭或卸载其他广告拦截模块、代理模块、无障碍跳过软件、VPN代理去广告、浏览器自带广告拦截、私人DNS等等
- 如果你使用的是Magisk框架，那么点击模块旁边的操作按钮就可以进入Web UI管理器
- 使用Chash Meta导致无法正常过滤的，可以去Chash Meta设置-应用中关闭系统代理（我测试依然可以正常代理，并且广告可以过滤了）
- 测速：https://test.ustc.edu.cn/
- 测试广告拦截率（达到96%或以上是正常）：https://paileactivist.github.io/toolz/adblock.html

# 鸣谢
- [AdguardHome_magisk](https://github.com/410154425/AdGuardHome_magisk)
- [akashaProxy](https://github.com/ModuleList/akashaProxy)
- [box_for_magisk](https://github.com/taamarin/box_for_magisk)
- [AdGuardHomeForMagisk](https://github.com/twoone-3/AdGuardHomeForMagisk)
