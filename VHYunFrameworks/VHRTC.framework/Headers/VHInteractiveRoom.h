//
//  VHInteractiveRoom.h
//  VHInteractive
//
//  Created by vhall on 2018/4/17.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHRenderView.h"

/*
 * 互动房间状态
 */
typedef NS_ENUM(NSInteger, VHInteractiveRoomStatus) {
    VHInteractiveRoomStatusReady,
    VHInteractiveRoomStatusConnected,
    VHInteractiveRoomStatusDisconnected,
    VHInteractiveRoomStatusError
};

@protocol  VHInteractiveRoomDelegate;

@interface VHInteractiveRoom : NSObject
- (instancetype)initWithLogParam:(NSDictionary*)logParam;
@property (nonatomic, weak) id <VHInteractiveRoomDelegate> delegate;
/*
 * 当前房间状态
 */
@property (nonatomic, assign, readonly) VHInteractiveRoomStatus    status;
/*
 * 当前推流 cameraView 只在推流过程中存在
 */
@property (nonatomic, weak, readonly) VHRenderView    *cameraView;
/*
 * 所有其他进入本房间的视频view
 */
@property (nonatomic, strong, readonly) NSDictionary    *renderViewsById;
/*
 * 房间中所有可以观看的流id列表
 */
@property (nonatomic, strong, readonly) NSArray         *streams;
/*
 * 房间id
 */
@property (nonatomic, copy,   readonly) NSString        *roomId;

/*
 * 当前推流状态
 * 是否正在推流
 */
@property (nonatomic, assign, readonly) BOOL            isPublishing;

/*
 * 房间重连次数
 * 默认 5次
 */
@property (nonatomic, assign) int reconnectTimes;

// 是否只订阅音频流 默认为NO 订阅音视频流 enterRoomWithToken 前有效， YES只订阅音频流，可以 unmuteVideo 打开视频
@property (nonatomic, assign) BOOL isOnlyAudioSubscribe;

/*
 * 进入互动房间后可用权限
 * 注: didEnterRoom 后调用有效 具体权限如下：
 kick_inav              踢出互动房间 / 取消踢出互动房间
 kick_inav_stream       踢出路流 / 取消踢出流
 publish_inav_another   推旁路直播 / 结束推旁路直播
 apply_inav_publish     申请上麦
 publish_inav_stream    推流
 askfor_inav_publish    邀请用户上麦推流
 audit_inav_publish     审核申请上麦
 */
@property (nonatomic,copy,readonly)NSArray      * permission;


#pragma mark - 房间操作
/*
 * 加入房间
 * @param roomId 互动房间id
 * @param accessToken  accessToken
 * 调用完成等待代理回调确认接下来操作
 */
- (void)enterRoomWithRoomId:(const NSString *)roomId accessToken:(const NSString *)accessToken;

/*
 * 加入房间
 * @param roomId 互动房间id
 * @param accessToken  accessToken
 * @param userData  用户数据可以携带不超过255字符的字符串 可在VHRenderView中获取此值
 * 调用完成等待代理回调确认接下来操作
 */
- (void)enterRoomWithRoomId:(const NSString *)roomId accessToken:(const NSString *)accessToken userData:(NSString*)userData;


/*
 * 离开房间
 */
- (void)leaveRoom;

/*
 * 踢出互动房间并加入黑名单 或 从黑名单解禁
 * @param isKickout Yes 踢出房间 并加入黑名单 NO 从黑名单解禁
 * @param third_user_id 第三方id
 */
- (BOOL)kickoutRoom:(BOOL)isKickout thirdUserId:(const NSString *)third_user_id;

#pragma mark - 上下麦操作
/*
 * 上麦推流
 * @param camera 本地摄像头view
 */
- (BOOL)publishWithCameraView:(VHRenderView*) cameraView;

/*
 * 下麦停止推流
 */
- (BOOL)unpublish;

/*
 * 帮别人下麦
 * @param third_user_id 被下麦人的第三方id
 */
- (BOOL)kickoutStreamWithThirdUserId:(const NSString *)third_user_id;

#pragma mark - 他人视频处理
/*
 * 接收他人视频数据
 * @param streamId 他人视频 streamId
 */
- (BOOL)addVideo:(NSString*)streamId;
/*
 * 不接收他人视频数据
 * @param streamId 他人视频 streamId
 */
