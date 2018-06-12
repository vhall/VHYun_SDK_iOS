//
//  VHSettingItem.m
//  VHYunSDKDemo
//
//  Created by vhall on 2017/12/19.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//


#import "VHSettingItem.h"

@implementation VHSettingItem
+(instancetype)itemWithTitle:(NSString *)title
{
    VHSettingItem *item = [[self alloc] init];
    item.title = title;
    return item;
}
@end
