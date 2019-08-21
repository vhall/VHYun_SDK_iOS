//
//  VHLivePublisher.h
//  VHLivePublisher
//
//  Created by vhall on 2017/11/15.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "VHPublishConfig.h"
#import "IVHCapture.h"

typedef NS_ENUM(NSInteger, VHPublishStatus) {
    VHPublishStatusNone,//
    VHPublishStatusPushConnectSucceed,//直播连接成功
    VHPublishStatusUploadSpeed,//直播上传速率
    VHPublishStatusUploadNetworkException,//发起端网络环境差
    VHPublishStatusUploadNetworkOK, //发起端网络环境恢复正常
    VHPublishStatusStoped//发起端停止推流
};

typedef NS_ENUM(NSInteger, VHPublishError) {
    VHPublishErrorNone,
    VHPublishErrorPusherError,       //  推流相关错误@{code："10001" ,content: "xxxxx"}
    VHPublishErrorAuthError,         //  接口\验证等相关错误
    VHPublishErrorParamError,        //  参数相关错误
    VHPublishErrorCaptureError,      //  采集相关错误
};

@protocol VHLivePublisherDelegate;

@interface VHLivePublisher : NSObject

@property (nonatomic,weak)id <VHLivePublisherDelegate> delegate;

/**
 *  显示摄像头拍摄内容的View
 */
@property (nonatomic,strong,readonly)UIView * preView;

/**
 *  判断用户使用是前置还是后置摄像头
 */
@property (nonatomic,assign,readonly)AVCaptureDevicePosition captureDevicePosition;

/**
 *  获取推流参数
 */
@property (nonatomic,strong,readonly)VHPublishConfig* config;

/**
 *  静音
 */
@property (nonatomic,assign)BOOL enableMute;

/**
 *  推流前可设置视频码率
 */
@property (nonatomic,assign)int videoBitRate;

/**
 *  推流状态
 */
@property (nonatomic,assign,readonly)BOOL isPublishing;

/**
 *  初始化
 *  @param config  config参数
 */
- (instancetype)initWithConfig:(VHPublishConfig*)config;

/**
 *  初始化
 *  高级功能 自定义采集器
 *  @param config  config参数
 *  @param videoCapture  自定义视频采集器
 *  @param audioCapture  自定义音频采集器
 */
- (instancetype)initWithConfig:(VHPublishConfig*)config
                  videoCapture:(id<IVHVideoCapture>)videoCapture
                  audioCapture:(id<IVHAudioCapture>)audioCapture;
/**
 *  销毁初始化数据，同步销毁，如果感觉销毁太慢，可以开线程去销毁
 */
- (void)destoryObject;

/**
 *  开始采集数据 并预览
 */
- (BOOL)startCapture;

/**
 *  开始推流
 *  @param roomID       房间ID
 *  @param accessToken  accessToken
 */
- (BOOL)startPublish:(NSString*)roomID accessToken:(NSString*)accessToken;

/**
 *  暂停推流 如电话接入、进入后台等
 */
- (BOOL)pause;

/**
 *  恢复推流
 */
- (BOOL)resume;

/**
 *  停止推流
 */
- (BOOL)stopPublish;

/**
 *  停止采集数据
 */
- (BOOL)stopCapture;

/**
 *  切换前后摄像头
 *  @param captureDevicePosition  后置:AVCaptureDevicePositionBack 前置:AVCaptureDevicePositionFront
 *  @return 是否切换成功
 */
- (BOOL)switchCamera:(AVCaptureDevicePosition)captureDevicePosition;

/**
 *  缩放摄像头
 *  @param zoomSize  变焦取值范围[1.0 - xx] xx 是系统相机支持最大变焦值
 */
- (BOOL)zoomCamera:(CGFloat)zoomSize;

/**
 *  手动对焦
 *  @param point 对焦点 [x,y] [0.0 - 1.0]
 */
- (BOOL)focusCameraAtAdjustedPoint:(CGPoint)point;

/**
 *  闪光灯开关 前置摄像头时无效
 *  @param captureTorchMode 闪光灯模式
 */
- (BOOL)torchMode:(AVCaptureTorchMode)captureTorchMode;
/**
 *  预览填充模式
 */
- (void)setContentMode:(VHVideoCaptureContentMode)contentMode;

// 打开噪声抑制 直播开始后有效
-(void)openNoiseSuppresion:(BOOL)enable;

/**
 设置音频增益大小，注意只有当开启噪音消除时可用
 
 @param size 音频增益的大小 [0.0,1.0]
 */
- (void)setVolumeAmplificateSize:(float)size;

/**
 *  美颜参数设置
 *  VHPublishConfig beautifyFilterEnable为YES时设置生效 根据具体使用情况微调
 *  @param beautify   磨皮   默认 2.0f  取值范围[1.0, 10.0]  10.0 正常图片没有磨皮
 *  @param brightness 亮度   默认 1.20f 取值范围[0.0, 2.0]  1.0 正常亮度
 *  @param saturation 饱和度 默认 1.0f  取值范围[0.0, 2.0]  1.0 正常饱和度
 *  @param sharpness  锐化   默认 0.5f  取值范围[-4.0，4.0] 0.0 正常锐化
 */
- (void)setBeautify:(CGFloat)beautify Brightness:(CGFloat)brightness Saturation:(CGFloat)saturation Sharpness:(CGFloat)sharpness;

/**
 *  获得当前SDK版本号
 */
+ (NSString *) getSDKVersion;
@end

@protocol VHLivePublisherDelegate <NSObject>

@optional
/**
 *  采集到第一帧的回调 开始直播后第一帧，多次开始多次调用
 *  @param image 第一帧的图片
 */
-(void)firstCaptureImage:(UIImage*)image;

/**
 *  推流状态回调
 *  @param status   状态类型
 *  @param info     状态信息
 */
- (void)onPublishStatus:(VHPublishStatus)status info:(NSDictionary*)info;

/**
 *  错误回调
 *  @param error    错误类型
 *  @param info     错误信息
 */
- (void)onPublishError:(VHPublishError)error info:(NSDictionary*)info;//@{code："" ,content: ""}

@end

