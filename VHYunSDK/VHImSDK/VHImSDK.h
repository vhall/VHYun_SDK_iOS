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
- (instancetype)initWithChannelID:(NSString*)channelID accessToken:(NSString*)accessToken;

/**
 * 发送消息
 * @param message   IM消息 最长200字
 */
- (void)sendMessage:(NSString*)message completed:(void (^)(NSError *error))completed;
@end

@protocol VHImSDKDelegate <NSObject>

/**
 *  接收IM消息
 *  @param imSDK IM实例
 *  @param message   IM消息
 */
- (void)imSDK:(VHImSDK *)imSDK receiveMessage:(VHMessage*)message;

@optional
/**
 *  错误回调
 *  @param imSDK IM实例
 *  @param error    错误
 */
- (void)imSDK:(VHImSDK *)imSDK error:(NSError *)error;

@end
