//
//  VHInteractiveViewController+Room.m
//  VHYunSDKDemo
//
//  Created by vhall on 2018/4/19.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import "VHInteractiveViewController+Room.h"
#import "VHInteractiveViewController+Layout.h"
#import "VHInteractiveViewController+TableView.h"
#import "VHRenderView.h"
#import <objc/runtime.h>

static NSString *roomKey        = @"roomKey";
static NSString *infoDictKey    = @"infoDictKey";

@interface VHInteractiveViewController()
@property(nonatomic,strong) VHInteractiveRoom *room;
@property(nonatomic,strong) NSMutableDictionary *infoDict;
@end

@implementation VHInteractiveViewController (Room)
#pragma mark - 房间控制
- (void)createRoom
{
    if(!self.room)
    {
        self.room = [[VHInteractiveRoom alloc] init];
        self.room.delegate = self;
    }
}
- (void)enterRoom
{
    [self createRoom];
    [self.room enterRoomWithRoomId:self.ilssRoomID accessToken:self.accessToken];
}

- (void)leaveRoom
{
    [self removeAllViews];
    [self.room leaveRoom];
}

- (void)destroyRoom
{
     self.room = nil;
}

- (NSDictionary*)renderViewsById
{
    return self.room.renderViewsById;
}

#pragma mark - 推流控制
- (void)publish
{
    if(self.cameraView)
    {
        [self.room publishWithCameraView:self.cameraView];
    }
}

- (void)unPublish
{
    [self.room unpublish];
}

- (void)requestPublish//申请上麦
{
    [self.room requestPublish];
}
- (BOOL)inviteUserList:(void(^)(NSArray* userList)) block
{
    return [self.room inviteUserList:block];
}
//踢出房间
- (BOOL)kickoutRoomWithThirdUserId:(const NSString *_Nonnull)third_user_id
{
    return [self.room kickoutRoom:YES thirdUserId:third_user_id];
}
//踢出流  下麦
- (BOOL)kickoutStreamWithThirdUserId:(const NSString *_Nonnull)third_user_id
{
    return [self.room kickoutStreamWithThirdUserId:third_user_id];
}
//邀请取消邀请
- (BOOL)invitePublishWithThirdUserId:(const NSString *_Nonnull)third_user_id
{
    return [self.room invitePublishWithThirdUserId:third_user_id];
}
- (BOOL)publishAnotherLive:(BOOL)isOpen liveRoomId:(const NSString *_Nonnull)liveRoomId completeBlock:(void(^)(NSError *error)) block
{
    return [self.room publishAnotherLive:isOpen liveRoomId:liveRoomId completeBlock:block];
}
//是否同意上麦请求
- (BOOL)acceptPublishRequest:(BOOL)isAccept thirdUserId:(const NSString *_Nonnull)third_user_id
{
    return [self.room acceptPublishRequest:isAccept thirdUserId:third_user_id];
}
#pragma mark - 监听流信息
- (void)startListeningStream
{
    __weak typeof(self) wf = self;
    [self.cameraView startStatsWithCallback:^(NSString * _Nonnull mediaType, long kbps, NSDictionary<NSString *,NSString *> * _Nullable values) {
        [wf updateInfoView:mediaType kbps:kbps values:values streamid:wf.room.cameraView.streamId];
    }];
    
    for (NSString *key in self.room.renderViewsById) {
        VHRenderView *view = self.room.renderViewsById[key];
        [view startStatsWithCallback:^(NSString * _Nonnull mediaType, long kbps, NSDictionary<NSString *,NSString *> * _Nullable values) {
            [wf updateInfoView:mediaType kbps:kbps values:values streamid:view.streamId];
        }];
    }
}

- (void)stopListeningStream
{
    [self.cameraView stopStats];
    for (NSString *key in self.room.renderViewsById) {
        VHRenderView *view = self.room.renderViewsById[key];
        [view stopStats];
    }
    [self.infoDict removeAllObjects];
    [self updateInfoTextView:nil];
}

