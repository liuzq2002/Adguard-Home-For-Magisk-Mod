echo "等待 1 秒..."
echo "刷新页面以查看更改。"
sleep 1

# 自动跳转到浏览器并打开 Web UI
echo "正在打开浏览器..."
am start -a android.intent.action.VIEW -d http://127.0.0.1:3000