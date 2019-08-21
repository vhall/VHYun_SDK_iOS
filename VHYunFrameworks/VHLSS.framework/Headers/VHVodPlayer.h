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

@class VHPlayerSkinView;
@protocol VHVodPlayerDelegate;

// 点播视播放器seek模式
typedef NS_ENUM(int,VHVodPlayerSeeekModel){
    VHVodPlayerSeeekModelDefault,     //默认seek，支持前进和后退seek
    VHVodPlayerSeeekModelPlayed,      //设置此值后，播放器只支持在播放过的时段seek
};

@interface VHVodPlayer : NSObject
- (instancetype)initWithLogParam:(NSDictionary*)logParam;
@property (nonatomic,weak)id <VHVodPlayerDelegate>      delegate;
@property (nonatomic,strong,readonly)UIView             *view;
@property (nonatomic,assign,readonly)int                playerState;//播放器状态  详见 VHPlayerStatus 的定义.

@property (nonatomic, readonly) NSTimeInterval          duration;
@property (nonatomic, readonly) NSTimeInterval          playableDuration;
@property (nonatomic, assign)   NSTimeInterval          currentPlaybackTime;
@property (nonatomic,assign)    int                     scalingMode;//设置画面的裁剪模式 VHPlayerScalingMode

@property(nonatomic,assign)int timeout;                 //链接的超时时间 默认10000毫秒，单位为毫秒
@property (nonatomic) float rate;//播放速率  0.50, 0.67, 0.80, 1.0, 1.25, 1.50, and 2.0

/**
 *  设置默认播放的清晰度 默认原画
 */
@property(nonatomic,assign)VHDefinition             defaultDefinition;

/**
 * 当前播放的清晰度 默认原画 只有在播放开始后调用 并在支持的清晰度列表中
 */
@property(nonatomic,assign)VHDefinition             curDefinition;
/**
 * 点播视播放器seek模式设置 注意：需要播放前调用
 */
@property (nonatomic, assign) VHVodPlayerSeeekModel seekModel;

/**
 * 水印 ImageView 设置水印图片 及显示位置  注：只要使用了改属性 PaaS 控制台设置图片方式便失效
 */
@property (nonatomic,readonly) UIImageView* watermarkImageView;

/**
 * 点播视播放器seek模式设置 注意：需要播放前调用
 * 如果是seekModel == VHVodPlayerSeeekModelPlayed 为指定播放过时间
 */
- (void)setSeekModel:(VHVodPlayerSeeekModel)seekModel maxTime:(NSTimeInterval)maxTime;

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
 *  销毁播放器，销毁播放器后需将VHVodPlayer对象制为nil。
 */
- (BOOL)destroyPlayer;

/**
 *  获得当前SDK版本号
 */
+ (NSString *) getSDKVersion;

/**
 *  获得当前时间视频截图
 */
- (void)takeVideoScreenshot:(void (^)(UIImage* image))screenshotBlock;

/**
 设置播放器皮肤
 @param skinView 播放器皮肤，继承于VHPlayerSkinView的子类view。
 @discussion 可继承VHPlayerSkinView自定义播放器皮肤，并实现父类的相关方法。也可不使用此方法，完全自定义播放器皮肤并添加到播放器view上。
 */
- (void)setPlayerSkinView:(VHPlayerSkinView *)skinView;

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

/**
 *  当前播放器 有文档回放
 *  @param player   播放器实例
 *  @param docChannels 文档channelID 列表
 */
- (void)player:(VHVodPlayer*)player docChannels:(NSArray*)docChannels;

@end

