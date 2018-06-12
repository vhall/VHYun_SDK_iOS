//
//  VHInteractiveViewController+ClassLayout.h
//  VHYunSDKDemo
//
//  Created by vhall on 2018/5/23.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import "VHInteractiveViewController.h"

@interface VHInteractiveViewController (Layout)

//创建并展示本地摄像头画面
- (void)showLocalCamera;
- (void)closeLocalCamera;

- (void)muteMyVideo:(BOOL)isMute;
- (void)muteMyAudio:(BOOL)isMute;
- (void)switchCamera;


- (void)addView:(UIView*)view attributes:(id) attributes;
- (void)removeView:(UIView*)view;
- (void)removeAllViews;

//更新布局
- (void)updateUI;

@end
