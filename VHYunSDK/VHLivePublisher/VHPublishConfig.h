//
//  VHPublishConfig.h
//  VHLssPublishSDK
//
//  Created by vhall on 2017/11/14.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

/**
 *  推流状态
 */
typedef NS_ENUM(NSInteger, VHallPublishStatus) {
    VHallPublishStatusNone,//
    VHallPublishStatusPushConnectSucceed,//直播连接成功
    VHallPublishStatusUploadSpeed,//直播上传速率
    VHallPublishStatusUploadNetworkException,//发起端网络环境差
    VHallPublishStatusUploadNetworkOK //发起端网络环境恢复正常
};

/**
 *  推流错误码
 */
typedef NS_ENUM(NSInteger, VHallPublishError) {
    VHallPublishErrorNone,
    VHallPublishErrorPusherError,       //  推流相关错误@{code："10001" ,content: "xxxxx"}
    VHallPublishErrorAuthError,         //  接口\验证等相关错误
    VHallPublishErrorParamError,        //  参数相关错误
    VHallPublishErrorCaptureError,      //  采集相关错误
};

/**
 *  推流类型
 */
typedef NS_ENUM(int,VHStreamType){
    VHStreamTypeNone = 0,
    VHStreamTypeVideoAndAudio,
    VHStreamTypeOnlyVideo,//暂不支持
    VHStreamTypeOnlyAudio,
};

#pragma mark - VHallLivePublisherDelegate

/**
 *  推流代理
 */
@protocol VHallLivePublisherDelegate <NSObject>

@optional
/**
 *  采集到第一帧的回调
 *  @param image 第一帧的图片
 */
-(void)firstCaptureImage:(UIImage*)image;

/**
 *  推流状态回调
 *  @param status   状态类型
 *  @param info     状态信息2
 */
- (void)onPublishStatus:(VHallPublishStatus)status info:(NSDictionary*)info;

/**
 *  错误回调
 *  @param error    错误类型
 *  @param info     错误信息
 */
- (void)onPublishError:(VHallPublishError)error info:(NSDictionary*)info;//@{code："" ,content: ""}

@end

#pragma mark - VHPublishConfig
/**
 *  config 模板
 */
typedef NS_ENUM(NSInteger,VHPublishConfigType)
{
    VHPublishConfigTypeDefault   = 0,//960x540 600K码率
    VHPublishConfigTypeHD        = 1 //1280x720 800K码率
};

/**
 * 摄像头取景方向
 */
typedef NS_ENUM(NSInteger,VHDeviceOrientation)
{
    VHDevicePortrait                    = 0,    //摄像头在上边
    VHDeviceLandSpaceLeft               = 1,    //摄像头在左边
    VHDeviceLandSpaceRight              = 2     //摄像头在右边 暂不支持
};

/**
 * 推流视频分辨率
 */
typedef NS_ENUM(NSInteger,VHVideoResolution)
{
    VHLowVideoResolution                = 0,    //低分边率  352*288
    VHGeneralVideoResolution            = 1,    //普通分辨率 640*480
    VHHVideoResolution                  = 2,    //高分辨率  960*540
    VHHDVideoResolution                 = 3     //超高分辨率 1280*720
};


@interface VHPublishConfig : NSObject

+ (VHPublishConfig*)configWithType:(VHPublishConfigType)type;

/**
 *  采集画面方向 默认VHDevicePortrait
 */
@property (nonatomic,assign)VHDeviceOrientation orientation;

/**
 *  mic 音频采样率
 */
@property (nonatomic,assign)NSInteger sampleRate;

/**
 *  mic 音频采样通道 默认位数 16位
 */
@property (nonatomic,assign)NSInteger channelNum;

/**
 *  推流连接的超时时间，单位为秒 默认5
 */
@property (nonatomic,assign)NSInteger publishConnectTimeout;

/**
 *  推流断开重连的次数 默认为 5
 */
@property (nonatomic,assign)NSInteger publishConnectTimes;

/**
 *  推流帧率 范围［10～30］小于摄像头采集帧率
 */
@property (nonatomic,assign)NSInteger videoCaptureFPS;

/**
 *  视频分辨率 默认值是VHHVideoResolution 960*540
 */
@property (nonatomic,assign)VHVideoResolution videoResolution;

/**
 *  视频码率设置
 */
@property (nonatomic,assign)NSInteger videoBitRate;

/**
 *  音频码率设置
 */
@property (nonatomic,assign)NSInteger audioBitRate;

/**
 * 是否开启噪声消除，默认开启，最高支持32k的音频采样率,直播前设置，当采样率大于32k时，自动关闭噪声消除
 * 注：开始直播后调用无效
 */
@property(assign,nonatomic)BOOL isOpenNoiseSuppresion;

/**
 * 音频增益
 */
@property(assign,nonatomic)float volumeAmplificateSize;

/**
 *  摄像头方向 默认 AVCaptureDevicePositionBack 代表后置摄像头 AVCaptureDevicePositionFront 代表前置摄像头
 */
@property (nonatomic,assign)AVCaptureDevicePosition captureDevicePosition;

/**
 * 美颜滤镜开关
 * 默认关闭 NO
 */
@property (nonatomic,assign)BOOL beautifyFilterEnable;

/**
 * 推流类型 默认VHStreamTypeVideoAndAudio
 */
@property (nonatomic,assign)VHStreamType pushType;

/**
 * 是否打印日志
 * 默认不打印 NO
 */
@property (nonatomic,assign)BOOL isPrintLog;

/**
 * 自定义参数 用于高级自定义采集模块
 */
@property (nonatomic,strong)NSDictionary* customParam;

@end
