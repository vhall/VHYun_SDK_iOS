//
//  VHPlayerSkinView.h
//  VHLive
//
//  Created by vhall on 2019/8/20.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VHPlayerSkinView;

@protocol VHPlayerSkinViewDelegate <NSObject>

@required

/*! @abstract   点击播放/暂停按钮时，需实现此回调。
 @param skinView 播放器皮肤类对象
 */
- (void)skinViewPlayButtonAction:(VHPlayerSkinView *)skinView;

/*! @abstract   切换分辨率，需实现此回调。
 @param skinView 播放器皮肤类对象
 @param definition 分辨率
 */
- (void)skinView:(VHPlayerSkinView *)skinView willChnagedResolution:(NSInteger)definition;

/*! @abstract   切换倍速，需实现此回调。
 @param skinView 播放器皮肤类对象
 @param rate     倍速
 */
- (void)skinView:(VHPlayerSkinView *)skinView willChnagedPlayRate:(NSInteger)rate;

/*! @abstract   滑竿TouchBegan，需实现此回调。
 @param skinView 播放器皮肤类对象
 */
- (void)skinViewSliderTouchBegan:(VHPlayerSkinView *)skinView;

/*! @abstract   滑竿TouchEnded，需实现此回调。
 @param skinView 播放器皮肤类对象
 */
- (void)skinViewSliderTouchEnded:(VHPlayerSkinView *)skinView currentTime:(float)time;

@end





@interface VHPlayerSkinView : UIView


@property (nonatomic, weak) id <VHPlayerSkinViewDelegate> delegate;


/**
 播放状态，子类重写父类方法，接收播放器状态改变事件
 */
- (void)playerStatus:(int)state;
/**
 设置支持的分辨率，子类重写父类方法，接收播放器分辨率改变事件
 */
- (void)resolutionArray:(NSArray *)definitions curDefinition:(NSInteger)definition;
/**
 播放进度，子类重写父类方法，接收点播播放器播放时间信息
 */
- (void)setProgressTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime playableValue:(CGFloat)playable;




///显示控制
- (VHPlayerSkinView *)fadeShow;
- (void)fadeOut:(NSTimeInterval)delay;
- (void)cancelFadeOut;


@end









NS_ASSUME_NONNULL_END
