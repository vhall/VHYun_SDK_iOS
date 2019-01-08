//
//  LaunchLiveViewController.h
//  VHYunSDKDemo
//
//  Created by vhall on 2017/11/16.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//


#import "PublishViewController.h"
#import <AVFoundation/AVFoundation.h>
#include "VHLivePublisher.h"

@interface PublishViewController ()<VHLivePublisherDelegate>
{
    BOOL  _isVideoStart;
    BOOL  _isAudioStart;
    BOOL  _torchType;
    BOOL  _onlyVideo;
    BOOL  _isFontVideo;
    UIButton * _lastFilterSelectBtn;

    dispatch_source_t _timer;

}
@property (assign, nonatomic)long             liveTime;
@property (strong, nonatomic)VHLivePublisher *publisher;
@property (weak, nonatomic) IBOutlet UIView *perView;
@property (weak, nonatomic) IBOutlet UIImageView *logView;
@property (weak, nonatomic) IBOutlet UILabel *bitRateLabel;
@property (weak, nonatomic) IBOutlet UIButton *videoStartAndStopBtn;
@property (weak, nonatomic) IBOutlet UIButton *torchBtn;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;
@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UIButton *defaultFilterSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *hideKeyBtn;
@end

@implementation PublishViewController

#pragma mark - Lifecycle
- (id)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        [self initDatas];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initViews];
    //初始化CameraEngine
    [self initCameraEngine];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (_publisher) {
        _publisher = nil;
    }
    
    //允许iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
//    VHLog(@"%@ dealloc",[[self class]description]);
}

-(void)LaunchLiveWillResignActive
{
    [_publisher pause];
}

-(void)LaunchLiveDidBecomeActive
{
    [self performSelector:@selector(resume) withObject:nil afterDelay:1];
}
- (void)resume
{
    [_publisher resume];
}

- (IBAction)closeBtnClick:(id)sender
{
    if (_publisher.isPublishing)
    {
        [_publisher stopCapture];
    }
    [_publisher destoryObject];
    self.publisher = nil;
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self.navigationController popViewControllerAnimated:NO];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
        return UIInterfaceOrientationMaskPortrait;
    }else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }else
    {
        return UIInterfaceOrientationMaskLandscapeLeft;
    }
}
#pragma mark - Lifecycle(Private)

- (void)registerLiveNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LaunchLiveWillResignActive)name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LaunchLiveDidBecomeActive)name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)initDatas
{
    _isVideoStart = NO;
    _isAudioStart = NO;
    _torchType = NO;
    _onlyVideo = NO;
    _isFontVideo = NO;
    _videoResolution = VHHVideoResolution;
}

- (void)initViews
{
    //阻止iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self registerLiveNotification];
    [self.perView addSubview:_closeBtn];
    
    _filterBtn.hidden = YES;
}

- (void)viewDidLayoutSubviews
{
    self.publisher.preView.frame = _perView.bounds;
}

#pragma mark - Camera
- (void)initCameraEngine
{
    VHDeviceOrientation deviceOrientation;
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        deviceOrientation = VHDevicePortrait;
    }else {
        deviceOrientation = VHDeviceLandSpaceLeft;//设备左转，摄像头在左边
    }
    
    _torchBtn.hidden = YES;
    _isFontVideo = YES;

    VHPublishConfig* config = [VHPublishConfig configWithType:VHPublishConfigTypeDefault];
    config.orientation = deviceOrientation;
    config.captureDevicePosition = AVCaptureDevicePositionFront;
    config.publishConnectTimes = 1;
    config.videoBitRate = self.videoBitRate;
    config.videoCaptureFPS = self.videoCaptureFPS;
    config.isOpenNoiseSuppresion = DEMO_Setting.isOpenNoiseSuppresion;
    config.volumeAmplificateSize = DEMO_Setting.volumeAmplificateSize;
    config.videoResolution = _videoResolution;
    
    self.publisher = [[VHLivePublisher alloc] initWithConfig:config];
    self.publisher.delegate            = self;
    self.publisher.preView.frame = _perView.bounds;
    [self.perView insertSubview:self.publisher.preView atIndex:0];

    //开始视频采集、并显示预览界面
    [self.publisher startCapture];
}

