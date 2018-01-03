# VHYun_SDK_iOS
微吼云 iOS SDK

### APP工程集成SDK基本设置
1、工程中AppDelegate.m 文件名修改为 AppDelegate.mm<br>
2、关闭bitcode 设置<br>
3、plist 中 App Transport Security Settings -> Allow Arbitrary Loads 设置为YES<br>
4、注册`AppKey`  [VHLiveBase registerApp:`AppKey`]; <br>
5、检查工程 `Bundle ID` 是否与`AppKey`对应 <br>
6、plist中添加相机、麦克风权限 <br>


### SDK 各模块依赖关系图

![(VHYun)](http://wiki.vhall.com/lib/exe/fetch.php?media=rd:%E4%BE%9D%E8%B5%96%E5%85%B3%E7%B3%BB.png)

### 版本更新信息
 
#### 版本 v1.0 更新时间：2018.01.03
更新内容：<br>
1、提供iOS平台LSS服务<br>
2、提供iOS平台VOD服务<br>
3、提供iOS平台OPS服务<br>
4、提供iOS平台IMS服务<br>
