//
//  VHScreenShareService.h
//  VHScreenShare
//
//  Created by vhall on 2019/6/6.
//  Copyright © 2019 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReplayKit/ReplayKit.h>

@protocol VHScreenShareServiceDelegate;
@interface VHScreenShareService : NSObject
@property (nonatomic,weak)id <VHScreenShareServiceDelegate> delegate;
+ (NSString *) getSDKVersion;
- (instancetype)initWithAppGroup:(NSString *)appGroup;
- (instancetype)initWithAppGroup:(NSString *)appGroup isPrintLog:(BOOL)isPrintLog;

- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *,NSObject *> *)setupInfo;

- (void)broadcastPaused;

- (void)broadcastResumed;

- (void)broadcastFinished;

- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType;

@end
@protocol VHScreenShareServiceDelegate <NSObject>

@optional
- (void)VHScreenShareServiceFinishBroadcastWithError:(NSError*)error;

@end
