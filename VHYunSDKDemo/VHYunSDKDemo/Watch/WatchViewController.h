//
//  WatchViewController.h
//  VHYunSDKDemo
//
//  Created by vhall on 2017/11/22.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WatchViewController : VHBaseViewController
@property(nonatomic,copy)NSString * roomId;
@property(nonatomic,copy)NSString * accessToken;
@property(nonatomic, assign)NSInteger bufferTime; 
@end
