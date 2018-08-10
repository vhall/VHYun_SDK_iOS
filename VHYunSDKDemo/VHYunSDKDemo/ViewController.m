//
//  ViewController.m
//  VHYunSDKDemo
//
//  Created by vhall on 2017/11/16.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//
#import <objc/message.h>
#import "ViewController.h"
#import "PublishViewController.h"
#import "WatchViewController.h"
#import "WatchVodViewController.h"

#import "DocumentViewController.h"
#import "VodDocumentViewController.h"

#import "IMViewController.h"

#import "VHInteractiveViewController.h"

#import "VHSettingViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *verLabel;
@property (weak, nonatomic) IBOutlet UILabel *bundleIDLabel;

@end

@implementation ViewController
 - (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _verLabel.text = [NSString stringWithFormat:@"SDK ver:%@",[VHLiveBase getSDKVersion]];
    _bundleIDLabel.text = [NSString stringWithFormat:@"BundleID: %@",[NSBundle mainBundle].bundleIdentifier];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入AppID" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
//    UITextField *txtName = [alert textFieldAtIndex:0];
//    txtName.placeholder = DEMO_AppID;
//    [alert show];
     
     [VHLiveBase registerApp:DEMO_AppID];
     [VHLiveBase setThirdPartyUserId:DEMO_third_party_user_id];
}

#pragma mark - 点击代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        UITextField *txt = [alertView textFieldAtIndex:0];
        if(txt.text.length > 0)
        {
            //获取txt内容即可
            [VHLiveBase registerApp:txt.text];
            [VHLiveBase setThirdPartyUserId:DEMO_third_party_user_id];
            [self showMsg:[@"AppID：" stringByAppendingString:txt.text] afterDelay:2];
        }
        else
        {
            [self showMsg:[@"AppID：" stringByAppendingString:DEMO_AppID] afterDelay:2];
            //获取txt内容即可
            [VHLiveBase registerApp:DEMO_AppID];
            [VHLiveBase setThirdPartyUserId:DEMO_third_party_user_id];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 推流
- (IBAction)publishBtnClicked:(UIButton*)sender {
    PublishViewController * rtmpLivedemoVC = [[PublishViewController alloc] init];
    rtmpLivedemoVC.videoResolution  = 2;
    rtmpLivedemoVC.roomId           = DEMO_Setting.publishRoomID;
    rtmpLivedemoVC.accessToken      = DEMO_Setting.accessToken;
    rtmpLivedemoVC.videoBitRate     = DEMO_Setting.videoBitRate*1000;
    rtmpLivedemoVC.videoCaptureFPS  = DEMO_Setting.videoCaptureFPS;
    rtmpLivedemoVC.interfaceOrientation = (sender.tag == 1)?UIInterfaceOrientationLandscapeRight :UIInterfaceOrientationPortrait;
    rtmpLivedemoVC.isOpenNoiseSuppresion = YES;
    [self presentViewController:rtmpLivedemoVC animated:YES completion:nil];
}

#pragma mark - 观看直播
- (IBAction)watchBtnClicked:(UIButton*)sender {
    WatchViewController * watchVC = [[WatchViewController alloc] init];
    watchVC.roomId      = DEMO_Setting.playerRoomID;
    watchVC.accessToken = DEMO_Setting.accessToken;
    watchVC.bufferTime  = DEMO_Setting.bufferTime;
    [self presentViewController:watchVC animated:YES completion:nil];
}

#pragma mark - 观看回放
- (IBAction)watchVodBtnClicked:(UIButton*)sender {
    WatchVodViewController * watchVC = [[WatchVodViewController alloc] init];
    watchVC.recordID    = DEMO_Setting.recordID;
    watchVC.accessToken = DEMO_Setting.accessToken;
    [self presentViewController:watchVC animated:YES completion:nil];
}

#pragma mark - 直播文档
- (IBAction)documentBtnClicked:(UIButton *)sender {
    DocumentViewController * vc = [[DocumentViewController alloc] init];
    vc.channelID    = DEMO_Setting.docChannelID;
    vc.accessToken  = DEMO_Setting.accessToken;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - 点播文档
- (IBAction)vodDocumentBtnClicked:(UIButton *)sender {
    VodDocumentViewController * vc = [[VodDocumentViewController alloc] init];
    vc.recordID      = DEMO_Setting.recordID;
    vc.accessToken   = DEMO_Setting.accessToken;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - IM消息
- (IBAction)imBtnClicked:(UIButton *)sender {
    IMViewController * vc = [[IMViewController alloc] init];
    vc.channelID    = DEMO_Setting.imChannelID;
    vc.accessToken  = DEMO_Setting.accessToken;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - 互动
- (IBAction)interactiveBtnClicked:(UIButton *)sender {
    VHInteractiveViewController * vc = [[VHInteractiveViewController alloc] init];
    vc.ilssRoomID       = DEMO_Setting.ilssRoomID;
    vc.ilssType         = DEMO_Setting.ilssType;        //摄像头及推流参数设置
    vc.ilssOptions      = DEMO_Setting.ilssOptions;     //摄像头及推流参数设置
    vc.accessToken      = DEMO_Setting.accessToken;
    vc.anotherLiveRoomId= DEMO_Setting.ilssLiveRoomID;
//    vc.anotherLiveRoomID= DEMO_Setting.anotherLiveRoomID;
    vc.myName           = [UIDevice currentDevice].name;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 设置
- (IBAction)settingBtnClicked:(UIButton *)sender {
    VHSettingViewController * settingVC = [[VHSettingViewController alloc] init];
    [self presentViewController:settingVC animated:YES completion:nil];
}

@end
