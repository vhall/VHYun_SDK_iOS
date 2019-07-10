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
 * 禁言/取消禁言
 * @param isForbidden YES 禁言、NO 取消禁言
 * @param targetId   操作的 第三方ID third_party_user_id
 */
- (void)forbidden:(BOOL)isForbidden targetId:(NSString*)targetId completed:(void (^)(NSError *error))completed;

/**
 * 全员禁言/取消全员禁言
 * @param isForbidden YES 禁言、NO 取消禁言
 */
- (void)forbiddenAll:(BOOL)isForbidden completed:(void (^)(NSError *error))completed;

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

/**
 *  接收room消息
 *  @param imSDK IM实例
 *  @param message   room消息
 */
- (void)imSDK:(VHImSDK *)imSDK receiveRoomMessage:(VHMessage*)message;
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
