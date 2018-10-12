//
//  VHVodPlayer.h
//  VHVodPlayer
//
//  Created by vhall on 2017/11/23.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VHPlayerTypeDef.h"

@protocol VHVodPlayerDelegate;

@interface VHVodPlayer : NSObject
@property (nonatomic,weak)id <VHVodPlayerDelegate>      delegate;
@property (nonatomic,strong,readonly)UIView             *view;
@property (nonatomic,assign,readonly)int                playerState;//播放器状态  详见 VHPlayerStatus 的定义.

@property (nonatomic, readonly) NSTimeInterval          duration;
@property (nonatomic, readonly) NSTimeInterval          playableDuration;
@property (nonatomic, assign)   NSTimeInterval          currentPlaybackTime;
@property (nonatomic,assign)    int                     scalingMode;//设置画面的裁剪模式 VHPlayerScalingMode

@property(nonatomic,assign)int timeout;                 //链接的超时时间 默认10000毫秒，单位为毫秒

/**
 *  设置默认播放的清晰度 默认原画
 */
@property(nonatomic,assign)VHDefinition             defaultDefinition;

/**
 * 当前播放的清晰度 默认原画 只有在播放开始后调用 并在支持的清晰度列表中
 */
@property(nonatomic,assign)VHDefinition             curDefinition;

/**
 *  开始播放
 *  @param recordID       房间ID
 *  @param accessToken  accessToken
 */
- (BOOL)startPlay:(NSString*)recordID accessToken:(NSString*)accessToken;

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

/*
 seek 播放跳转到音视频流某个时间
 * time: 流时间，单位为秒
 */
- (BOOL)seek:(float)time;

/**
 *  销毁播放器
 */
- (BOOL)destroyPlayer;
@end

@protocol VHVodPlayerDelegate <NSObject>

@optional
/**
 *  观看状态回调
 *  @param player   播放器实例
 *  @param state   状态类型
 */
- (void)player:(VHVodPlayer *)player statusDidChange:(int)state;

/**
 *  当前点播支持的清晰度列表
 *  @param definitions   支持的清晰度列表
 *  @param definition    当前播放清晰度
 */
- (void)player:(VHVodPlayer *)player validDefinitions:(NSArray*)definitions curDefinition:(VHDefinition)definition;

/**
 *  错误回调
 *  @param player   播放器实例
 *  @param error    错误
 */
- (void)player:(VHVodPlayer *)player stoppedWithError:(NSError *)error;

/**
 *  当前播放器时间回调
 *  @param player   播放器实例
 *  @param currentTime    当前播放器时间回调
 */
- (void)player:(VHVodPlayer*)player currentTime:(NSTimeInterval)currentTime;
@end

