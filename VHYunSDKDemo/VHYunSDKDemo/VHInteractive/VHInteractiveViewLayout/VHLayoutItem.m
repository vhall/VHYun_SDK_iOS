//
//  VHLayoutItem.m
//  VHYunSDKDemo
//
//  Created by vhall on 2018/5/23.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import "VHLayoutItem.h"
#import <VHRTC/VHRenderView.h>

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

- (void)muteVideo:(BOOL)isMute;
{
    if([_view isKindOfClass:[VHRenderView class]] && !((VHRenderView*)_view).isLocal && !_isUserMuteVideo)//用户手动关闭后不用处理
    {
        if(isMute)
            [((VHRenderView*)_view) muteVideo];
        else
            [((VHRenderView*)_view) unmuteVideo];
    }
}
- (void)userMuteVideo:(BOOL)isMute//用户手动开启关闭视频
{
    if([_view isKindOfClass:[VHRenderView class]] && !((VHRenderView*)_view).isLocal)
    {
        _isUserMuteVideo=isMute;
        if(isMute)
            [((VHRenderView*)_view) muteVideo];
        else
            [((VHRenderView*)_view) unmuteVideo];
    }
}
@end
