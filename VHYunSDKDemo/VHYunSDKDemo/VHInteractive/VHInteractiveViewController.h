//
//  VHInteractiveViewController.h
//  VHInteractive
//
//  Created by vhall on 2018/4/18.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VHInteractiveRoom.h"
#import "VHLayoutView_1vN_Pip_Left.h"

@interface VHInteractiveViewController : VHBaseViewController
@property(nonatomic,copy) NSString * ilssRoomID;        //互动房间id
@property(nonatomic,assign)VHPushType  ilssType;        //摄像头及推流参数设置
@property(nonatomic,copy)NSDictionary* ilssOptions;     //摄像头及推流参数设置

@property(nonatomic,copy) NSString * anotherLiveRoomId; //旁路直播间ID
@property(nonatomic,copy) NSString * accessToken;
@property(nonatomic,copy) NSString * myName;//


@property (weak, nonatomic) IBOutlet UIView *containerView;//画面布局容器
@property (nonatomic,strong) VHLayoutView   *layoutView;//画面布局

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *onlineNumLabel;



@property (nonatomic,strong) VHRenderView *cameraView;//本地摄像头画面view
@property (nonatomic,strong) NSArray* userList;


@property(nonatomic,assign)BOOL isResignActive;//是否进入后台
//房间连接状态并更新UI
- (void)showCallConnectViews:(BOOL)show updateStatusMessage:(NSString *)statusMessage;
//房间视频流状态更新
- (void)updateInfoTextView:(NSString*)text;

//推流成功
- (void)didPublish:(NSString*)streamId;
//结束推流成功
- (void)didUnPublish;
@end
