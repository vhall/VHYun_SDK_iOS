//
//  IVHCapture.h
//  VHLssPublishSDK
//
//  Created by vhall on 2017/11/16.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#ifndef IVHCapture_h
#define IVHCapture_h
#import <AVFoundation/AVFoundation.h>

/**
 *  采集器状态
 */
typedef NS_ENUM(NSInteger,VHCaptureStatus)
{
    VHCaptureStatusInitialized   = 0,//默认状态
    VHCaptureStatusConfiged      = 1,//配置完成
    VHCaptureStatusStarted       = 2,//已开始采集
    VHCaptureStatusStoped        = 3 //已结束采集
};

@protocol IVHCapture;
@protocol IVHVideoCapture;
@protocol IVHAudioCapture;

@class    VHPublishConfig;

/**
 *  OutputSampleBufferBlock 自定义Capture 数据回调 CMSampleBufferRef版本  视频回调只支持CMSampleBufferRef格式封装的数据
 *
 * @param curCapture 当前采集器
 * @param sampleBuffer 采集到的数据
 */
typedef void(^OutputSampleBufferBlock)(id<IVHCapture> curCapture,CMSampleBufferRef sampleBuffer);

/**
 *  OutputDataBlock 自定义Capture 数据回调 CMSampleBufferRef版本 音频回调支持CMSampleBufferRef格式封装的数据 和 char* 数据
 *
 * @param curCapture 当前采集器
 * @param dataBuffer 采集到的数据
 * @param bufferSize 数据大小
 */
typedef void(^OutputDataBufferBlock)(id<IVHCapture> curCapture,char* dataBuffer,long bufferSize);

/**
 *  OnErrorBlock 自定义Capture 错误回调 类型为 VHPublishErrorCaptureError,    //  40000-49999 采集相关错误
 *
 * @param errorInfo 错误信息 @{@"code":@(4xxxx),@"content":@"xxxxxx"}
 */
typedef void(^OnErrorBlock)(NSDictionary* errorInfo);

@protocol IVHCapture <NSObject>

/**
 *  配置采集器
 *  @param config 配置参数
 */
- (BOOL) setConfig:(VHPublishConfig*)config;

/**
 *  设置数据回调
 *  @param block 采集到的数据通过block回调给VHLivePublisher
 */
- (void) setOutputSampleBufferBlock:(OutputSampleBufferBlock)block;

/**
 *  设置错误回调
 *  @param block 错误信息
 */
- (void) setErrorBlock:(OnErrorBlock)block;

/**
 *  开始采集数据
 */
- (BOOL) startCapture;

/**
 *  结束采集数据
 */
- (BOOL) stopCapture;

/**
 *  获取采集器状态
 */
- (VHCaptureStatus) getStatus;

/**
 *  释放采集器资源
 */
- (BOOL)destoryObject;
@end

@protocol IVHVideoCapture <NSObject,IVHCapture>


@end

@protocol IVHAudioCapture <NSObject,IVHCapture>

/**
 *  设置数据回调
 *  @param block 采集到的数据通过block回调给VHLivePublisher
 */
- (void) setOutputDataBufferBlock:(OutputDataBufferBlock)block;

@end

#endif /* IVHCapture_h */