- (IBAction)swapBtnClick:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    btn.enabled=NO;
    _isFontVideo = !_isFontVideo;
    if(_isFontVideo)
    {
        _torchType = NO;
        _torchBtn.selected = _torchType;
    }

    BOOL success=  [_publisher switchCamera:_isFontVideo ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack];
    if(success)
    {
        _torchBtn.hidden = _isFontVideo;
        //禁止快速切换摄像头
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            btn.enabled=YES;
        });
    }
}

- (IBAction)torchBtnClick:(UIButton*)sender
{
    _torchType = !_torchType;
    sender.selected = _torchType;
    [_publisher torchMode:_torchType ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
}

- (IBAction)onlyVideoBtnClick:(UIButton*)sender
{
    _onlyVideo = !_onlyVideo;
    sender.selected = _onlyVideo;
    _publisher.enableMute = _onlyVideo;
}

- (BOOL)emCheckMicrophoneAvailability{
    __block BOOL ret = NO;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
        [session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            ret = granted;
        }];
    } else {
        ret = YES;
    }
    return ret;
}

- (IBAction)startVideoPlayer
{
#if (TARGET_IPHONE_SIMULATOR)
    [self showMsg:@"无法在模拟器上发起直播！" afterDelay:1.5];
    return;
#endif
    
    if (!_isVideoStart)
    {
        [self showProgressDialog:self.perView];
        [_publisher startPublish:self.roomId accessToken:self.accessToken];
    }else{
        _isVideoStart=NO;
        [self stopPublish];
    }
    _logView.hidden = YES;
    //_isVideoStart = !_isVideoStart;
}

- (void)stopPublish
{
    _bitRateLabel.text = @"";
    
    [self hideProgressDialog:self.perView];
    _videoStartAndStopBtn.selected = NO;
    [_publisher stopPublish];//停止活动
    _infoView.hidden = YES;
    _closeBtn.hidden = NO;
}

#pragma mark - VHLivePublisherDelegate
-(void)firstCaptureImage:(UIImage *)image
{
    NSLog(@"第一张图片");
}

- (void)onPublishStatus:(VHPublishStatus)status info:(NSDictionary*)info
{
    NSLog(@"状态：%ld %@",(long)status,info);

    switch (status) {
        case VHPublishStatusPushConnectSucceed:
        {
            [self hideProgressDialog:self.perView];
            
            [self showTimeInfo];
            _isVideoStart = YES;
            _videoStartAndStopBtn.selected = YES;
            _infoView.hidden = NO;
            _closeBtn.hidden = YES;
        }
            break;
        case VHPublishStatusUploadSpeed:
            _bitRateLabel.text = [NSString stringWithFormat:@"%@ kb/s",info[@"content"]];
            break;
        case VHPublishStatusUploadNetworkException:
            _bitRateLabel.textColor = [UIColor redColor];
            break;
        case VHPublishStatusUploadNetworkOK:
            _bitRateLabel.textColor = [UIColor greenColor];
            break;
        default:
            break;
    }
}

- (void)onPublishError:(VHPublishError)error info:(NSDictionary*)info
{
    NSLog(@"错误：%ld %@",(long)error,info);
    [self showMsg:[NSString stringWithFormat:@"%@ %@",info[@"code"],info[@"content"]] afterDelay:2];
    
    [self stopPublish];
}

-(void)showTimeInfo{
    if(_timer)
    {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    _liveTime = 0;
    
    __weak typeof(self) wf = self;
    
    dispatch_queue_t queue = dispatch_queue_create("my queue", 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), 1 * NSEC_PER_SEC, 0);//间隔1秒
    dispatch_source_set_event_handler(_timer, ^(){
        wf.liveTime++;
        NSString *strInfo = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",wf.liveTime/3600,(wf.liveTime/60)%60,wf.liveTime%60];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(wf.timeLabel)
            {
                wf.timeLabel.text = strInfo;
            }
        });
    });
    dispatch_resume(_timer);
}

- (IBAction)hideKey:(id)sender {
 
}
@end
