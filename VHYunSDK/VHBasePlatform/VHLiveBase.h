//
//  VHLiveBase.h
//  VHBasePlatform
//
//  Created by vhall on 2017/11/28.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//日志等级
typedef NS_ENUM(NSInteger, VHLogLevel) {
    VHLogLevelNone    = 0,    //NONE
    VHLogLevelError   = 1,    //Error
    VHLogLevelWarning = 2,    //Warning
    VHLogLevelInfo    = 3,    //Info
    VHLogLevelDebug   = 4,    //Debug
    VHLogLevelVerbose = 5,    //VERBOSE
};

@interface VHLiveBase : NSObject


+ (BOOL) registerApp:(NSString *)appid;

+ (BOOL) setThirdPartyUserId:(NSString *)third_party_user_id;

+ (void) setLogLevel:(VHLogLevel)level;
    
+ (void) printLogToConsole:(BOOL)isPrint;//默认不显示到控制台

+ (NSString *) getSDKVersion;

@end
