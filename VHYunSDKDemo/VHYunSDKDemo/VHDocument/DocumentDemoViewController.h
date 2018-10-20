//
//  DocumentDemoViewController.h
//  VHYunSDKDemo
//
//  Created by vhall on 2018/10/15.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DocumentDemoViewController : VHBaseViewController
@property(nonatomic,copy)NSString * channelID;
@property(nonatomic,copy)NSString * roomID;
@property(nonatomic,copy)NSString * accessToken;
@property(nonatomic,assign)BOOL isPublish;
@end

NS_ASSUME_NONNULL_END
