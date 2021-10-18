# LSTAR - Aggressor

**本着简化 CS 右键和方便自己集成的目的，对 Reference 里的项目进行了缝合以及二次开 (抄) 发 (袭)** 

**重构和丰富了主机相关凭据获取、多级内网穿透、ZeroLogon 漏洞、免杀的 Mimikatz 和 Adduser 等功能**

**主要包含以下功能模块：**

![image-20211016172048435](image/image-20211016172048435.png)

**每个模块均在运行前添加了绿色分割线，方便定位回显信息，提高协作效率**

![image-20211016170807973](image/image-20211016170807973.png)

> **CobaltStrike 主机上线微信通知插件：**
>
> - **如果想使用免费且支持微信模板消息推送的方式可以移步：https://github.com/lintstar/CS-PushPlus**
> - **如果有订阅 ServerChan 的企业微信推送通道可以移步：https://github.com/lintstar/CS-ServerChan**

##  免责申明

**本项目仅适用于安全研究及合法的企业安全建设行为   一切后果及责任均由使用者本人承担**

# 2021.10.18 更新

- **对整体功能模块进行了重新整合以及优化完善**
- **横向移动模块新增 ZeroLogon 漏洞的BOF 实现**
- **增加了一些 Assembly 方式运行无文件落地的功能**

## InfoCollect

### SharpGetInfo（一键收集主机信息）

**使用 Ladon 进行一键收集包括主机基础信息、网络信息、用户信息、进程信息、是否在域内等等**

![image-20211018111745511](image/image-20211018111745511.png)

### SharpListRDP（RDP记录查询）

**收集 RDP 内连和外连记录，方便定位运维机以及横向移动**

![image-20211016174456005](image/image-20211016174456005.png)

## IntrScan

### Cube（模块化探测）

**新增 Cube 来代替旧版本的爆破，同时支持内网信息收集和 MSSQL 命令执行，详细用法参考运行说明**

![image-20211015174007171](image/image-20211015174007171.png)

### Allin（辅助灵活扫描）

**新增 Allin 来辅助灵活扫描，以远程获取网卡 IP 为例：**

![image-20211015173332706](image/image-20211015173332706.png)

### SharpOXID-Find (OXID 探测)

**或者不想落地 EXE 时，可以使用  Assembly 方式进行 OXID 的快速探测**

![image-20211018112045735](image/image-20211018112045735.png)

## IntrAgent

### Stowaway （穿透多级内网）

**上传 agent 后运行**

![image-20211012100041529](image/image-20211012100041529.png)

**admin 端收到连接即可构建 Socks5 隧道**

![image-20211011203216542](image/image-20211011203216542.png)

**删除 agent**

![image-20211012094116014](image/image-20211012094116014.png)

## PassCapture

### LsassDump（WinAPI）

**修改了 LsassDump 的运行方式 删除 LsassDump 的同时会一起删除转储的 C:\Windows\Temp\1.dmp**

![image-20211016174730994](image/image-20211016174730994.png)

### Mimidump（远程读取.dmp）

**新增配合 LsassDump（WinAPI）功能，远程读取目标机器转储的 C:\Windows\Temp\1.tmp（.net 4.5）**

![image-20211015094927257](image/image-20211015094927257.png)

## RemoteLogin

**新增了使用  Powershell 开启 关闭以及查询 RDP 相关信息的方法**

![image-20211018113058495](image/image-20211018113058495.png)

> PS 脚本来源于 Reference 中的黑魔鬼插件 RDP 模块

### 查询 RDP 状态

![image-20211015150247382](image/image-20211015150247382.png)

### 开启 RDP 服务

![image-20211015150320880](image/image-20211015150320880.png)

### 获取 RDP 端口

![image-20211015150713858](image/image-20211015150713858.png)

### 查看 RDP 历史登录凭据

![image-20211015150429336](image/image-20211015150429336.png)

### 获取 RDP 历史登录凭据

![image-20211015150502487](image/image-20211015150502487.png)

## LateMovement

### IPC 连接

![image-20211018105021131](image/image-20211018105021131.png)

### 票据传递

![image-20211016173510988](image/image-20211016173510988.png)

### ZeroLogonBOF

**新增了 ZeroLogon 漏洞的BOF 实现**

> 参考：https://github.com/rsmudge/ZeroLogon-BOF

![image-20211014143141276](image/image-20211014143141276.png)

# 2021.09.05 更新

- **针对部分功能进行了 x86 架构机器的适配**
- **增加了一些使用 WindowsAPI 的免杀小工具**
- **内网扫描模块在运行对应功能时添加了参数提示输出**

## IntrScan

### Fscan

**新增根据目标机器架构上传对应 EXE 文件**

![image-20210905154601537](image/image-20210905154601537.png)

**添加了参数提示输出 方便针对性指定运行单个模块**

![image-20210905161338995](image/image-20210905161338995.png)

### Crack

**新增 Crack 内网爆破工具**

![image-20210905161656828](image/image-20210905161656828.png)

### TailorScan

**新增根据目标机器架构上传对应 EXE 文件**

