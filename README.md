# LSTAR - Aggressor

**本着简化 CS 右键和方便自己集成的目的，对 Reference 里的项目进行了缝合以及二次开 (抄) 发 (袭)** 

**并添加了虚拟机/AV 检测、主机相关密码抓取、 Cxk 限时免杀的 mimikatz 和 adduser 等功能**

**项目树较为简单直观 且方便 DIY：**

![image-20210812113750414](LSTAR/20210812113750.png)

>**CobaltStrike 主机上线微信通知插件：**
>
>**如果想使用免费且支持微信模板消息推送的方式可以移步：https://github.com/lintstar/CS-PushPlus**
>
>**如果有订阅 ServerChan 的企业微信推送通道可以移步：https://github.com/lintstar/CS-ServerChan**

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

**可以跳转 凌星阁**

![image-20210811110156391](LSTAR/20210811110156.png)

# Reference

[**梼杌 - taowu-cobalt-strike**](https://github.com/pandasec888/taowu-cobalt-strike)

[**Z1-AggressorScripts**](https://github.com/z1un/Z1-AggressorScripts)

[**九世自开 csplugin**](https://github.com/422926799/csplugin)

# InfoCollect

**添加了 Netview 和 Powerview 功能**

![image-20210707112534352](LSTAR/image-20210707112534352.png)

# AvSearch

**通过 Wmic 进行进程查询**

![image-20210707114047098](LSTAR/image-20210707114047098.png)

![image-20210706105117525](LSTAR/image-20210706105117525.png)

# IntrScan

**包含各类内网大保健**

![image-20210707112718120](LSTAR/image-20210707112718120.png)

**自定义指令运行**

![image-20210706110153336](LSTAR/image-20210706110153336.png)

**fscan 默认上传至 `C:\\Users\\Public\\`**

![image-20210706110110475](LSTAR/image-20210706110110475.png)



**控制台返回**

![image-20210706110008931](LSTAR/image-20210706110008931.png)

**删除 fscan 及结果文本**

![image-20210706110809988](LSTAR/image-20210706110809988.png)

# IntrAgent

**比较好用的内网穿透工具 且均无配置文件落地 降低被溯源风险**

![image-20210707112750687](LSTAR/image-20210707112750687.png)

# AuthPromote

**只缝合了梼杌的提权 EXP 后续待完善**

![image-20210707112813847](LSTAR/image-20210707112813847.png)

# AuthMaintain

**在梼杌的基础上 添加了白银票据和黄金票据**

![image-20210707112856320](LSTAR/image-20210707112856320.png)

# PassCapture

**各类密码抓取**

![image-20210707113614496](LSTAR/image-20210707113614496.png)

# LateMovement

**包含 基于135端口的sharpwmi 等横向移动套件**

![image-20210707113642982](LSTAR/image-20210707113642982.png)

# TraceClean

**缝合九世的痕迹清理 待完善**

![image-20210707113717904](LSTAR/image-20210707113717904.png)

# BypassCxk

**cxk 限时免杀版 adduser 和 mimikatz**

![image-20210707113737475](LSTAR/image-20210707113737475.png)

# HavingFun

**搞站的日子里图一乐**

![image-20210707113749756](LSTAR/image-20210707113749756.png)

