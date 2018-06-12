//
//  VHLayoutItem.m
//  VHYunSDKDemo
//
//  Created by vhall on 2018/5/23.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import "VHLayoutItem.h"

@implementation VHLayoutItem

- (void)setView:(UIView *)view
{
    _view = view;
    if(_clickedItem)
    {
        UITapGestureRecognizer *tapSuperGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSuperView:)];
        dispatch_async(dispatch_get_main_queue(), ^{
            [view addGestureRecognizer:tapSuperGesture];
        });
    }
}

- (void)tapSuperView:(UITapGestureRecognizer *)gesture {
    if(_clickedItem)
        _clickedItem(self);
}

@end
