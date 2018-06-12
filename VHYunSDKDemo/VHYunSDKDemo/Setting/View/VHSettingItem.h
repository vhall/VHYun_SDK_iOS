//
//  VHSettingItem.h
//  VHYunSDKDemo
//
//  Created by vhall on 2017/12/19.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface VHSettingItem : NSObject
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong)  void(^operation)(NSIndexPath *indexPath);
+(instancetype)itemWithTitle:(NSString*)title;
@property(nonatomic,strong) NSIndexPath   *indexPath;
@end