- (BOOL)removeVideo:(NSString*)streamId;

#pragma mark - 上下麦许可操作
/*
 * 邀请 上麦推流
 * @param third_user_id 被邀请/取消邀请人的第三方id
 */
- (BOOL)invitePublishWithThirdUserId:(const NSString *)third_user_id;

/*
 * 是否接受 上麦推流申请
 * @param third_user_id 互动观众的第三方id
 */
- (BOOL)acceptPublishRequest:(BOOL)isAccept thirdUserId:(const NSString *)third_user_id;

/*
 * 拒绝被邀请上麦推流
 */
- (BOOL)refusePublish;

/*
 * 申请上麦推流
 */
- (BOOL)requestPublish;

/*
 * 互动房间用户列表
 * userList数据结构 {third_party_user_id:xxx,status:1}
 * third_party_user_id  第三方用户ID
 * status               用户状态 1 推流中 2 观看中 3 受邀中  4 申请上麦中
 */
- (BOOL)inviteUserList:(void(^)(NSArray* userList,NSError* error)) block;

/*
 * 互动房间被踢出用户列表
 * userList数据结构 [xxxxxx,...]
 */
- (BOOL)kickoutUserList:(void(^)(NSArray* userList,NSError* error)) block;
#pragma mark - 旁路操作
/*
 * 开启/关闭旁路直播
 * @param isOpen Yes开启旁路直播   NO关闭旁路直播
 * @param roomID 旁路直播间
 */
- (BOOL)publishAnotherLive:(BOOL)isOpen liveRoomId:(const NSString *)liveRoomId completeBlock:(void(^)(NSError *error)) block;

/*
 * 开启/关闭旁路直播
 * @param isOpen Yes开启旁路直播   NO关闭旁路直播
 * @param roomID 旁路直播间
 * @param param  旁路参数 每一项都是可选项
 
 dpi                分辨率 480P, 540P, 720P (默认),1080P
 frame_rate         帧率 15, 20 (默认), 25 帧
 bitrate            码率 800, 1000 (默认), 1200
 layout             旁路直播布局 具体见下旁路直播布局设置
 max_screen_stream  设置屏占比最大的流ID
 
 layout 布局参数设置
 CANVAS_LAYOUT_PATTERN_GRID_1     string     一人铺满
 CANVAS_LAYOUT_PATTERN_GRID_2_H     string     左右两格
 CANVAS_LAYOUT_PATTERN_GRID_3_E     string     正品字
 CANVAS_LAYOUT_PATTERN_GRID_3_D     string     倒品字
 CANVAS_LAYOUT_PATTERN_GRID_4_M     string     2行x2列
 CANVAS_LAYOUT_PATTERN_GRID_5_D     string     2行，上3下2
 CANVAS_LAYOUT_PATTERN_GRID_6_E     string     2行x3列
 CANVAS_LAYOUT_PATTERN_GRID_9_E     string     3行x3列
 CANVAS_LAYOUT_PATTERN_FLOAT_2_1DR     string     大屏铺满，小屏悬浮右下角
 CANVAS_LAYOUT_PATTERN_FLOAT_2_1DL     string     大屏铺满，小屏悬浮左下角
 CANVAS_LAYOUT_PATTERN_FLOAT_3_2DL     string     大屏铺满，2小屏悬浮左下角
 CANVAS_LAYOUT_PATTERN_FLOAT_6_5D     string     大屏铺满，一行5个悬浮于下面
 CANVAS_LAYOUT_PATTERN_FLOAT_6_5T     string     大屏铺满，一行5个悬浮于上面
 CANVAS_LAYOUT_PATTERN_TILED_5_1T4D     string     主次平铺，一行4个位于底部
 CANVAS_LAYOUT_PATTERN_TILED_5_1D4T     string     主次平铺，一行4个位于顶部
 CANVAS_LAYOUT_PATTERN_TILED_5_1L4R     string     主次平铺，一列4个位于右边
 CANVAS_LAYOUT_PATTERN_TILED_5_1R4L     string     主次平铺，一列4个位于左边
 CANVAS_LAYOUT_PATTERN_TILED_6_1T5D     string     主次平铺，一行5个位于底部
 CANVAS_LAYOUT_PATTERN_TILED_6_1D5T     string     主次平铺，一行5个位于顶部
 CANVAS_LAYOUT_PATTERN_TILED_9_1L8R     string     主次平铺，右边为（2列x4行=8个块）
 CANVAS_LAYOUT_PATTERN_TILED_9_1R8L     string     主次平铺，左边为（2列x4行=8个块）
 CANVAS_LAYOUT_PATTERN_TILED_13_1L12R     string     主次平铺，右边为（3列x4行=12个块）
 CANVAS_LAYOUT_PATTERN_TILED_17_1TL12GRID     string     主次平铺，1V16
 CANVAS_LAYOUT_PATTERN_CUSTOM     string     自定义，当使用坐标布局接口时
 */
