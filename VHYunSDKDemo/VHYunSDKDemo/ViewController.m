//
//  ViewController.m
//  VHYunSDKDemo
//
//  Created by vhall on 2017/11/16.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//
#import <objc/message.h>
#import <AVFoundation/AVFoundation.h>

#import "ViewController.h"
#import "ViewController+vhall.h"

#import "PublishViewController.h"
#import "WatchViewController.h"
#import "WatchVodViewController.h"

#import "IMViewController.h"

#import "VHInteractiveViewController.h"

#import "VHSettingViewController.h"
#import "DocUploadViewController.h"

#import "SampleScreenViewController.h"

#import "NewDocumentDemoViewController.h"
#import "NewLiveDocumentViewController.h"
#import "NewVodDocumentViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *verLabel;
@property (weak, nonatomic) IBOutlet UILabel *bundleIDLabel;

@end

@implementation ViewController
 - (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     _verLabel.text = [NSString stringWithFormat:@"ver:%@ appID:%@",[VHLiveBase getSDKVersion],DEMO_Setting.appID];
    _bundleIDLabel.text = [NSBundle mainBundle].bundleIdentifier;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showInitSDKVC];
}
#pragma mark - 推流
- (IBAction)publishBtnClicked:(UIButton*)sender {
    if(![self isCaptureDeviceOK])
        return;
    PublishViewController * rtmpLivedemoVC = [[PublishViewController alloc] init];
    rtmpLivedemoVC.videoResolution  = DEMO_Setting.videoResolution.intValue;
    rtmpLivedemoVC.roomId           = DEMO_Setting.publishRoomID;
    rtmpLivedemoVC.accessToken      = DEMO_Setting.accessToken;
    rtmpLivedemoVC.videoBitRate     = DEMO_Setting.videoBitRate;
    rtmpLivedemoVC.audioBitRate     = DEMO_Setting.audioBitRate;
    rtmpLivedemoVC.videoCaptureFPS  = DEMO_Setting.videoCaptureFPS;
    rtmpLivedemoVC.interfaceOrientation  = (sender.tag == 1)?UIInterfaceOrientationLandscapeRight :UIInterfaceOrientationPortrait;
    rtmpLivedemoVC.isOpenNoiseSuppresion = DEMO_Setting.isOpenNoiseSuppresion;
    rtmpLivedemoVC.beautifyFilterEnable  = DEMO_Setting.isBeautifyFilterEnable;
    rtmpLivedemoVC.volumeAmplificateSize = DEMO_Setting.volumeAmplificateSize;
    rtmpLivedemoVC.isOnlyAudio           = DEMO_Setting.isOnlyAudio;
    
    rtmpLivedemoVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:rtmpLivedemoVC animated:YES completion:nil];
}

- (IBAction)screenShareBtnClicked:(UIButton*)sender {
    if([[UIDevice currentDevice] systemVersion].floatValue<12.0)
    {
        [self showMsg:@"请更新系统到 iOS 12" afterDelay:2];
        return;
    }
    
    SampleScreenViewController * sampleScreenVC = [[SampleScreenViewController alloc] init];
    sampleScreenVC.roomId           = DEMO_Setting.publishRoomID;
    sampleScreenVC.accessToken      = DEMO_Setting.accessToken;
    sampleScreenVC.videoBitRate     = DEMO_Setting.videoBitRate;
    sampleScreenVC.videoCaptureFPS  = DEMO_Setting.videoCaptureFPS;
    sampleScreenVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:sampleScreenVC animated:YES completion:nil];
}

#pragma mark - 观看直播
- (IBAction)watchBtnClicked:(UIButton*)sender {
    WatchViewController * watchVC = [[WatchViewController alloc] init];
    watchVC.roomId      = DEMO_Setting.playerRoomID;
    watchVC.accessToken = DEMO_Setting.accessToken;
    watchVC.bufferTime  = DEMO_Setting.bufferTime;
    watchVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:watchVC animated:YES completion:nil];
}

