//
//  NewVodDocumentViewController.h
//  VHYunSDKDemo
//
//  Created by vhall on 2017/12/14.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewVodDocumentViewController : VHBaseViewController
@property(nonatomic,copy)NSString * recordID;
@property(nonatomic,copy)NSString * accessToken;
@property(nonatomic, assign)BOOL      seekMode;
@end
