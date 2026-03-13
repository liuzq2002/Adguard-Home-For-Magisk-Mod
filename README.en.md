# Adguard Home For Android
[简体中文](README.md) | **English** 
- Ad blocking via DNS request redirection/filtering is universal across modular Root managers
- Based on Twoone3's work, with added methods to disable ads by deleting/occupying ad folders
- It achieves out-of-the-box ease of use; after flashing the module, you can use it by just following the tutorial for minor troubleshooting (no need to configure rules)
- Built-in GOODBYEADS blocking rules and adds custom rules on top of them
- Refactored almost all underlying scripts for lower latency, better performance, and power optimization
- Please read the tutorial before requesting support. Click the link below to jump directly to the tutorial section: [Jump to Tutorial](https://github.com/liuzq2002/Adguard-Home-For-Magisk-Mod/blob/main/README.en.md#-tutorial--read-before-use)
## ⚠️ Risk Notice – Please Read
- Users who have updated to version 2026.03.01 must not downgrade to an earlier version, as doing so may leave residual files when uninstalling modules.
- May interfere with coupon redemption functionality in some apps (not a false positive)
- May prevent reward systems based on watching ads (not a false positive)
- Do **not** use with other similar ad-blocking modules
- Cannot block ads served from the same domain as content (e.g., Twitch, YouTube, Instagram)
## 💡 Advantages Over Other Solutions
### vs. Private DNS
1. No server dependency → no downtime or overload issues
2. Lower latency – processing happens locally
3. Better privacy – no data sent to third-party servers
### vs. Hosts File
1. Encrypted DNS (DoH) support
2. Prevents DNS hijacking
3. Harder to detect and block
4. No need to flash the meta module, achieving even better concealment
### vs. Accessibility-based Ad Skippers (e.g., Li Tiao Tiao)
1. No background process killing issues
2. No UI lag or performance drain
3. Lightweight and battery-efficient
4. No package name detection risks
### vs. LSPosed Modules
1. Less detectable – no app hooking or injection
2. Broader coverage – blocks ads system-wide, not per-app
### Compared to a VPN, what are the advantages of ad blocking?
1. No need to worry about apps detecting that a VPN is active
2. No need to worry about disconnections in the background
## 📖 Tutorial – Read Before Use
- Disable or uninstall other ad-blocking modules, proxy tools, accessibility services, VPN ad blockers, browser ad blockers etc
- If the ad cannot be blocked, clear all data for the app and try again.
- Magisk users: Click the gear icon next to the module to access the Web UI manager
- If using Clash Meta, disable system proxy in Network settings (tested and working)
- USTC Speedtest: [Jump to Tutorial](https://test.ustc.edu.cn)
- Test if ad blocking is working properly (aim for ≥96%): [Jump to Tutorial](https://paileactivist.github.io/toolz/adblock.html)
## 🙏 Credits
- [AdguardHome_magisk](https://github.com/410154425/AdGuardHome_magisk)
- [akashaProxy](https://github.com/ModuleList/akashaProxy)
- [box_for_magisk](https://github.com/taamarin/box_for_magisk)
- [AdGuardHomeForMagisk](https://github.com/twoone-3/AdGuardHomeForMagisk)
