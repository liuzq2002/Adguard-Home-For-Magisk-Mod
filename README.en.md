# Adguard Home For Android
[简体中文](README.md)|[English](README.en.md)
- A universal Root manager with module system that blocks ads by redirecting and filtering DNS requests
- Based on Twoone3's work, with added methods to disable ads by deleting/occupying ad folders
- Built-in 8680 blocking rules with support for custom rules
- Refactored almost all underlying scripts for lower latency, better performance, and power optimization
- **⚠️ Important:** When updating, make sure to press Volume Down to update configuration files
- **Please read the tutorial before requesting support. Click the link below to jump directly to the tutorial section:** [Jump to Tutorial](https://github.com/liuzq2002/Adguard-Home-For-Magisk-Mod/blob/main/README.en.md#-tutorial--read-before-use)
# ⚠️ Risk Notice – Please Read

- May interfere with coupon redemption functionality in some apps (not a false positive)
- May prevent reward systems based on watching ads (not a false positive)
- Some services (e.g., Baidu) bundle ads with financial products – blocking may affect those features
- Do **not** use with other similar ad-blocking modules
- Cannot block ads served from the same domain as content (e.g., QQ, WeChat, Alipay)

# Advantages Over Other Solutions

## vs. Private DNS
1. No server dependency → no downtime or overload issues
2. Lower latency – processing happens locally
3. Better privacy – no data sent to third-party servers

## vs. Hosts File
1. Encrypted DNS (DoH) support
2. Prevents DNS hijacking
3. Harder to detect and block

## vs. Accessibility-based Ad Skippers (e.g., Li Tiao Tiao)
1. No background process killing issues
2. No UI lag or performance drain
3. Lightweight and battery-efficient
4. No package name detection risks

## vs. LSPosed Modules
1. Less detectable – no app hooking or injection
2. Broader coverage – blocks ads system-wide, not per-app

# 📖 Tutorial – Read Before Use

- Disable or uninstall other ad-blocking modules, proxy tools, accessibility services, VPN ad blockers, browser ad blockers, private DNS, and modules like Scene, iWanJi Toolbox, ZN-Audit-Patch, Zygisk-Sui, etc.
- If ads aren't blocked, try clearing the app’s cache and data, then restarting it
- Magisk users: Click the gear icon next to the module to access the Web UI manager
- If using Clash Meta, disable system proxy in Network settings (tested and working)
- Speed test: https://test.ustc.edu.cn/
- Ad block test (aim for ≥96%): https://paileactivist.github.io/toolz/adblock.html

# 🙏 Credits

- [AdguardHome_magisk](https://github.com/410154425/AdGuardHome_magisk)
- [akashaProxy](https://github.com/ModuleList/akashaProxy)
- [box_for_magisk](https://github.com/taamarin/box_for_magisk)
- [AdGuardHomeForMagisk](https://github.com/twoone-3/AdGuardHomeForMagisk)
