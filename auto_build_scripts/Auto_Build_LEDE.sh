#!/bin/bash
#=================================================
# Description: auto build script
# Lisence: MIT
# Author: fibreyu
# https://github.com/fibreyu/OpenWRT_AutoBuild
#=================================================

# set env
REPO_URL=https://github.com/coolsnowwolf/lede
REPO_BRANCH=master
FEEDS_CONF=../config/x86.feeds.conf.default
CONFIG_FILE=../config/x86_64_lede_diff.config
TZ=Asia/Shanghai
RUNUSER=openwrt
RUNGROUP=openwrt
PASSWORD=123456

# rm docker environment
docker rmi `docker images -q`

# del build user and group
chmod 777 /etc/sudoers
sed -i '/'"${RUNUSER}"'/d' /etc/sudoers
chmod 440 /etc/sudoers
grep -w $RUNUSER /etc/passwd
[ $? -eq 0 ] && userdel -r ${RUNUSER}
grep -w $RUNUSER /etc/group
[ $? -eq 0 ] && groupdel ${RUNGROUP}

# create user and group
groupadd ${RUNGROUP}
useradd -d /home/${RUNUSER} -s /bin/bash -g openwrt -G root -m $RUNUSER
# echo $PASSWORD | passwd --stdin $RUNUSER
echo "$RUNUSER":"$PASSWORD" | chpasswd
# add sudo perm
chmod 777 /etc/sudoers
sed -i '/root\s*ALL=(ALL:ALL) ALL/a\'"${RUNUSER}"'    ALL=(ALL) ALL' /etc/sudoers
chmod 440 /etc/sudoers
# add env
# echo REPO_URL=$REPO_URL >> /home/${RUNUSER}/.profile
# echo REPO_BRANCH=$REPO_BRANCH >> /home/${RUNUSER}/.profile
# echo FEEDS_CONF=$FEEDS_CONF >> /home/${RUNUSER}/.profile
# echo CONFIG_FILE=$CONFIG_FILE >> /home/${RUNUSER}/.profile
# echo TZ=$TZ >> /home/${RUNUSER}/.profile
# echo RUNUSER=$RUNUSER >> /home/${RUNUSER}/.profile
# echo RUNGROUP=$RUNGROUP >> /home/${RUNUSER}/.profile
# echo PASSWORD=$PASSWORD >> /home/${RUNUSER}/.profile


# remove package
# echo $PASSWORD | sudo -u ${RUNUSER} -S rm -rf \
sudo -S rm -rf \
          /usr/share/dotnet \
          /etc/mysql \
          /etc/php \
          /etc/apt/sources.list.d/* \
          /usr/local/lib/android \
          /opt/ghc

sudo -E apt-get -y purge \
          azure-cli \
          ghc* \
          zulu* \
          hhvm \
          llvm* \
          firefox \
          google* \
          dotnet* \
          powershell \
          openjdk* \
          mysql* \
          php* \
          mongodb* \
          moby* \
          snapd*

# install build essential
sudo -E apt-get -qq update
sudo -E apt-get -yqq install build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch python3 python2.7 unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler g++-multilib antlr3 gperf wget curl swig rsync
sudo -E apt-get -yqq autoremove --purge
sudo -E apt-get -qq clean
sudo timedatectl set-timezone "$TZ"

# 切换目录
cur_dir=$(pwd)
cp -a ${cur_dir} /home/${RUNUSER}
chown -R ${RUNUSER}:${RUNGROUP} /home/${RUNUSER}/${cur_dir##*/}
chmod -R 755 /home/${RUNUSER}/${cur_dir##*/}
cd /home/${RUNUSER}/${cur_dir##*/}

# clone lede repo
sudo -u ${RUNUSER} git clone --depth 1 $REPO_URL -b $REPO_BRANCH lede
sudo -u ${RUNUSER} chmod a+x ./scripts/*.sh
sudo -u ${RUNUSER} sed -i "s/\r//g" ./scripts/*
sudo -u ${RUNUSER} sed -i "s/^M//g" ./scripts/*
cd lede

# add package
[ -e $FEEDS_CONF ] && sudo -u ${RUNUSER} cp -f $FEEDS_CONF ./feeds.conf.default
sudo -u ${RUNUSER} find ../scripts -maxdepth 1 -type f -executable -name 'package_*.sh' -exec {} \;

# update feeds
sudo -u ${RUNUSER} ./scripts/feeds update -a
sudo -u ${RUNUSER} ./scripts/feeds install -a

# system setting
sudo -u ${RUNUSER} find ../scripts -maxdepth 1 -type f -executable -name 'firmware_*.sh' -exec {} \;

# set config file
[ -e $CONFIG_FILE ] && sudo -u ${RUNUSER} cp -f $CONFIG_FILE .config
sudo -u ${RUNUSER} make defconfig && make -j

sudo -u ${RUNUSER} make download -j$(nproc) V=s
# del package
sudo -u ${RUNUSER} find dl -size -1024c -exec ls -l {} \;
sudo -u ${RUNUSER} find dl -size -1024c -exec rm -f {} \;
sudo -u ${RUNUSER} make -j$(($(nproc) + 1)) V=s || make -j1 V=s || make -j1 V=s


# save data
mv ./bin cur_dir

# del build user and group
chmod 777 /etc/sudoers
sed -i '/'"${RUNUSER}"'/d' /etc/sudoers
chmod 440 /etc/sudoers
grep -w $RUNUSER /etc/passwd
[ $? -eq 0 ] && userdel -r ${RUNUSER}
grep -w $RUNUSER /etc/group
[ $? -eq 0 ] && groupdel ${RUNGROUP}