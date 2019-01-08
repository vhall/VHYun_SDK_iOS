//
//  VHImSDK.h
//  VHImSDK
//
//  Created by vhall on 2017/12/19.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHMessage.h"

@protocol VHImSDKDelegate;

@interface VHImSDK : NSObject
@property (nonatomic,weak)id <VHImSDKDelegate>      delegate;
/**
 * IM模块初始化
 */
- (instancetype)initWithChannelID:(NSString*)channelID accessToken:(NSString*)accessToken delegate:(id <VHImSDKDelegate>)delegate;

/**
 * 发送消息
 * @param message   IM消息 最长200字
 */
- (void)sendMessage:(NSString*)message completed:(void (^)(NSError *error))completed;

/**
 *  获得当前SDK版本号
 */
+ (NSString *) getSDKVersion;
@end

@protocol VHImSDKDelegate <NSObject>
@optional
/**
 *  接收IM消息
 *  @param imSDK IM实例
 *  @param message   IM消息
 */
- (void)imSDK:(VHImSDK *)imSDK receiveMessage:(VHMessage*)message;

/**
 *  接收自定义消息
 *  @param imSDK IM实例
 *  @param message   自定义消息
 */
- (void)imSDK:(VHImSDK *)imSDK receiveCustomMessage:(VHMessage*)message;

/**
 *  上下线消息
 *  @param imSDK IM实例
 *  @param message   消息
 */
- (void)imSDK:(VHImSDK *)imSDK onlineMessage:(VHMessage*)message;

/**
 *  错误回调
 *  @param imSDK IM实例
 *  @param error    错误
 */
- (void)imSDK:(VHImSDK *)imSDK error:(NSError *)error;

@end
