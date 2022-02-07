#!/bin/bash
#=================================================
# Description: change default settings
# Lisence: MIT
# Author: fibreyu
# https://github.com/fibreyu/OpenWRT_AutoBuild
#=================================================

# change ip
sed -i 's/192.168.1.1/10.0.0.254/g' package/base-files/files/bin/config_generate && echo "IP set complete"

# change etc
[ -e ../files ] && cp -r ../files ./

# change index.htm
INDEX_PAGE=feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm
[ -e $INDEX_PAGE ] && sed -i '/<td id="cpuusage">-</a\               <tr><td width="33%">github</td><td id="github_fibreyu"><a href="https://github.com/fibreyu/OpenWRT_AutoBuild">Fibreyu Github</a></td></tr>' $INDEX_PAGE
INDEX_PAGE=package/lean/autocore/files/arm/index.htm
[ -e $INDEX_PAGE ] && sed -i '/<td id="cpuusage">-</a\               <tr><td width="33%">github</td><td id="github_fibreyu"><a href="https://github.com/fibreyu/OpenWRT_AutoBuild">Fibreyu Github</a></td></tr>' $INDEX_PAGE
INDEX_PAGE=package/lean/autocore/files/x86/index.htm
[ -e $INDEX_PAGE ] && sed -i '/<td id="cpuusage">-</a\               <tr><td width="33%">github</td><td id="github_fibreyu"><a href="https://github.com/fibreyu/OpenWRT_AutoBuild">Fibreyu Github</a></td></tr>' $INDEX_PAGE

# change version and release
VERSION_FILE=package/lean/default-settings/files/zzz-default-settings
[ -e $VERSION_FILE ] && sed -i 's/R[0-9]*\.[0-9]*\.[0-9]*/& compiled by fibreyu/g' $VERSION_FILE
[ -e $VERSION_FILE ] && sed -i 's/OpenWrt/Simplify &/g' $VERSION_FILE
# [ -e $VERSION_FILE ] && echo "sed -i '/[0-9a-zA-Z]*/d' /etc/os-release"
[ -e $VERSION_FILE ] && echo "sed -i 's/[0-9a-zA-Z-_\s]*/& compiled by fibreyu/g' /etc/os-release" >> $VERSION_FILE

