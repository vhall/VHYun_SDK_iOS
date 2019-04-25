//
//  DemoViewController.h
//  VHYunSDKDemo
//
//  Created by vhall on 2017/11/16.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import "VHBaseViewController.h"

@interface PublishViewController : VHBaseViewController
@property(nonatomic,copy)   NSString        *roomId;
@property(nonatomic,copy)   NSString        *accessToken;
@property(nonatomic,assign) NSInteger       videoBitRate;
@property(nonatomic,assign) NSInteger       audioBitRate;
@property(nonatomic,assign) NSInteger       videoCaptureFPS;
@property(nonatomic,assign) BOOL            isOpenNoiseSuppresion;
@property(nonatomic,assign) long            videoResolution;//0 352*288; 1 640*480; 2 960*540; 3 1280*720
@property(nonatomic,assign) BOOL            beautifyFilterEnable;
@property(nonatomic,assign) float           volumeAmplificateSize;
@property(nonatomic,assign) BOOL            isOnlyAudio;
@end
