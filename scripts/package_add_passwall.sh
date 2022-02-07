#!/bin/bash
#=================================================
# Description: add plugin luci-app-passwall
# Lisence: MIT
# Author: fibreyu
# https://github.com/fibreyu/OpenWRT_AutoBuild
#=================================================

# delete a feed source
sed -i "/passwall/d" "feeds.conf.default"

# Add a feed source
echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall.git' >> "feeds.conf.default"

# log
echo "passwall add complete"