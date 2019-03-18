//
//  VHInteractiveCallViewController.m
//  VHInteractive
//
//  Created by vhall on 2018/4/18.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "VHInteractiveViewController.h"
#import "VHInteractiveViewController+Room.h"
#import "VHInteractiveViewController+Layout.h"
#import "VHInteractiveViewController+TableView.h"

@interface VHInteractiveViewController ()
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UIButton *leaveButton;
@property (weak, nonatomic) IBOutlet UIButton *unpublishButton;
@property (weak, nonatomic) IBOutlet UILabel  *statusLabel;

@end

@implementation VHInteractiveViewController

#pragma mark - Button event
//返回按钮
- (IBAction)backBtnClicked:(id)sender {
    [self unPublish];
    [self closeLocalCamera];
    
    //离开房间
    [self leaveRoom];
    
    [self dismissViewControllerAnimated:YES completion:^{}];
    [self.navigationController popViewControllerAnimated:NO];
}
//房间视频信息展示
- (IBAction)infoBtnClicked:(id)sender {
    _infoTextView.hidden = !_infoTextView.hidden;
    
    if(_infoTextView.hidden)
        [self stopListeningStream];
    else
        [self startListeningStream];
}
//创建 room 并连接
- (IBAction)connect:(id)sender{
    [self showCallConnectViews:NO updateStatusMessage:@"enter room..."];
    [self enterRoom];
}
//离开房间
- (IBAction)leave:(id)sender {
    [self leaveRoom];
    [self destroyRoom];
    [self showCallConnectViews:YES updateStatusMessage:@"Ready"];
}
//推流or停止推流
- (IBAction)unpublish:(UIButton*)sender {
    if (!self.unpublishButton.selected) {
      [self startLocalCamera];
      [self publish];
    } else {
      [self unPublish];
    }
}
//停止推送本地视频画面
- (IBAction)muteLocalVideoStream:(UIButton*)sender{
    sender.selected = !sender.selected;
    [self muteMyVideo:sender.selected];
}
//停止推送本地音频、
- (IBAction)muteAudio:(UIButton*)sender {
    sender.selected = !sender.selected;
    [self muteMyAudio:sender.selected];
}
//切换摄像头
- (IBAction)switchCameraBtn:(UIButton*)sender {
    sender.selected = !sender.selected;
    [self switchCamera];
}
- (IBAction)requestPublishBtn:(id)sender {
    [self requestPublish];
}
- (IBAction)invitePublishBtn:(UIButton*)sender {
    _tableView.hidden = sender.selected;
    sender.selected = !sender.selected;
    if(!_tableView.hidden)
        [self updateUserListData];
}
- (IBAction)publishAnotherLiveBtn:(UIButton *)sender {
    if(self.anotherLiveRoomId.length>0)
    {
        __weak typeof(self) wf = self;
        [self publishAnotherLive:!sender.selected liveRoomId:self.anotherLiveRoomId completeBlock:^(NSError *error) {
            if(!error)
            {
                sender.selected = !sender.selected;
                [wf showMsg:sender.selected?@"已开启旁路":@"已关闭旁路" afterDelay:2];
            }
            else
            {
                if(error.code == 40008)//旁路推流正在进行中，请先结束
                {
                    sender.selected = !sender.selected;
                }
                [wf showMsg:error.domain afterDelay:1];
            }
        }];
    }
    else
        [self showMsg:@"旁路直播房间ID为空" afterDelay:2];
}
- (IBAction)voiceChangeBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.cameraView.voiceChangeType = sender.selected?1:0;
}

#pragma mark - Public
- (void)didPublish:(NSString*)streamId
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.unpublishButton.selected = YES;
    });
}

- (void)didUnPublish
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.unpublishButton.selected = NO;
    });
}

- (void)showCallConnectViews:(BOOL)show updateStatusMessage:(NSString *)statusMessage {
   dispatch_async(dispatch_get_main_queue(), ^{
      self.statusLabel.text = statusMessage;
//      self.connectButton.hidden = !show;
//      self.leaveButton.hidden = show;
//      self.unpublishButton.hidden = show;
       
       if(show)
       {
           self.infoTextView.text = nil;
           self.infoTextView.hidden = YES;
       }
   });
}
- (void)showDisConectAlertWithStatusMessage:(NSString *)msg
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self backBtnClicked:nil];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)updateInfoTextView:(NSString*)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.infoTextView.text = text;
    });
}

#pragma mark - Private
- (void)initView{
    self.title = @"VideoConference";
    //设置返回按钮
    UIBarButtonItem *barItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(backBtnClicked:)];
    self.navigationItem.leftBarButtonItem = barItem;
    
    //本地工作准备完毕
    [self showCallConnectViews:YES updateStatusMessage:@"Ready"];
    
    _tableView.tableFooterView = [[UIView alloc]init];
}

/*
 * 打开本地摄像头，并设置到预览界面
 */
- (void)startLocalCamera{
    [self showLocalCamera];
}

- (VHLayoutView*)layoutView
{
    if(!_layoutView)
    {
        _layoutView = [[VHLayoutView_1vN_Pip_Left alloc]initWithFrame:self.containerView.bounds];
        _layoutView.backgroundColor = [UIColor blackColor];
        [self.containerView addSubview:_layoutView];
    }
    return _layoutView;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createRoom];
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (willEnterForeground) name: UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (didEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

-(void)deviceOrientationDidChange:(NSObject*)sender{
    
    if(self.cameraView)
    {
//        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//        NSLog(@"UIInterfaceOrientation: %d",orientation);
        [self.cameraView setDeviceOrientation:[UIDevice currentDevice].orientation];
    }
    
}

    
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self startLocalCamera];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self connect:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
   [super viewWillDisappear:animated];
   [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)viewDidLayoutSubviews {
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
   [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    NSLog(@"dealloc: %@",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
@end
