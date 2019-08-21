//
//  VHInteractiveViewController+Room.h
//  VHYunSDKDemo
//
//  Created by vhall on 2018/4/19.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import "VHInteractiveViewController.h"
#import <VHRTC/VHInteractiveRoom.h>
@interface VHInteractiveViewController (Room)<VHInteractiveRoomDelegate>

- (NSDictionary*)renderViewsById;
//房间控制
//连接成功后会自动调用publish推流 所以创建房间前必须先调用 createCameraStream
- (void)createRoom;
- (void)enterRoom;
- (void)leaveRoom;
- (void)destroyRoom;

//推流控制
- (void)publish;//上麦
- (void)unPublish;//下麦

- (void)requestPublish;//申请上麦
- (BOOL)inviteUserList:(void(^)(NSArray* userList,NSError* error)) block;//获取房间用户
//踢出房间
- (BOOL)kickoutRoomWithThirdUserId:(const NSString *_Nonnull)third_user_id;
//踢出流  下麦
- (BOOL)kickoutStreamWithThirdUserId:(const NSString *_Nonnull)third_user_id;
//邀请
- (BOOL)invitePublishWithThirdUserId:(const NSString *_Nonnull)third_user_id;
//旁路开关
- (BOOL)publishAnotherLive:(BOOL)isOpen liveRoomId:(const NSString *_Nonnull)liveRoomId completeBlock:(void(^)(NSError *error)) block;
//是否同意上麦请求
- (BOOL)acceptPublishRequest:(BOOL)isAccept thirdUserId:(const NSString *_Nonnull)third_user_id;

- (void)startListeningStream;
- (void)stopListeningStream;

- (void)willEnterForeground;
- (void)didEnterBackground;
@end

/*
 内部会调用VHInteractiveViewController中
 
 @property(nonatomic,copy) NSString* ilssToken;//底层token
 @property(nonatomic,assign) int width;
 @property(nonatomic,assign) int height;
 @property(nonatomic,strong) NSNumber* fps;
 @property(nonatomic,strong) NSNumber* maxVideoBitrate;

 //房间连接状态并更新UI
 - (void)showCallConnectViews:(BOOL)show updateStatusMessage:(NSString *)statusMessage;
 //房间视频流状态更新
 - (void)updateInfoTextView:(NSString*)text;

 //推流成功
 - (void)didPublish:(NSString*)streamId;
 //结束推流成功
 - (void)didUnPublish;
 
 //新用户加入房间
 - (void)addPlayerViewWithStream:(VHStream *)stream;
 //用户退出房间
 - (void)removePlayerViewWithStream:(VHStream *)stream;
 */
