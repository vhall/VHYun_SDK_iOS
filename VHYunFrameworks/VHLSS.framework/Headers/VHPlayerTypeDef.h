//
//  VHPlayerTypeDef.h
//  VHOpenSDK
//
//  Created by vhall on 2017/12/12.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#ifndef VHPlayerTypeDef_h
#define VHPlayerTypeDef_h

typedef NS_ENUM(NSInteger, VHPlayerStatus) {
    VHPlayerStatusUnkown,       //初始化时指定的状态，播放器初始化
    VHPlayerStatusLoading,      //加载中
    VHPlayerStatusPlaying,      //播放中
    VHPlayerStatusPause,        //播放暂停
    VHPlayerStatusStop,         //停止播放
    VHPlayerStatusComplete,     //本次播放完
};

typedef NS_ENUM(NSInteger, VHPlayerScalingMode) {
    VHPlayerScalingModeFill,      //将图像拉伸填充
    VHPlayerScalingModeAspectFit, //将图像等比例缩放，适配最长边，缩放后的宽和高都不会超过显示区域，居中显示，画面可能会留有黑边。
    VHPlayerScalingModeAspectFill,//将图像等比例铺满整个屏幕，多余部分裁剪掉，此模式下画面不会留黑边，但可能因为部分区域被裁剪而显示不全。
};

/**
 *  视频清晰度
 */
typedef NS_ENUM(NSInteger,VHDefinition) {
    VHDefinitionOrigin             = 0,    //原画
    VHDefinitionUHD                = 1,    //超高清
    VHDefinitionHD                 = 2,    //高清
    VHDefinitionSD                 = 3,    //标清
    VHDefinitionAudio              = 4,    //纯音频
};

#endif /* VHPlayerTypeDef_h */