- (BOOL)publishAnotherLive:(BOOL)isOpen liveRoomId:(const NSString *)liveRoomId param:(NSDictionary*)param completeBlock:(void(^)(NSError *error)) block;

/**
 *  获得当前SDK版本号
 */
+ (NSString *) getSDKVersion;

/**
 * 是否开启扬声器输出音频
 */
- (void)setSpeakerphoneOn:(BOOL)on;

/**
 @brief 切换大小流
 @param streamId 他人视频 streamId
 @param type 0 是小流 1是大流
 @param finish code 200 成功 message具体信息
 */
- (void)switchDualStream:(NSString *)streamId type:(int)type finish:(void(^)(int code, NSString * _Nullable message))finish;
@end

/*
 * 互动房间代理
 */
@protocol VHInteractiveRoomDelegate <NSObject>
#pragma mark - 房间信息回调
/*
 * 房间错误回调
 */
- (void)room:(VHInteractiveRoom *)room error:(NSError*)error;
/*
 * 房间状态变化
 */
- (void)room:(VHInteractiveRoom *)room didChangeStatus:(VHInteractiveRoomStatus)status;

/*
 * 进入互动房间
 */
- (void)room:(VHInteractiveRoom *)room didEnterRoom:(NSString *)third_user_id;
/*
 * 离开互动房间
 */
- (void)room:(VHInteractiveRoom *)room didLeaveRoom:(NSString *)third_user_id isKickOutRoom:(BOOL)isKickOut;

/*
 * 他人上麦消息
 */
- (void)room:(VHInteractiveRoom *)room didAddAttendView:(VHRenderView *)attendView;
/*
 * 他人下麦消息
 */
- (void)room:(VHInteractiveRoom *)room didRemovedAttendView:(VHRenderView *)attendView;

#pragma mark - 上下麦推流信息回调
/*
 * 收到别人上麦申请 调用审核申请上麦接口回复
 */
- (void)room:(VHInteractiveRoom *)room requestPublish:(NSString *)third_user_id;
/*
 *
 * canPublish YES 可以上麦推流 NO 不可上麦推流
 * type 1、进入房间后有无上麦推流权限 2、申请上麦 审核后有无上麦推流权限 3、收到邀请上麦消息 获得上麦推流权限
 */
- (void)room:(VHInteractiveRoom *)room canPublish:(BOOL)canPublish type:(int) type;
/*
 * 房间人员信息变化
 * info 数据结构
 * status 0 人员变化 1 上麦 2 下麦 3拒绝上麦
 * third_party_user_id 操作人id
 * online 在线人数
 */
- (void)room:(VHInteractiveRoom *)room  userChangeInfo:(NSDictionary*)info;
/*
 * 推流成功
 */
- (void)room:(VHInteractiveRoom *)room didPublish:(VHRenderView *)cameraView;
/*
 * 停止推流成功
 * reason  "主动下麦" "被动下麦"
 */
- (void)room:(VHInteractiveRoom *)room didUnpublish:(NSString *)reason;

/**
 @brief 流音视频开启情况
 @param streamId 流id
 @param muteStream 流音视频开启情况
 */
- (void)room:(VHInteractiveRoom *)room didUpdateOfStream:(NSString *)streamId muteStream:(NSDictionary *)muteStream;

/**
 @brief 服务器已准备好混流可以调用混流接口
 @param msg msg
 @discussion onStreamMixed
 */
- (void)room:(VHInteractiveRoom *)room onStreamMixed:(NSDictionary *)msg;
@end

/*
//error
284000 未知错误 VHRoomErrorUnknown
284001 VHRoomErrorClient
284002 VHRoomErrorClientFailedSDP
284003 VHRoomErrorSignaling
*/