![image-20210905160326319](image/image-20210905160326319.png)

## PassCapture

### LaZagne

**修复了V1.2 版本中由于网络问题导致的 LaZagne 还未运行结束**

**就被杀掉进程且删除落地文件的 BUG    改用手动方式运行**

![image-20210904175955070](image/image-20210904175955070.png)

### LsassDump

**新增了使用 WindowsAPI 进行内存转储的 LsassDump 且支持 x86 和 x64机器**

![image-20210904180546301](image/image-20210904180546301.png)

**转储成功后生成的 ` 1.dmp` 会保存在 `C:\Windows\Temp\` 目录**

![image-20211015093809697](image/image-20211015093809697.png)

**直接本地读取即可：**

![image-20210904183721654](image/image-20210904183721654.png)

## LateMovement

**新增了 RDP 相关功能：**

![image-20210905215527815](image/image-20210905215527815.png)

**使用 WindowsAPI 开启 RDP 服务**

![image-20210905215709267](image/image-20210905215709267.png)



# 2021.08.12 更新

## InfoCollect

**新增 CheckVM 检测目标是否为虚拟机**

![20210808_2213](image/20210808221427.png)

## AVSearch

**由于之前的脚本有一定概率失败：**

![image-20210808222325403](image/image-20210808222325403.png)

**更新了新的检测杀软方式**

![image-20210808221945724](image/20210808221945.png)

## AuthPromote

**修复了之前提权模块的 BUG**

![image-20210811105401723](image/20210811105401.png)

## AuthMaintain

**EasyPersistent：https://github.com/yanghaoi/CobaltStrike_CNA/tree/main/EasyCNA**

**新增一个用于 Windows 系统上权限维持的 Cobalt Strike CNA 脚本**

**使用反射 DLL 模块通过 API 对系统服务、计划任务等常见权限维持方法进行可视化操作，非 常 好 用。（作者原话）**

![image-20210812170907609](image/20210812170907.png)

**说明文档：https://github.com/yanghaoi/CobaltStrike_CNA/blob/main/EasyCNA/README.md**

![image-20210812170946202](image/20210812170946.png)

## PassCapture

### Mimikatz 相关

![image-20210811104834675](image/20210811104834.png)

### Lazagne

**实战测试比较好用的检索主机密码工具 （上传运行后会自动删除 exe 文件）**

![image-20210811102145547](image/20210811102145.png)

### 浏览器密码

![image-20210811105159479](image/20210811105159.png)

### Navicat Xshell 等本机软件

![image-20210811105105056](image/20210811105105.png)

### FakeTheScreen

**优化了针对 Windows10和 Windows7不同的钓鱼密码窃取**

![image-20210811095234252](image/20210811095234.png)

**由于伪造页面效果一言难尽，只建议在准备鱼死网破时使用：**

![image-20210811094621414](image/20210811094621.png)

# Reference

[**梼杌 - taowu-cobalt-strike**](https://github.com/pandasec888/taowu-cobalt-strike)

[**Z1-AggressorScripts**](https://github.com/z1un/Z1-AggressorScripts)

[**九世自开-csplugin**](https://github.com/422926799/csplugin)

**[EasyPersistent Windows 权限维持](https://github.com/yanghaoi/CobaltStrike_CNA/blob/main/EasyCNA/README.md)**

[**黑魔鬼-CSplugins**](https://github.com/SeaOf0/CSplugins)

# InfoCollect

**添加了 Netview 和 Powerview 功能**

![image-20210707112534352](image/image-20210707112534352.png)

# AvSearch

**通过 Wmic 进行进程查询**

![image-20210707114047098](image/image-20210707114047098.png)

![image-20210706105117525](image/image-20210706105117525.png)

# IntrScan

**包含各类内网大保健**

![image-20210707112718120](image/image-20210707112718120.png)

**自定义指令运行**

![image-20210706110153336](image/image-20210706110153336.png)

**fscan 默认上传至 `C:\\Windows\\Temp\\`**

![image-20210706110110475](image/image-20210706110110475.png)



**控制台返回**

![image-20210706110008931](image/image-20210706110008931.png)

**删除 fscan 及结果文本**

![image-20210706110809988](image/image-20210706110809988.png)

# IntrAgent

**比较好用的内网穿透工具 且均无配置文件落地 降低被溯源风险**

![image-20210707112750687](image/image-20210707112750687.png)



# AuthMaintain

**在梼杌的基础上 添加了白银票据和黄金票据**

![image-20210707112856320](image/image-20210707112856320.png)

# LateMovement

**包含 基于135端口的sharpwmi 等横向移动套件**

![image-20210707113642982](image/image-20210707113642982.png)

# TraceClean

**缝合九世的痕迹清理 待完善**

![image-20210707113717904](image/image-20210707113717904.png)

# BypassCxk

**cxk 限时免杀版 adduser 和 mimikatz**

![image-20210707113737475](image/image-20210707113737475.png)

# HavingFun

**搞站的日子里图一乐**

![image-20210707113749756](image/image-20210707113749756.png)

