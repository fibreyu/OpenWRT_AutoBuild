#!/bin/bash
#=================================================
# Description: add plugin luci-app-helloworld
# Lisence: MIT
# Author: fibreyu
# https://github.com/fibreyu/OpenWRT_AutoBuild
#=================================================

# delete a feed source
sed -i "/helloworld/d" "feeds.conf.default"

# Add a feed source
echo "src-git helloworld https://github.com/fw876/helloworld.git" >> "feeds.conf.default"

# log
echo "helloworld add complete"