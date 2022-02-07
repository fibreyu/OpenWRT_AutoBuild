#!/bin/bash
#=================================================
# Description: add plugin luci-app-socat
# Lisence: MIT
# Author: fibreyu
# https://github.com/fibreyu/OpenWRT_AutoBuild
#=================================================

# delete a feed source
# sed -i "/socat/d" "feeds.conf.default"

# Add a feed source
# echo "src-git socat https://github.com/nickilchen/luci-app-socat.git" >> "feeds.conf.default"

# 拉取 luci-app-socat 原作者的源码
git clone https://github.com/nickilchen/luci-app-socat.git package/lean/luci-app-socat

# 添加init可执行
[ -e package/lean/luci-app-socat/root/etc/init.d/socat ] && chmod 775 package/lean/luci-app-socat/root/etc/init.d/socat

# log
echo "socat add complete"