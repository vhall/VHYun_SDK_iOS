//
//  VHSettingGroup.m
//  VHYunSDKDemo
//
//  Created by vhall on 2017/12/19.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//


#import "VHSettingGroup.h"

@implementation VHSettingGroup
+(instancetype)groupWithItems:(NSArray *)items
{
    VHSettingGroup *group = [[VHSettingGroup alloc] init];
    group.items = items;
    return group;
}
@end
