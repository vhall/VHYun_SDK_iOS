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

#import "VHSettingViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *verLabel;

@end

@implementation ViewController
 - (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _verLabel.text = [NSString stringWithFormat:@"v%@",[VHLiveBase getSDKVersion]];

    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入AppID" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
//    UITextField *txtName = [alert textFieldAtIndex:0];
//    txtName.placeholder = @"请输入AppID";
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
        }
        else
        {
            [self showMsg:@"输入AppID为空,使用系统默认AppID" afterDelay:2];
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
    rtmpLivedemoVC.accessToken      = DEMO_Setting.publishAccessToken;
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
    watchVC.accessToken = DEMO_Setting.playerAccessToken;
    watchVC.bufferTime  = DEMO_Setting.bufferTime;
    [self presentViewController:watchVC animated:YES completion:nil];
}

#pragma mark - 观看回放
- (IBAction)watchVodBtnClicked:(UIButton*)sender {
    WatchVodViewController * watchVC = [[WatchVodViewController alloc] init];
    watchVC.recordID    = DEMO_Setting.recordID;
    watchVC.accessToken = DEMO_Setting.vodAccessToken;
    [self presentViewController:watchVC animated:YES completion:nil];
}

#pragma mark - 直播文档
- (IBAction)documentBtnClicked:(UIButton *)sender {
    DocumentViewController * vc = [[DocumentViewController alloc] init];
    vc.channelID    = DEMO_Setting.docChannelID;
    vc.accessToken  = DEMO_Setting.docAccessToken;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - 点播文档
- (IBAction)vodDocumentBtnClicked:(UIButton *)sender {
    VodDocumentViewController * vc = [[VodDocumentViewController alloc] init];
    vc.recordID      = DEMO_Setting.recordID;
    vc.accessToken   = DEMO_Setting.vodAccessToken;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - IM消息
- (IBAction)imBtnClicked:(UIButton *)sender {
    IMViewController * vc = [[IMViewController alloc] init];
    vc.channelID    = DEMO_Setting.imChannelID;
    vc.accessToken  = DEMO_Setting.imAccessToken;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - 设置
- (IBAction)settingBtnClicked:(UIButton *)sender {
    VHSettingViewController * settingVC = [[VHSettingViewController alloc] init];
    [self presentViewController:settingVC animated:YES completion:nil];
}

@end
