//
//  VHSettingGroup.h
//  VHYunSDKDemo
//
//  Created by vhall on 2017/12/19.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VHSettingGroup : NSObject
@property(nonatomic,strong) NSArray *items;
@property(nonatomic,copy)   NSString *headerTitle;
@property(nonatomic,copy)   NSString *footTitle;
+(instancetype)groupWithItems:(NSArray*)items;
@end
