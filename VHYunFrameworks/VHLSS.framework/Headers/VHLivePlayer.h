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

@class VHPlayerSkinView;

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

@protocol VHLivePlayerDelegate;

@interface VHLivePlayer : NSObject
- (instancetype)initWithLogParam:(NSDictionary*)logParam;
@property(nonatomic,weak)id <VHLivePlayerDelegate>  delegate;
@property(nonatomic,strong,readonly)UIView          *view;
@property(nonatomic,assign,readonly)int             playerState;//播放器状态  详见 VHPlayerStatus 的定义.
@property(nonatomic,assign)NSInteger                bufferTime; //设置缓冲区时间 默认 6秒 单位为秒 必须>0 值越小延时越小,卡顿增加
@property(nonatomic,assign)int                      timeout;             //RTMP链接的超时时间 默认5000毫秒，单位为毫秒
@property(assign,readonly)int                       realityBufferTime;    //获取播放实际的缓冲时间 即延迟时间 单位为毫秒
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

/**
 * 静音
 */
@property(nonatomic,assign)BOOL                     mute;

/**
 * 水印 ImageView 设置水印图片 及显示位置  注：只要使用了改属性 PaaS 控制台设置图片方式便失效
 */
@property (nonatomic,readonly) UIImageView* watermarkImageView;

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

/**
 *  获得当前SDK版本号
 */
+ (NSString *) getSDKVersion;
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
- (void)player:(VHLivePlayer *)player streamtype:(int)streamtype;

/**
 *  接收流中消息
 *
 *  @param player       player
 *  @param msg          流中消息 用于直播答题等消息
 */
- (void)player:(VHLivePlayer *)player receiveMessage:(NSDictionary*)msg;

/**
 *  直播消息 包括 MSG_Service_Type_Room 和 MSG_Service_Type_Online 消息
 *
 *  @param player       player
 *  @param msg         类型VHMessage.h 消息包括 MSG_Service_Type_Room 和 MSG_Service_Type_Online 消息 
 */
- (void)player:(VHLivePlayer *)player roomMessage:(id)msg;
@end
