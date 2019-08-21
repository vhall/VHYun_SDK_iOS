//
//  SampleScreenViewController.m
//  VHYunSDKDemo
//
//  Created by vhall on 2019/6/6.
//  Copyright © 2019 www.vhall.com. All rights reserved.
//
#import <ReplayKit/ReplayKit.h>
#import "SampleScreenViewController.h"
#import <VHLSS/VHScreenLivePublisher.h>

@interface SampleScreenViewController ()<VHLivePublisherDelegate>

@property (strong, nonatomic)VHScreenLivePublisher *publisher;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadSpeedLabel;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@end

@implementation SampleScreenViewController
- (void)dealloc
{
    [self stopPublish];
    if (_publisher) {
        _publisher = nil;
    }
    
    //允许iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //    VHLog(@"%@ dealloc",[[self class]description]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self initViews];
    //初始化CameraEngine
    [self initCameraEngine];
    
    [self startPublish];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)startBtnClikced:(id)sender {
    if(_startBtn.selected)
    {
        [self stopPublish];
        _statueLabel.text = @"已停止共享屏幕";
    }
    else
    {
        [self startPublish];
    }
}

- (IBAction)closeBtnClikced:(id)sender {
    [self stopPublish];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)startPublish
{
    //开始视频采集、并显示预览界面
    if([self.publisher startPublish:_roomId accessToken:_accessToken extension:@"com.vhallyun.sdk.VHYunSDKDemoScreenShare"]){
        
    }
    else
    {
        _statueLabel.text = @"输入参数错误或设备不支持";
    }

}

- (void)stopPublish
{
    [self hideProgressDialog:self.view];
    [_publisher stopPublish];
     _startBtn.selected = NO;
}

#pragma mark - Lifecycle(Private)

-(void)initDatas
{

}

- (void)initViews
{
    //阻止iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

#pragma mark - Camera
- (void)initCameraEngine
{
    self.publisher = [[VHScreenLivePublisher alloc] initWithConfig:[VHPublishConfig configWithType:VHPublishConfigTypeDefault]];
    self.publisher.delegate            = self;
}

#pragma mark - VHLivePublisherDelegate
-(void)firstCaptureImage:(UIImage *)image
{
    NSLog(@"第一张图片，%dx%d",(int)image.size.width,(int)image.size.height);
}

- (void)onPublishStatus:(VHPublishStatus)status info:(NSDictionary*)info
{
    NSLog(@"状态：%ld %@",(long)status,info);
    
    switch (status) {
        case VHPublishStatusPushConnectSucceed:
        {
            [self hideProgressDialog:self.view];
//            [self showMsg:@"VHPublishStatusPushConnectSucceed" afterDelay:1];
            _startBtn.selected = YES;
            _statueLabel.text = @"您正在共享屏幕";
        }
            break;
        case VHPublishStatusUploadSpeed:
            _uploadSpeedLabel.text = [NSString stringWithFormat:@"%@kb/s",info[@"content"]];
            break;
        case VHPublishStatusUploadNetworkException:

            break;
        case VHPublishStatusStoped:
            _startBtn.selected = NO;
            _statueLabel.text = @"已停止共享屏幕";
            [self closeBtnClikced:nil];
            break;

        default:
            break;
    }
}

- (void)onPublishError:(VHPublishError)error info:(NSDictionary*)info
{
    NSLog(@"错误：%ld %@",(long)error,info);
    _statueLabel.text = [NSString stringWithFormat:@"%@ %@",info[@"code"],info[@"content"]];
    [self showMsg:[NSString stringWithFormat:@"%@ %@",info[@"code"],info[@"content"]] afterDelay:2];
    
    [self stopPublish];
    _startBtn.selected = NO;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

@end
