//
//  CONSTS.h
//  VHYunSDKDemo
//
//  Created by vhall on 2017/11/16.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#ifndef CONSTS_h
#define CONSTS_h

//1、AppDelegate.mm 修改为.mm
//2、关闭bitcode
//3、设置plist中 App Transport Security Settings -> Allow Arbitrary Loads 设置为YES
//4、设置plist中 Privacy - Camera Usage Description      是否允许使用相机
//5、设置plist中 Privacy - Microphone Usage Description  是否允许使用麦克风
//6、设置以下数据 检查 Bundle ID 即可观看直播

#define DEMO_AccessToken            @""
#define DEMO_third_party_user_id    DEMO_Setting.third_party_user_id //[[[UIDevice currentDevice] identifierForVendor] UUIDString]

#define DEMO_PlayerRoomID           @""
#define DEMO_PublishRoomID          @""
#define DEMO_RecordID               @""
#define DEMO_DocChannelID           @""
#define DEMO_IMChannelID            @""

#define DEMO_CustomDocID            @""

#define DEMO_AppID                  @""

//#if DEBUG  // 调试状态, 打开LOG功能
#define VHLog(...) NSLog(__VA_ARGS__)
//#else // 发布状态, 关闭LOG功能
//#define VHLog(...)
//#endif

#define kViewFramePath  @"frame"
#pragma mark - iphone detection functions
#define APPDELEGATE             [AppDelegate getAppDelegate]
#define IOSVersion              [[UIDevice currentDevice].systemVersion floatValue]
#define VHScreenHeight          ([UIScreen mainScreen].bounds.size.height)
#define VHScreenWidth           ([UIScreen mainScreen].bounds.size.width)
#define VH_SH                   ((VHScreenWidth<VHScreenHeight) ? VHScreenHeight : VHScreenWidth)
#define VH_SW                   ((VHScreenWidth<VHScreenHeight) ? VHScreenWidth  : VHScreenHeight)

//颜色
#define MakeColor(r,g,b,a)      ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])
#define MakeColorRGB(hex)       ([UIColor colorWithRed:((hex>>16)&0xff)/255.0 green:((hex>>8)&0xff)/255.0 blue:(hex&0xff)/255.0 alpha:1.0])
#define MakeColorRGBA(hex,a)    ([UIColor colorWithRed:((hex>>16)&0xff)/255.0 green:((hex>>8)&0xff)/255.0 blue:(hex&0xff)/255.0 alpha:a])
#define MakeColorARGB(hex)      ([UIColor colorWithRed:((hex>>16)&0xff)/255.0 green:((hex>>8)&0xff)/255.0 blue:(hex&0xff)/255.0 alpha:((hex>>24)&0xff)/255.0])



#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#endif /* CONSTS_h */
