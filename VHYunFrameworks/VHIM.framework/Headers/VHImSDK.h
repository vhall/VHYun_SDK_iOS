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

typedef NS_ENUM(NSInteger, VHIMMessageType) {
    VHIMMessageTypeText,    //文本消息
    VHIMMessageTypeImage,   //图片消息
    VHIMMessageTypeLink,    //URL消息
    VHIMMessageTypeVideo,   //视频消息 暂不支持
    VHIMMessageTypeVoice,   //语音消息 暂不支持
};

@interface VHImSDK : NSObject
@property (nonatomic,weak)id <VHImSDKDelegate>      delegate;
/**
 * IM模块初始化
 */
- (instancetype)initWithChannelID:(NSString*)channelID accessToken:(NSString*)accessToken delegate:(id <VHImSDKDelegate>)delegate;

/**
 * 发送文本消息
 * @param message   IM消息 最长200字
 */
- (void)sendMessage:(NSString*)message completed:(void (^)(NSError *error))completed;

/**
 * 发送图片、连接等消息
 * @param message IM图片等消息 VHIMMessageTypeImage时传入 NSArray 内部为 图片URL 字符串， VHIMMessageTypeLink连接传入 URL 字符串，
 * @param type   IM消息类型 VHIMMessageType
 * @param text   IM文本消息 最长200字
 */
- (void)sendMessage:(id)message type:(VHIMMessageType)type text:(NSString*)text completed:(void (^)(NSError *error))completed;

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
 *  @param message   chat消息  data中聊天消息格式  说明详见本文件底部注释
 */
- (void)imSDK:(VHImSDK *)imSDK receiveChatMessage:(VHMessage*)message;

/**
 *  接收上下线消息
 *  @param imSDK IM实例
 *  @param message   消息
 *  注意： 消息中的头像和昵称需要 设置 [VHLiveBase setThirdPartyUserId:@"xxxx" context:@{@"nick_name":@"xxxx",@"avatar":@"xxxx"}]; 才能收到
 */
- (void)imSDK:(VHImSDK *)imSDK receiveOnlineMessage:(VHMessage*)message;

/**
 *  接收自定义消息
 *  @param imSDK IM实例
 *  @param message   自定义消息
 */
- (void)imSDK:(VHImSDK *)imSDK receiveCustomMessage:(VHMessage*)message;

/**
 *  接收room消息
 *  @param imSDK IM实例
 *  @param message   room消息
 */
- (void)imSDK:(VHImSDK *)imSDK receiveRoomMessage:(VHMessage*)message;

/**
 *  错误回调
 *  @param imSDK IM实例
 *  @param error    错误
 */
- (void)imSDK:(VHImSDK *)imSDK error:(NSError *)error;

#pragma mark - 兼容v1.8.0 之前版本消息回调 请尽快升级到新的回调接口
/**
 *  接收IM消息
 *  @param imSDK IM实例
 *  @param message   IM消息
 *  注意：请尽快使用 imSDK: receiveChatMessage: 接收 聊天消息。支持更多功能
 */
- (void)imSDK:(VHImSDK *)imSDK receiveMessage:(VHMessage*)message;

/**
 *  上下线消息
 *  @param imSDK IM实例
 *  @param message   消息
 *  注意：请尽快使用 imSDK: receiveOnlineMessage: 接收 上下线消息
 */
- (void)imSDK:(VHImSDK *)imSDK onlineMessage:(VHMessage*)message;
@end

/*
聊天消息格式说明
 type 聊天消息类型：
 {
     text    文本消息
     image    图片消息
     link    URL链接
     video    视频消息
     voice    语音消息
     disable    禁言某个用户
     disable_all    全员禁言
     permit    取消禁言某个用户
     permit_all    取消全员禁言
 }
 text_content    文本内容    文本消息
 image_url    图片URL地址    图片消息
 image_urls    多个图片URL地址    批量发送图片消息
 link_url    链接URL地址    URL链接
 video_url    视频文件地址    视频消息
 voice_url    语音音频文件地址    语音消息
 target_id    被禁言或者被取消禁言的目标用户ID    禁言某个用户、取消禁言某个用户
*/