#pragma mark - 观看回放
- (IBAction)watchVodBtnClicked:(UIButton*)sender {
    WatchVodViewController * watchVC = [[WatchVodViewController alloc] init];
    watchVC.recordID    = DEMO_Setting.recordID;
    watchVC.accessToken = DEMO_Setting.accessToken;
    watchVC.seekMode    = DEMO_Setting.seekMode;
    watchVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:watchVC animated:YES completion:nil];
}

#pragma mark - 直播文档
- (IBAction)documentBtnClicked:(UIButton *)sender {
    NewDocumentDemoViewController * vc = [[NewDocumentDemoViewController alloc] init];
    vc.channelID    = DEMO_Setting.docChannelID;
    vc.accessToken  = DEMO_Setting.accessToken;
    vc.roomID       = DEMO_Setting.docRoomID;
    vc.isLoadLastDoc    = DEMO_Setting.isLoadLastDoc;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)liveDocumentBtnClicked:(UIButton *)sender {
    NewLiveDocumentViewController * vc = [[NewLiveDocumentViewController alloc] init];
    vc.channelID    = DEMO_Setting.docChannelID;
    vc.accessToken  = DEMO_Setting.accessToken;
    vc.roomID       = DEMO_Setting.docRoomID;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - 点播文档
- (IBAction)vodDocumentBtnClicked:(UIButton *)sender {
//    VodDocumentViewController * vc = [[VodDocumentViewController alloc] init];
    NewVodDocumentViewController * vc = [[NewVodDocumentViewController alloc] init];
    vc.recordID      = DEMO_Setting.recordID;
    vc.accessToken   = DEMO_Setting.accessToken;
    vc.seekMode      = DEMO_Setting.seekMode;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}
//文档上传
- (IBAction)DocUploadBtnClick:(UIButton *)sender {
    DocUploadViewController * vc = [[DocUploadViewController alloc] init];
    vc.accessToken = DEMO_Setting.accessToken;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - IM消息
- (IBAction)imBtnClicked:(UIButton *)sender {
    IMViewController * vc = [[IMViewController alloc] init];
    vc.channelID    = DEMO_Setting.imChannelID;
    vc.accessToken  = DEMO_Setting.accessToken;
    vc.roomID       = DEMO_Setting.publishRoomID;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - 互动
- (IBAction)interactiveBtnClicked:(UIButton *)sender {
    if(![self isCaptureDeviceOK])
        return;
    
    VHInteractiveViewController * vc = [[VHInteractiveViewController alloc] init];
    vc.ilssRoomID       = DEMO_Setting.ilssRoomID;
    vc.ilssType         = DEMO_Setting.ilssType;        //摄像头及推流参数设置
    vc.ilssOptions      = DEMO_Setting.ilssOptions;     //摄像头及推流参数设置
    vc.accessToken      = DEMO_Setting.accessToken;
    vc.anotherLiveRoomId= DEMO_Setting.ilssLiveRoomID;
//    vc.anotherLiveRoomID= DEMO_Setting.anotherLiveRoomID;
    vc.userData         = DEMO_Setting.userData;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 设置
- (IBAction)settingBtnClicked:(UIButton *)sender {
    VHSettingViewController * settingVC = [[VHSettingViewController alloc] init];
    settingVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:settingVC animated:YES completion:nil];
}


#pragma mark - 权限检查
//    iOS 判断应用是否有使用相机的权限
- (BOOL)isCaptureDeviceOK
{
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSString *errorStr = @"相机权限受限,请在设置中启用";
        [self showMsg:errorStr afterDelay:2];
        return NO;
    }
    
    mediaType = AVMediaTypeAudio;//读取媒体类型
    authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSString *errorStr = @"麦克风权限受限,请在设置中启用";
        [self showMsg:errorStr afterDelay:2];
        return NO;
    }
    
    return YES;
}


@end
