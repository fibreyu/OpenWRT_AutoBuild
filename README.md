# OpenWRT_AutoBuild
#### 一、功能

1. 使用GIT ACTION自动编译OPENWRT
2. 一键编译脚本

#### 二、使用

##### 2.1 目录说明

- .github : GIT ACTION工作流的配置路径
- config : 编译所需配置文件，编译时将对应架构配置文件复制为OpenWRT项目根目录的.config
- scripts : 添加第三方包、修改配置的脚本
- files：固件目录自定义文件
- auto_build_scripts：一键编译脚本

##### 2.2 GIT ACTION编译

```bash
# 拉取仓库
git clone https://github.com/fibreyu/OpenWRT_AutoBuild.git
# 进入仓库
cd OpenWRT_AutoBuild
# 查看所有分支
git branch -a
# 切换到main修改配置
git checkout main
# 在main分支提交修改
git add .
git commit -m ""
git push origin main
# 切换到 build
git checkout -b build origin/build
git checkout build
# 合并main
git merge main
# 提交并开始workflow
git push origin build
# 提交到build分支后将自动开启云编译
```

##### 2.3 一键编译脚本

```bash
# 拉取仓库
git clone https://github.com/fibreyu/OpenWRT_AutoBuild.git
# 使用root用户
cd OpenWRT_AutoBuild
chmod 777 ./auto_build_scripts/Auto_Build_LEDE.sh
nohup ./auto_build_scripts/Auto_Build_LEDE.sh > build_log 2>&1 &
echo $! > PID
```

##### 2.4 自定义配置

###### 2.4.1 使用`make menuconfig`

按照[编译步骤](https://github.com/coolsnowwolf/lede)完成`make menuconfig`后，可将生成的.config文件保存到项目的config目录中，然后修改`.github/workflows`下对应配置文件中的`CONFIG_FILE`环境变量为保存的配置文件

###### 2.4.2 使用`make defconfig`

参考官方[编译说明](https://openwrt.org/zh/docs/guide-developer/build-system/use-buildsystem)，OpenWRT项目根据不同的设备架构，设置了编译默认配置，可以在`.config`文件中记录下和默认配置不同的配置项，然后用使用`make defconfig`把`.config`文件扩展为完整配置。此时`.config`文件中记录的是配置的差量。

创建`.config`可以在完成一次`make`编译或`make download`之后使用`./scripts/diffconfig.sh`创建，r2752版本以后，`make`命令会自动创建diff文件为`config.seed`文件

```bash
./scripts/diffconfig.sh > diffconfig # write the changes to diffconfig
```

创建完成后可将生成的diffconfig内容保存到本项目根目录下的`config`中的对应配置文件中

#### 二、感谢各位大佬

- [openwrt](https://github.com/openwrt)/**[openwrt](https://github.com/openwrt/openwrt)**
- [coolsnowwolf](https://github.com/coolsnowwolf)/**[lede](https://github.com/coolsnowwolf/lede)**
- [esirplayground](https://github.com/esirplayground)/**[AutoBuild-OpenWrt](https://github.com/esirplayground/AutoBuild-OpenWrt)**
- [P3TERX](https://github.com/P3TERX)/**[Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)**
- [KFERMercer](https://github.com/KFERMercer)/**[OpenWrt-CI](https://github.com/KFERMercer/OpenWrt-CI)**
- [Kurokosama](https://github.com/Kurokosama)/**[AutoBuild-OpenWRT](https://github.com/Kurokosama/AutoBuild-OpenWRT)**

