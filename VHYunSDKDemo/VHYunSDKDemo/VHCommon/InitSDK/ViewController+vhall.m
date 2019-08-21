//
//  ViewController+vhall.m
//  VHYunSDKDemo_LSS
//
//  Created by vhall on 2019/7/19.
//  Copyright © 2019 vhall. All rights reserved.
//

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneXR            ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(828, 1792),[[UIScreen mainScreen] currentMode].size):NO)
#define iPhoneXSMAX         ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(1242, 2688),[[UIScreen mainScreen] currentMode].size):NO)

#import "ViewController+vhall.h"
#import "InitSDKViewController.h"
#import "VHStatisticsStystem.h"
#import "UIView+ITTAdditions.h"

#import <VHCore/VHLiveBase.h>
#import "VHStystemSetting.h"

dispatch_source_t _timer_g;

@implementation ViewController (vhall)
- (void)showInitSDKVC
{
    if(![VHLiveBase isInited])
    {
        InitSDKViewController *vc = [[InitSDKViewController alloc]init];
        [self presentViewController:vc animated:NO completion:nil];
        [self showProcessInfo];
    }
}

- (void)hideKeyBoard
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - CPU信息 使用私有API 无法上App Store
-(void)showProcessInfo{
    __weak typeof(self) wf = self;
    dispatch_queue_t queue = dispatch_queue_create("my queue", 0);
    _timer_g = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer_g, dispatch_time(DISPATCH_TIME_NOW, 0), 1 * NSEC_PER_SEC, 0);//间隔1秒
    dispatch_source_set_event_handler(_timer_g, ^(){
        NSString *strInfo = @"";
        NSArray* arr = [[VHStatisticsStystem sharedManager]getDataCounters];
        if(arr)
        {
            strInfo = [NSString stringWithFormat:@"wifi:↑%d↓%d wwan:↑%d↓%d(KB/s)", [arr[0] intValue]/1024,[arr[1] intValue]/1024,[arr[2] intValue]/1024,[arr[3] intValue]/1024];
        }
        
        float cpu = [[VHStatisticsStystem sharedManager]cpu_usage];
        double availableMemory = [[VHStatisticsStystem sharedManager]availableMemory];
        double usedMemory = [[VHStatisticsStystem sharedManager]usedMemory];
        
        strInfo = [strInfo stringByAppendingFormat:@"cpu:%.1f%% mem:%d/%d(M)",cpu,(int)usedMemory,(int)availableMemory];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [wf updateCpuInfo:strInfo];
        });
    });
    dispatch_resume(_timer_g);
}

- (void)updateCpuInfo:(NSString*)strInfo
{
    UIWindow *mainWindow = nil;
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        mainWindow = [app.delegate window];
    }
    else
    {
        mainWindow = [app keyWindow];
    }
    
    if(!mainWindow)return;
    
    UILabel *netInfoLabel = [mainWindow viewWithTag:10099999];
    if(!netInfoLabel)
    {
        netInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, [[UIScreen mainScreen] bounds].size.width, 20)];
        netInfoLabel.tag = 10099999;
        netInfoLabel.textColor = [UIColor redColor];
        netInfoLabel.font = [UIFont systemFontOfSize:7];
        [mainWindow addSubview:netInfoLabel];
    }
    float h = 0;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        h = (iPhoneX ||iPhoneXR||iPhoneXSMAX)? 25 : 10;
    }
    
    netInfoLabel.top = h;
    netInfoLabel.text = [NSString stringWithFormat:@"(%@)%@(%@)(%@)",
                         DEMO_Setting.appID,
                         strInfo,
                         DEMO_Setting.third_party_user_id,
                         [VHLiveBase getSDKVersion]];
}

@end
