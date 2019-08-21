//
//  CONSTS.h
//  VHYunSDKDemo
//
//  Created by vhall on 2017/11/16.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#ifndef CONSTS_h
#define CONSTS_h

//开发说明 http://www.vhallyun.com/docs/show/26.html
//1、关闭bitcode
//2、设置plist中 App Transport Security Settings -> Allow Arbitrary Loads 设置为YES
//3、设置plist中 Privacy - Camera Usage Description      是否允许使用相机
//4、设置plist中 Privacy - Microphone Usage Description  是否允许使用麦克风
//5、设置以下数据 检查 Bundle ID 即可观看直播

#define DEMO_AppID                  @""//http://www.vhallyun.com/docs/show/26.html
#define DEMO_AccessToken            @""
#define DEMO_third_party_user_id    [[[UIDevice currentDevice] identifierForVendor] UUIDString]

#define DEMO_PlayerRoomID           @""//http://www.vhallyun.com/docs/show/49.html
#define DEMO_PublishRoomID          @""
#define DEMO_RecordID               @""
#define DEMO_DocChannelID           @""
#define DEMO_IMChannelID            @""
#define DEMO_InteractiveID          @""
#define DEMO_GroupID                @""
#endif /* CONSTS_h */
