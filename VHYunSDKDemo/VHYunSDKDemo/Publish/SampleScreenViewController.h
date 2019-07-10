//
//  SampleScreenViewController.h
//  VHYunSDKDemo
//
//  Created by vhall on 2019/6/6.
//  Copyright © 2019 www.vhall.com. All rights reserved.
//

#import "VHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SampleScreenViewController : VHBaseViewController
@property(nonatomic,copy)   NSString        *roomId;
@property(nonatomic,copy)   NSString        *accessToken;
@property(nonatomic,assign) NSInteger       videoBitRate;
@property(nonatomic,assign) NSInteger       videoCaptureFPS;//固定15帧
@end

NS_ASSUME_NONNULL_END
