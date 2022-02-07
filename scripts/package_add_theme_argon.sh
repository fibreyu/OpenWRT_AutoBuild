#!/bin/bash
#=================================================
# Description: add argon theme
# Lisence: MIT
# Author: fibreyu
# https://github.com/fibreyu/OpenWRT_AutoBuild
#=================================================

# delete a feed source
# sed -i "/argon/d" "feeds.conf.default"

# Add a feed source
# echo "src-git argon https://github.com/jerrykuku/luci-theme-argon.git" >> "feeds.conf.default"

# 删除自定义源默认的 argon 主题
rm -rf package/lean/luci-theme-argon && echo "remove package/lean/luci-theme-argon"

# 拉取 argon 原作者的源码
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon

# 替换默认主题为 luci-theme-argon
# [ -e feeds/luci/collections/luci/Makefile ] && sed -i 's/luci-theme-bootstrap/luci-theme-argon/' feeds/luci/collections/luci/Makefile

# log
echo "argon add complete"