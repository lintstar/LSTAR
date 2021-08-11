# LSTAR - Aggressor

**本着简化 CS 右键和方便自己集成的目的，对 Reference 里的项目进行了缝合以及二次开 (抄) 发 (袭)** 

**并添加了 Cxk 限时免杀的 mimikatz 和 adduser 等功能**

**项目树较为简单直观 且方便 DIY：**

![image-20210707141929031](LSTAR/image-20210707141929031.png)

**由于作案时间有限 很多功能待实战测试去除和优化**

# Reference

[**梼杌 - taowu-cobalt-strike**](https://github.com/pandasec888/taowu-cobalt-strike)

[**Z1-AggressorScripts**](https://github.com/z1un/Z1-AggressorScripts)

[**九世自开 csplugin**](https://github.com/422926799/csplugin)

[**A-Team CobaltStrike-Toolset**](https://github.com/QAX-A-Team/CobaltStrike-Toolset)

# 2021.08.11 更新

## InfoCollect

新增 CheckVM 检测目标是否为虚拟机

![20210808_2213](LSTAR/20210808221427.png)

## AVSearch

由于之前的脚本有一定概率失败：

![image-20210808222325403](LSTAR/image-20210808222325403.png)

更新了新的检测杀软方式

![image-20210808221945724](LSTAR/20210808221945.png)

## AuthPromote

**修复了之前提权模块的 BUG**

![image-20210811105401723](LSTAR/20210811105401.png)

## PassCapture

### Mimikatz 相关

![image-20210811104834675](LSTAR/20210811104834.png)

### Lazagne

**实战测试比较好用的检索主机密码工具 （上传运行后会自动删除 exe 文件）**

![image-20210811102145547](LSTAR/20210811102145.png)

### 浏览器密码

![image-20210811105159479](LSTAR/20210811105159.png)

### Navicat Xshell 等本机软件

![image-20210811105105056](LSTAR/20210811105105.png)

### FakeTheScreen

**优化了针对 Windows10和 Windows7不同的钓鱼密码窃取**

![image-20210811095234252](LSTAR/20210811095234.png)

**由于伪造页面效果一言难尽，只建议在准备鱼死网破时使用：**

![image-20210811094621414](LSTAR/20210811094621.png)

## AboutMe

**添加了 AboutMe 帮助菜单**

![image-20210811105716461](LSTAR/20210811105716.png)

**方便跳转 凌星阁**

![image-20210811110156391](LSTAR/20210811110156.png)

# InfoCollect

添加了 Netview 和 Powerview 功能

![image-20210707112534352](LSTAR/image-20210707112534352.png)

# AvSearch

![image-20210707114047098](LSTAR/image-20210707114047098.png)

![image-20210706105117525](LSTAR/image-20210706105117525.png)



# IntrScan

![image-20210707112718120](LSTAR/image-20210707112718120.png)

自定义指令运行

![image-20210706110153336](LSTAR/image-20210706110153336.png)

fscan 默认上传至 **`C:\\Users\\Public\\`**

![image-20210706110110475](LSTAR/image-20210706110110475.png)



控制台返回

![image-20210706110008931](LSTAR/image-20210706110008931.png)

删除 fscan 及结果文本

![image-20210706110809988](LSTAR/image-20210706110809988.png)

# IntrAgent

![image-20210707112750687](LSTAR/image-20210707112750687.png)

# AuthPromote

![image-20210707112813847](LSTAR/image-20210707112813847.png)

# AuthMaintain

![image-20210707112856320](LSTAR/image-20210707112856320.png)

# PassCapture

![image-20210707113614496](LSTAR/image-20210707113614496.png)

# LateMovement

![image-20210707113642982](LSTAR/image-20210707113642982.png)

# TraceClean

![image-20210707113717904](LSTAR/image-20210707113717904.png)

# BypassCxk

![image-20210707113737475](LSTAR/image-20210707113737475.png)

# HavingFun

![image-20210707113749756](LSTAR/image-20210707113749756.png)

