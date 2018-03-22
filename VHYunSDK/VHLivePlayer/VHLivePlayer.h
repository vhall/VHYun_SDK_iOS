//
//  VHLivePlayerSDK.h
//  VHLivePlayerSDK
//
//  Created by vhall on 2017/11/20.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import "VHPlayerTypeDef.h"

/**
 * 观看端错误事件
 */
typedef NS_ENUM(NSInteger,VHLivePlayErrorType)
{
    VHLivePlayErrorNone                 = -1,
    VHivePlayGetUrlError                = 0,    //获取服务器rtmpUrl错误
    VHLivePlayParamError                = 1,    //参数错误
    VHLivePlayRecvError                 = 2,    //接受数据错误
    VHLivePlayCDNConnectError           = 3,    //CDN链接失败
    VHLivePlayStopPublish               = 4,    //已停止推流
};

//流类型
typedef NS_ENUM(NSInteger,VHStreamType){
    VHStreamTypeNone = 0,
    VHStreamTypeVideoAndAudio,
    VHStreamTypeOnlyVideo,
    VHTypeOnlyAudio,
};

@protocol VHLivePlayerDelegate;

@interface VHLivePlayer : NSObject
@property(nonatomic,weak)id <VHLivePlayerDelegate>  delegate;
@property(nonatomic,strong,readonly)UIView          *view;
@property(nonatomic,assign,readonly)int             playerState;//播放器状态  详见 VHPlayerStatus 的定义.
@property(nonatomic,assign)NSInteger                bufferTime; //RTMP 的缓冲时间 默认 6秒 单位为秒 必须>0 值越小延时越小,卡顿增加
@property(nonatomic,assign)int timeout;     //RTMP链接的超时时间 默认5000毫秒，单位为毫秒
/**
 *  设置默认播放的清晰度 默认原画
 */
@property(nonatomic,assign)VHDefinition             defaultDefinition;

/**
 * 当前播放的清晰度 默认原画 只有在播放开始后调用 并在支持的清晰度列表中
 */
@property(nonatomic,assign)VHDefinition             curDefinition;

/*
 * 设置画面的裁剪模式 详见 VHPlayerScalingMode 的定义
 */
@property(nonatomic,assign)int                      scalingMode;
@property(nonatomic,assign)BOOL                     mute;


/**
 *  开始播放
 *  @param roomID       房间ID
 *  @param accessToken  accessToken
 */
- (BOOL)startPlay:(NSString*)roomID accessToken:(NSString*)accessToken;

/**
 *  暂停播放
 */
- (BOOL)pause;

/**
 *  恢复播放
 */
- (BOOL)resume;

/**
 *  结束播放
 */
- (BOOL)stopPlay;

/**
 *  销毁播放器
 */
- (BOOL)destroyPlayer;
@end

@protocol VHLivePlayerDelegate <NSObject>

@optional
/**
 *  观看状态回调
 *  @param player   播放器实例
 *  @param state   状态类型 详见 VHPlayerStatus 的定义.
 */
- (void)player:(VHLivePlayer *)player statusDidChange:(int)state;

/**
 *  错误回调
 *  @param player   播放器实例
 *  @param error    错误
 */
- (void)player:(VHLivePlayer *)player stoppedWithError:(NSError *)error;

/**
 *  播放过程中下载速度回调
 *  @param player   播放器实例
 *  @param speed    kb/s
 */
- (void)player:(VHLivePlayer *)player downloadSpeed:(NSString*)speed;

/**
 *  当前房间支持的清晰度列表
 *  @param definitions   支持的清晰度列表
 *  @param definition    当前播放清晰度
 */
- (void)player:(VHLivePlayer *)player validDefinitions:(NSArray*)definitions curDefinition:(VHDefinition)definition;

/**
 *  streamtype 观看流类型
 *
 *  @param player       player
 *  @param streamtype   观看流类型
 */
- (void)player:(VHLivePlayer *)player streamtype:(VHStreamType)streamtype;

/**
 *  接收流中消息
 *
 *  @param player       player
 *  @param msg          流中消息
 */
- (void)player:(VHLivePlayer *)player receiveMessage:(NSDictionary*)msg;

/**
 *  上下线消息
 *
 *  @param player       player
 *  @param msg          消息
 */
- (void)player:(VHLivePlayer *)player onlineMessage:(id)msg;
@end
