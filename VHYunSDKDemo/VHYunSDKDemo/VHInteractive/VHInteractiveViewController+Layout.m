//
//  VHInteractiveViewController+Layout.m
//  VHYunSDKDemo
//
//  Created by vhall on 2018/5/23.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import "VHInteractiveViewController+Layout.h"
#import "VHInteractiveViewController+Room.h"
#import "VHLayoutView_1vN.h"

@interface VHInteractiveButton:UIButton
@property(nonatomic,copy) NSString* streamId;
@end
@implementation VHInteractiveButton
@end

@implementation VHInteractiveViewController (Layout)
//静音某一路他人视频
- (void)muteRemoteVideo:(VHInteractiveButton*)sender{
    sender.selected = !sender.selected;
    [self muteVideo:sender.selected attendId:sender.streamId];
}
- (void)muteRemoteAudio:(VHInteractiveButton*)sender{
    sender.selected = !sender.selected;
    [self muteAudio:sender.selected attendId:sender.streamId];
}

#pragma mark - Public
- (void)showLocalCamera
{
    if(!self.cameraView)
    {
        CGRect bounds = [[UIScreen mainScreen]bounds];
        CGRect frame = CGRectMake(bounds.size.width-97-16, bounds.size.height-133-20, 97, 133);

        if(DEMO_Setting.isDouble)
        {
            self.ilssOptions = @{VHFrameResolutionTypeKey:@(VHFrameResolution480x360),
                                 VHStreamOptionStreamType:@(VHInteractiveStreamTypeAudioAndVideo),
                                 VHSimulcastLayersKey:@(2),
                                 VHMaxVideoBitrateKey:@(600),
                                 VHCurrentBitrateKey:@(300),
                                 VHMinBitrateKbpsKey:@(200)};
            self.cameraView = [[VHRenderView alloc]initCameraViewWithFrame:frame options:self.ilssOptions];
        }
        else
        {
            if(self.ilssType == VHPushTypeNone)
                self.cameraView = [[VHRenderView alloc]initCameraViewWithFrame: frame];
            else
                self.cameraView = [[VHRenderView alloc]initCameraViewWithFrame: frame pushType:self.ilssType options:self.ilssOptions];
        }

        self.cameraView.layer.borderWidth = 1;
        self.cameraView.layer.borderColor = MakeColor(200, 200, 200, 0.5).CGColor;
        
        __weak typeof(self) wf =self;
        [self.layoutView addRenderView:self.cameraView attributes:@"cameraView" clickedBlock:^(VHLayoutItem * _Nonnull item) {
            [wf.layoutView changePosWithItem:item room:wf.room];
        }];
        
        [self.cameraView setDeviceOrientation:[UIDevice currentDevice].orientation];
    }
}
- (void)closeLocalCamera
{
    [self.cameraView stopStats];
    self.cameraView = nil;
}

- (void)muteMyVideo:(BOOL)isMute
{
    if (isMute) {
        [self.cameraView muteVideo];
    }
    else
    {
        [self.cameraView unmuteVideo];
    }
}
- (void)muteMyAudio:(BOOL)isMute
{
    if (isMute) {
        [self.cameraView muteAudio];
    }
    else
    {
        [self.cameraView unmuteAudio];
    }
}
- (void)switchCamera
{
    [self.cameraView switchCamera];
}

- (void)muteVideo:(BOOL)isMute attendId:(NSString*)attendId
{
    VHRenderView *view = self.renderViewsById[attendId];
    [self.layoutView muteVideo:isMute view:view];
}

- (void)muteAudio:(BOOL)isMute attendId:(NSString*)attendId
{
    VHRenderView *view = self.renderViewsById[attendId];
    if (isMute) {
        [view muteAudio];
    }
    else
    {
        [view unmuteAudio];
    }
}

- (void)addView:(UIView*)view attributes:(id) attributes
{
    VHRenderView* attendView  = (VHRenderView* )view;
    
    if(!attendView.isLocal)
    {
        UILabel *label = [attendView viewWithTag:1001];
        if(!label)
        {
            label  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
            label.textColor = [UIColor redColor];
            label.font = [UIFont systemFontOfSize:9];
            label.adjustsFontSizeToFitWidth = YES;
            label.minimumScaleFactor = 0.5;
            label.tag = 1001;
            [attendView addSubview:label];
        }
        label.text = attendView.userId;
    
        VHInteractiveButton * muteBtn = [attendView viewWithTag:1002];
        if(!muteBtn)
        {
            muteBtn = [[VHInteractiveButton alloc] initWithFrame:CGRectMake(25, 0,25, 25)];
            [muteBtn setImage:[UIImage imageNamed:@"video_on"] forState:UIControlStateNormal];
            [muteBtn setImage:[UIImage imageNamed:@"video_off"] forState:UIControlStateSelected];
            [muteBtn addTarget:self action:@selector(muteRemoteVideo:) forControlEvents:UIControlEventTouchUpInside];
            muteBtn.tag = 1002;
            [attendView addSubview:muteBtn];
            muteBtn.right  = attendView.width-25;
            muteBtn.bottom = attendView.height;
        }
        muteBtn.streamId = attendView.streamId;
    
        VHInteractiveButton * muteBtn1 = [attendView viewWithTag:1003];
        if(!muteBtn1)
        {
            muteBtn1 = [[VHInteractiveButton alloc] initWithFrame:CGRectMake(0, 0,25, 25)];
            [muteBtn1 setImage:[UIImage imageNamed:@"speaker_on"] forState:UIControlStateNormal];
            [muteBtn1 setImage:[UIImage imageNamed:@"speaker_off"] forState:UIControlStateSelected];
            [muteBtn1 addTarget:self action:@selector(muteRemoteAudio:) forControlEvents:UIControlEventTouchUpInside];
            muteBtn1.tag = 1003;
            [attendView addSubview:muteBtn1];
            muteBtn1.right  = attendView.width;
            muteBtn1.bottom = attendView.height;
            attendView.layer.borderWidth = 1;
            attendView.layer.borderColor = MakeColor(200, 200, 200, 0.5).CGColor;
        }
        muteBtn1.streamId = attendView.streamId;
    }

    __weak typeof(self) wf = self;
    [self.layoutView addRenderView:view attributes:attributes clickedBlock:^(VHLayoutItem * _Nonnull item) {
        [wf.layoutView changePosWithItem:item room:wf.room];
    } frameChangeBlock:^(VHLayoutItem * _Nonnull item) {
        [item.view viewWithTag:1002].right = item.view.width-25;
        [item.view viewWithTag:1002].bottom = item.view.height;
        [item.view viewWithTag:1003].right = item.view.width;
        [item.view viewWithTag:1003].bottom = item.view.height;
    }];
}
- (void)removeView:(UIView*)view
{
    [self.layoutView removeRenderView:view];
}
- (void)removeAllViews
{
    [self.layoutView removeAllViews];
    if(self.cameraView)
    {
        __weak typeof(self) wf = self;
        [self.layoutView addRenderView:self.cameraView attributes:@"cameraView" clickedBlock:^(VHLayoutItem * _Nonnull item) {
            [wf.layoutView changePosWithItem:item room:wf.room];
        }];
    }
}

- (void)updateUI
{
    self.layoutView.frame = self.containerView.bounds;
}

@end