- (void)updateInfoView:(NSString *)mediaType kbps:(long)kbps values:(NSDictionary*)values streamid:(NSString *)streamid
{
//    NSLog(@"mediaType:%@ kbps:%ld info:%@",mediaType, kbps, [values description]);
    if(!self.infoDict)
        self.infoDict  = [NSMutableDictionary dictionary];
    
    if(streamid.length<=0)
        return;
    
    BOOL isocal = [self.room.cameraView.streamId isEqualToString:streamid];

    NSString * info = [self.infoDict objectForKey:isocal?@"(myself)":streamid];
    NSRange r = [info rangeOfString:@";"];
    NSString *video = @"【video】";
    NSString *audio = @"【audio】";
    if(r.location != NSNotFound)
    {
        video = [info substringToIndex:r.location];
        audio = [info substringFromIndex:r.location+2];
    }
    if([mediaType isEqualToString:@"video"])
    {
        if(isocal)
        {
            video = [NSString stringWithFormat:@"[V]%ldkbps DPI:%@x%@(%@x%@) FPS:%@(%@)",kbps,
                     values[@"googFrameWidthInput"],values[@"googFrameHeightInput"],
                     values[@"googFrameWidthSent"],values[@"googFrameHeightSent"],
                     values[@"googFrameRateInput"],values[@"googFrameRateSent"]];
        }
        else
        {
            video = [NSString stringWithFormat:@"[V]%ldkbps DPI:%@x%@ FPS:%@",kbps,
                     values[@"googFrameWidthReceived"],values[@"googFrameHeightReceived"],
                     values[@"googFrameRateReceived"]];
        }
    }
    else if([mediaType isEqualToString:@"audio"])
    {
        audio = [NSString stringWithFormat:@"[A]%ldkbps",kbps];
    }

    info = [NSString stringWithFormat:@"%@;%@\n",video,audio];
    self.infoDict[isocal?@"(myself)":streamid] = info;
    NSMutableString *text = [NSMutableString string];
    [text appendFormat:@"房间ID: %@\n",self.room.roomId];
//    [text appendFormat:@"用户ID: %@\n",self.room.userId];
    
    for (NSString* key in self.infoDict) {
        [text appendFormat:@"streamid: %@\n%@",key,self.infoDict[key]];
    }
    [text appendFormat:@"SDK版本: v%@\n",[VHLiveBase getSDKVersion]];
    [self updateInfoTextView:text];
}

#pragma mark - VHInteractiveRoomDelegate
- (void)room:(VHInteractiveRoom *)room error:(NSError*)error {
    if(room.status == VHInteractiveRoomStatusError)
    {
        [self.infoDict removeAllObjects];
        [self removeAllViews];
        if (error.code == 284003) { //断网
            [self showDisConectAlertWithStatusMessage:@"互动房间连接出错"];
        }
    }
    
    NSString *str = [NSString stringWithFormat:@"%@(%ld)",error.domain,(long)error.code];
    [self showMsg:str afterDelay:2];
//    [self showCallConnectViews:YES updateStatusMessage:[NSString stringWithFormat:@"Room error: %@", str]];
}

- (void)room:(VHInteractiveRoom *)room didChangeStatus:(VHInteractiveRoomStatus)status {
    switch (status) {
        case VHInteractiveRoomStatusDisconnected:
            [self showCallConnectViews:YES updateStatusMessage:@"已离开互动房间"];
            [self.infoDict removeAllObjects];
            [self removeAllViews];
            break;
        default:
            break;
    }
}

- (void)room:(VHInteractiveRoom *)room didEnterRoom:(NSString *)third_user_id {
    if( [DEMO_Setting.third_party_user_id isEqualToString:third_user_id])
        [self showCallConnectViews:NO updateStatusMessage:@"已进入互动房间"];
    else
        [self showMsg:[NSString stringWithFormat:@"%@ 进入房间",third_user_id] afterDelay:2];
    // We get connected and ready to publish, so publish.
}

- (void)room:(VHInteractiveRoom *)room didLeaveRoom:(NSString *)third_user_id isKickOutRoom:(BOOL)isKickOut
{
    if( [DEMO_Setting.third_party_user_id isEqualToString:third_user_id])
    {
        [self removeAllViews];
        if(isKickOut)
        {
            [self showMsg:@"您已被管理员踢出房间" afterDelay:2];
            [self showCallConnectViews:NO updateStatusMessage:@"您已被管理员踢出房间"];
        }
        else
            [self showCallConnectViews:NO updateStatusMessage:@"已离开互动房间"];
    }
    else
        [self showMsg:[NSString stringWithFormat:@"%@ 离开房间",third_user_id] afterDelay:2];
}

