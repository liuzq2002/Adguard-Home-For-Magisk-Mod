# Adguard Home For Magisk Mod
- 一个通过重定向并过滤 DNS 请求来屏蔽广告的 Magisk/KernelSU 模块
- 在官方的基础上增加了IFW规则、删除/占用广告文件夹等方法禁用广告
- 内置了8680的拦截规则并在此基础上增加了自定义规则
- 重构了模块几乎所有的底层脚本，带来更低的延迟更好的性能以及功耗优化

# 教程
- 一定要关闭或卸载掉其他广告拦截模块、代理模块以及无障碍跳过软件、VPN代理去广告、浏览器自带广告拦截、私人DNS等等
- 如果你使用的是Magisk框架，那么点击模块旁边的操作按钮就可以进入Web UI管理器
- 使用Chash Meta导致无法正常过滤的，可以去Chash Meta设置-应用中关闭系统代理（我测试依然可以正常代理，并且广告可以过滤了）
- 测速：https://test.ustc.edu.cn/
- 测试广告拦截率（达到96%或以上是正常）：https://paileactivist.github.io/toolz/adblock.html

# 鸣谢
- [AdguardHome_magisk](https://github.com/410154425/AdGuardHome_magisk)
- [akashaProxy](https://github.com/ModuleList/akashaProxy)
- [box_for_magisk](https://github.com/taamarin/box_for_magisk)
- [AdGuardHomeForMagisk](https://github.com/twoone-3/AdGuardHomeForMagisk)
