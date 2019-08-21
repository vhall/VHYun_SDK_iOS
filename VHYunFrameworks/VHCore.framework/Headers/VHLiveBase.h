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
};

@interface VHLiveBase : NSObject

/**
 *  注册app
 *  @param appid  http://www.vhallyun.com/ 控制台中创建app 并设置包名 获得
 */
+ (BOOL) registerApp:(NSString *)appid;

/**
 *  注册app
 *  @param appid  http://www.vhallyun.com/ 控制台中创建app 并设置包名 获得
 *  @param completeBlock  SDK初始化成功回调， error 成功为 nil  如果不成功会5s重试一次
 */
+ (BOOL) registerApp:(NSString *)appid completeBlock:(void(^)(NSError *error)) completeBlock;

/**
 *  注册app
 *  @param appid  http://www.vhallyun.com/ 控制台中创建app 并设置包名 获得
 *  @param host   平台域名如api.vhallyun.com
 *  @param completeBlock  SDK初始化成功回调， error 成功为 nil  如果不成功会5s重试一次
 */
+ (BOOL) registerApp:(NSString *)appid host:(NSString*)host completeBlock:(void(^)(NSError *error)) completeBlock;

/**
 *  设置第三方用户id  建议使用用户id保持唯一性
 *  @param third_party_user_id  第三方用户id 使用您的App登录后获得用户id即可
 */
+ (BOOL) setThirdPartyUserId:(NSString *)third_party_user_id;

/**
 *  设置第三方用户id  建议使用用户id保持唯一性
 *  @param third_party_user_id  第三方用户id 使用您的App登录后获得用户id即可
 *  @param context 对应third_party_user_id 自定义信息用于接IM收消息的context中，如：@{@"nick_name":@"xxxx",@"avatar":@"xxxx"};
     为 nil 时，聊天消息会读取通过API设置nick_name和avatar。
 */
+ (BOOL) setThirdPartyUserId:(NSString *)third_party_user_id context:(NSDictionary*)context;

/**
 *  设置日志等级
 *  @param level  日志等级
 */
+ (void) setLogLevel:(VHLogLevel)level;

/**
 *  设置日志是否输出到控制台
 *  @param isPrint  否输出到控制台
 */
+ (void) printLogToConsole:(BOOL)isPrint;//默认不显示到控制台、

/**
 *  设置AppGroup 用于 录屏直播功能
 *  @param appGroup  AppGroup
 */
+ (BOOL) setAppGroup:(NSString *)appGroup;

/**
 *  当前SDK 是否已初始化
 */
+ (BOOL) isInited;


/**
 *  获得当前SDK 基础模块版本号
 */
+ (NSString *) getSDKVersion;

@end
