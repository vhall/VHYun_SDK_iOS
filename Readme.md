# VHYun_SDK_iOS 
微吼云 iOS SDK <br>
集成和调用方式，参见官方文档：http://yun.vhall.com/document/document/index <br>

### Pod 引入微吼云 SDK
  pod 'VHYun_LSS'<br>
  pod 'VHYun_RTC'<br>
  pod 'VHYun_IM'<br>
  pod 'VHYun_OPS'<br>

#### 微吼云 直播点播 SDK
https://github.com/vhall/VHYun_SDK_LSS_iOS<br>
#### 微吼云 互动 SDK
https://github.com/vhall/VHYun_SDK_RTC_iOS<br>
#### 微吼云 文档演示 SDK
https://github.com/vhall/VHYun_SDK_OPS_iOS<br>
#### 微吼云 消息 SDK
https://github.com/vhall/VHYun_SDK_IM_iOS<br>


### APP工程集成SDK基本设置
1、关闭bitcode 设置<br>
2、plist 中 App Transport Security Settings -> Allow Arbitrary Loads 设置为YES<br>
3、注册`AppKey`  [VHLiveBase registerApp:`AppKey`]; <br>
4、检查工程 `Bundle ID` 是否与`AppKey`对应 <br>
5、plist中添加相机、麦克风权限 <br>


### 版本更新信息
#### 不再在此库更新 SDK 版本，使用 Pod 引用微吼云SDK
此库只用于集成所有SDK库的 Demo<br>


#### 版本 v2.0.0 更新时间：2019.08.21
更新内容：<br>
1、业务模块拆分<br>
2、集成方式优化<br>
3、全新文档演示功能<br>

#### 版本 v1.8.2 更新时间：2019.08.21
更新内容：<br>
1、优化美颜直播性能<br>
2、IM老数据结构兼容<br>

#### 版本 v1.8.1 更新时间：2019.07.27
更新内容：<br>
1、优化直播美颜效果<br>

#### 版本 v1.8.0 更新时间：2019.07.10
更新内容：<br>
1、新增录屏直播功能<br>
2、消息模块优化使用新消息结构<br>
3、新增直播截图功能<br>


#### 版本 lss v1.7.3 更新时间：2019.05.29
更新内容：<br>
1、修复推流切后台错误，注意要在 UIApplicationWillResignActiveNotification 事件中处理进入后台推流情况<br>
2、解决直播清晰度切换失败问题<br>
3、解决底层内存问题<br>

#### 版本 v1.7.2 更新时间：2019.05.24
更新内容：<br>
1、文档服务新增文档上传功能<br>
2、直播添加水印显示<br>
3、支持模拟器编译<br>

#### 版本 v1.7.1 更新时间：2019.04.24
更新内容：<br>
1、多方互动优化<br>
2、文档支持更多图形绘制<br>
3、demo优化<br>

#### 版本 v1.7.0 更新时间：2019.03.18
更新内容：<br>
1、互动最大支持16路，根据实际手机情况设置显示视频的路数<br>
2、互动支持360p以上双流推送<br>
3、修复文档底层bug
4、修复直播模块bug

#### 版本 v1.6.1 更新时间：2019.03.01
更新内容：<br>
1、解决蓝牙耳机无声bug<br>
2、新增纯音频推流<br>


#### 版本 v1.6.0 更新时间：2019.02.19
更新内容：<br>
1、新增回放水印功能<br>
2、新增回放Seek限制功能<br>
2、新增回放截图功能<br>

#### 版本 v1.5.0 更新时间：2019.01.08
更新内容：<br>
1、回放倍速播放<br>
2、互动新增变声功能<br>

#### 版本 v1.3.1 更新时间：2018.10.25
更新内容：<br>
1、文档回放<br>


#### 版本 v1.3.0 更新时间：2018.10.21
更新内容：<br>
1、添加文档演示<br>


#### 版本 v1.2.3 更新时间：2018.10.12
更新内容：<br>
1、减少SDK大小<br>
2、优化点播播放<br>
3、修复文档模块bug<br>

#### 版本 v1.2.2 更新时间：2018.08.10
更新内容：<br>
1、减少SDK大小<br>
2、优化点播播放<br>
3、修复基础模块bug<br>


#### 版本 v1.2.1 更新时间：2018.06.14
更新内容：<br>
1、互动功能bug修复<br>


#### 版本 v1.2 更新时间：2018.06.12
更新内容：<br>
1、新增多人互动功能<br>
2、功能优化<br>

#### 版本 v1.1.1 更新时间：2018.05.15
更新内容：<br>
1、bug修复<br>
2、功能优化<br>

#### 版本 v1.1 更新时间：2018.03.22
更新内容：<br>
1、新增自定义消息<br>
2、新增上下线消息<br>
3、功能优化<br>
 
#### 版本 v1.0 更新时间：2018.01.03
更新内容：<br>
1、提供iOS平台LSS服务<br>
2、提供iOS平台VOD服务<br>
3、提供iOS平台OPS服务<br>
4、提供iOS平台IMS服务<br>
