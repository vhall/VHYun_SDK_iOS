//
//  BaseViewController.h
//  VHYunSDKDemo
//
//  Created by vhall on 2017/11/16.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VHBaseViewController : UIViewController
@property(nonatomic,assign)UIInterfaceOrientation interfaceOrientation;

- (void)showMsg:(NSString*)msg afterDelay:(NSTimeInterval)delay;
-(void) showRendererMsg:(NSString*)msg afterDelay:(NSTimeInterval)delay;

-(void)showProgressDialog:(UIView*)view;
-(void)hideProgressDialog:(UIView*)view;

- (NSString*)timeFormat:(NSTimeInterval)time;
@end
