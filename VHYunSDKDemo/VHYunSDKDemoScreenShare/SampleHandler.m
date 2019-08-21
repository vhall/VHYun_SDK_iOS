//
//  SampleHandler.m
//  VHYunSDKDemoScreenShare
//
//  Created by vhall on 2019/6/6.
//  Copyright © 2019 www.vhall.com. All rights reserved.
//


#import "SampleHandler.h"
#import <VHScreenShare/VHScreenShareService.h>

@interface SampleHandler()<VHScreenShareServiceDelegate>
@property (nonatomic,strong)VHScreenShareService *screenShareService;
@end


@implementation SampleHandler
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.screenShareService = [[VHScreenShareService alloc]initWithAppGroup:@""];
        self.screenShareService.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    self.screenShareService = nil;
}


- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *,NSObject *> *)setupInfo {
    // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
    [self.screenShareService broadcastStartedWithSetupInfo:setupInfo];
}

- (void)broadcastPaused {
    // User has requested to pause the broadcast. Samples will stop being delivered.
    [self.screenShareService broadcastPaused];
}

- (void)broadcastResumed {
    // User has requested to resume the broadcast. Samples delivery will resume.
    [self.screenShareService broadcastResumed];
}

- (void)broadcastFinished {
    // User has requested to finish the broadcast.
    [self.screenShareService broadcastFinished];
}

- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
    
    [self.screenShareService processSampleBuffer:sampleBuffer withType:sampleBufferType];
}
- (void)VHScreenShareServiceFinishBroadcastWithError:(NSError *)error
{
    [self finishBroadcastWithError:error];
}
@end
