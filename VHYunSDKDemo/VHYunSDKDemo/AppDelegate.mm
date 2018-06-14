//
//  AppDelegate.m
//  VHYunSDKDemo
//
//  Created by vhall on 2017/11/16.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import "AppDelegate.h"
#import <objc/message.h>
#import "VHStatisticsStystem.h"

@interface AppDelegate ()
{
    dispatch_source_t _timer;
}
@property (nonatomic,strong)UILabel *netInfoLabel;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    DEMO_Test
//    [VHLiveBase setLogLevel:VHLogLevelError];
//    [VHLiveBase printLogToConsole:YES];
    
    NSLog(@"SDKVersion: %@",[VHLiveBase getSDKVersion]);
    [self showProcessInfo];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)showProcessInfo{
#ifdef SHOW_CPU_INFO
    __weak typeof(self) wf = self;
    dispatch_queue_t queue = dispatch_queue_create("my queue", 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), 1 * NSEC_PER_SEC, 0);//间隔1秒
    dispatch_source_set_event_handler(_timer, ^()
                                      {
                                          NSString *strInfo = @"";
                                          NSArray* arr = [[VHStatisticsStystem sharedManager]getDataCounters];
                                          if(arr)
                                          {
                                              strInfo = [NSString stringWithFormat:@"WIFI:↑%d ↓%d WWAN:↑%d ↓%d (KB/s)", [arr[0] intValue]/1024,[arr[1] intValue]/1024,[arr[2] intValue]/1024,[arr[3] intValue]/1024];
                                          }
                                          
                                          float cpu = [[VHStatisticsStystem sharedManager]cpu_usage];
                                          double availableMemory = [[VHStatisticsStystem sharedManager]availableMemory];
                                          double usedMemory = [[VHStatisticsStystem sharedManager]usedMemory];
                                          
                                          strInfo = [strInfo stringByAppendingFormat:@" CPU:%.1f%% MEM:%d/%d(M)",cpu,(int)usedMemory,(int)availableMemory];
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              if(wf.netInfoLabel == nil)
                                              {
                                                  wf.netInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, [[UIScreen mainScreen] bounds].size.width, 20)];
                                                  wf.netInfoLabel.textColor = [UIColor redColor];
                                                  wf.netInfoLabel.font = [UIFont systemFontOfSize:7];
                                                  [wf.window addSubview:wf.netInfoLabel];
                                              }
                                              wf.netInfoLabel.text = strInfo;
                                          });
                                      });
    dispatch_resume(_timer);
#endif
}

@end
