//
//  VHStatisticsStystem.h
//  VhallRTCTest
//
//  Created by vhallrd01 on 14-8-5.
//  Copyright (c) 2014年 zhangxingming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VHStatisticsStystem : NSObject

@property (nonatomic,strong)NSString *iphoneIp;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
+ (VHStatisticsStystem *)sharedManager;
- (NSArray *)getDataCounters;
- (float)cpu_usage;
- (double)availableMemory;
- (double)usedMemory;
@end
