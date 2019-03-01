# VHYun_SDK_iOS 
微吼云 iOS SDK <br>
集成和调用方式，参见官方文档：http://yun.vhall.com/document/document/index <br>


### APP工程集成SDK基本设置
1、工程中AppDelegate.m 文件名修改为 AppDelegate.mm<br>
2、关闭bitcode 设置<br>
3、plist 中 App Transport Security Settings -> Allow Arbitrary Loads 设置为YES<br>
4、注册`AppKey`  [VHLiveBase registerApp:`AppKey`]; <br>
5、检查工程 `Bundle ID` 是否与`AppKey`对应 <br>
6、plist中添加相机、麦克风权限 <br>
7、互动功能暂不支持模拟器 <br>


### SDK 各模块依赖关系图

![(VHYunSDK)](https://github.com/vhall/VHYun_SDK_iOS/blob/master/dependencies.png)

### 版本更新信息
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