- (void)room:(VHInteractiveRoom *)room didAddAttendView:(VHRenderView *)attendView
{
    //布局连麦界面 renderViewsById 房间中所有上麦人视频view
    [self addView:attendView attributes:attendView.userId];
}
- (void)room:(VHInteractiveRoom *)room didRemovedAttendView:(VHRenderView *)attendView
{
    [self removeView:attendView];
}


#pragma mark - 上下麦推流信息回调
/*
 * 收到别人上麦申请 调用审核申请上麦接口回复
 */
- (void)room:(VHInteractiveRoom *)room requestPublish:(NSString *)third_user_id
{
    __weak typeof(self) wf = self;
    [JXTAlertView showAlertViewWithTitle:@"申请上麦"
                                 message:[NSString stringWithFormat:@"%@ 申请上麦",third_user_id]
                       cancelButtonTitle:@"忽略" buttonIndexBlock:^(NSInteger buttonIndex) {
                           switch (buttonIndex) {
                               case 1:
                                   [wf.room acceptPublishRequest:YES thirdUserId:third_user_id];
                                   break;
                               case 2:
                                   [wf.room acceptPublishRequest:NO thirdUserId:third_user_id];
                                   break;
                               default:
                                   break;
                           }
                       } otherButtonTitles:@"同意",@"拒绝", nil];
}
/*
 *
 * canPublish YES 可以上麦推流 NO 不可上麦推流
 * type 1、进入房间后有无上麦推流权限 2、申请上麦 审核后有无上麦推流权限 3、收到邀请上麦消息 获得上麦推流权限
 */
- (void)room:(VHInteractiveRoom *)room canPublish:(BOOL)canPublish type:(int) type{
    switch (type) {
        case 1:
        {
            if(canPublish)
                [self publish];
            else
                [self showMsg:@"没有上麦权限，请申请上麦" afterDelay:2];
        }
            break;
        case 2:
        {
            if(canPublish)
            {
                [self showMsg:@"管理员同意您上麦" afterDelay:2];
                [self publish];
            }
            else
                [self showMsg:@"管理员拒绝了您上麦请求" afterDelay:2];
        }
            break;
        case 3:
        {
            __weak typeof(self) wf = self;
            [JXTAlertView showAlertViewWithTitle:@"管理员邀请您上麦"
                                         message:@"管理员邀请您上麦"
                               cancelButtonTitle:@"忽略" buttonIndexBlock:^(NSInteger buttonIndex) {
                                   switch (buttonIndex) {
                                       case 1:
                                       {
                                           if(canPublish)
                                               [wf publish];
                                       }
                                           break;
                                       case 2:
                                           [wf.room refusePublish];
                                           break;
                                       default:
                                           break;
                                   }
                               } otherButtonTitles:@"同意",@"拒绝", nil];
        }
            break;
            
        default:
            break;
    }
}
/*
 * 推流成功
 */
- (void)room:(VHInteractiveRoom *)room didPublish:(VHRenderView *)cameraView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self didPublish:cameraView.streamId];
        [self showCallConnectViews:NO updateStatusMessage:[NSString stringWithFormat:@"已上麦%@",cameraView.streamId]];
    });
}
/*
 * 停止推流成功
 * reason  "主动下麦" "被动下麦"
 */
- (void)room:(VHInteractiveRoom *)room didUnpublish:(NSString *)reason
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self didUnPublish];
        [self showCallConnectViews:NO updateStatusMessage:@"已下麦"];
    });
}

/*
 * 房间人员信息变化
 */
- (void)room:(VHInteractiveRoom *)room userChangeInfo:(NSDictionary *)info
{
    [self updateUserListData];
    self.onlineNumLabel.text = [NSString stringWithFormat:@"在线 %@ 人",info[@"online"]];
}

#pragma mark - 进入后台
- (void)willEnterForeground
{
    [self enterRoom];
}

- (void)didEnterBackground
{
    [self leaveRoom];
}
#pragma mark - runtime 动态绑定 属性
- (void)setRoom:(VHInteractiveRoom *)room{
    objc_setAssociatedObject(self, &roomKey, room, OBJC_ASSOCIATION_RETAIN);
}
- (VHInteractiveRoom *)room{
    return objc_getAssociatedObject(self, &roomKey);
}
- (void)setInfoDict:(NSMutableDictionary *)infoDict{
    objc_setAssociatedObject(self, &infoDictKey, infoDict, OBJC_ASSOCIATION_RETAIN);
}
- (NSMutableDictionary *)infoDict{
    return objc_getAssociatedObject(self, &infoDictKey);
}
@end
