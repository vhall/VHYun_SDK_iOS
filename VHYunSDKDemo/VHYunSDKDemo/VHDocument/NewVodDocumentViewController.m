//
//  NewVodDocumentViewController.m
//  VHYunSDKDemo
//
//  Created by vhall on 2017/12/14.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import "NewVodDocumentViewController.h"
#import <VHDoc/VHDocument.h>
#import <VHLSS/VHVodPlayer.h>
#define CONTROLS_SHOW_TIME  10  //底部进度条显示时间

@interface NewVodDocumentViewController ()<VHVodPlayerDelegate,VHDocumentDelegate>
{
    NSTimer         *_timer;
}

@property (strong, nonatomic)VHVodPlayer *player;
@property(nonatomic,strong)VHDocument * document;
@property (weak, nonatomic) IBOutlet UIView *preView;
@property (weak, nonatomic) IBOutlet UIView *docConentView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *cidLabel;


@property (weak, nonatomic) IBOutlet UIView   *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel  *minLabel;
@property (weak, nonatomic) IBOutlet UISlider *curTimeSlider;
@property (weak, nonatomic) IBOutlet UILabel  *maxLabel;
@property (weak, nonatomic) IBOutlet UIButton *fullscreenBtn;

@property (weak, nonatomic) IBOutlet UIButton *rateBtn;



@end

@implementation NewVodDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;

    //阻止iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    
    _document = [[VHDocument alloc]initWithRecordID:self.recordID accessToken:self.accessToken];
    _document.delegate = self;
    _document.frame = _docConentView.bounds;
    _document.backgroundColor = MakeColorRGB(0xE2E8EB);
    
    _player = [[VHVodPlayer alloc]init];
    _player.delegate = self;
    _player.seekModel = _seekMode?VHVodPlayerSeeekModelPlayed:VHVodPlayerSeeekModelDefault;

    [self.preView insertSubview:_player.view atIndex:0];
    _player.view.frame = _preView.bounds;
    [_player startPlay:self.recordID accessToken:self.accessToken];
    [self showProgressDialog:self.preView];
    [self startTimer];
    
    
    
    // 单击的_player.view
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.preView addGestureRecognizer:singleRecognizer];
}
- (void)viewDidLayoutSubviews
{
    _player.view.frame      = _preView.bounds;
    _document.frame    = _docConentView.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    //允许iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    NSLog(@"%@: dealloc",[self class]);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnClicked:(id)sender {
    [self stopPlayer];
    [_player destroyPlayer];
//    [_document destroyDocument];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)stopPlayer
{
    [_player stopPlay];
    [self stopTimer];
}

#pragma mark - Timer
- (void)startTimer
{
    if(_timer == nil)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerEvent)  userInfo:nil repeats:YES];
    }
}
- (void)stopTimer
{
    if(_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void)timerEvent
{
    if(_player.playerState == VHPlayerStatusPlaying)
    {
        _minLabel.text = [self timeFormat:_player.currentPlaybackTime];
        _maxLabel.text = [self timeFormat:_player.duration];
        if(_player.duration>0)
            _curTimeSlider.value =_player.currentPlaybackTime/_player.duration;
    }
}

#pragma mark - palyerControls
- (void)showControls:(BOOL)isForever
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls) object:nil];
    if(!isForever)
        [self performSelector:@selector(hideControls) withObject:nil afterDelay:CONTROLS_SHOW_TIME];
    
    _bottomView.hidden = NO;
}
- (void)hideControls
{
    _bottomView.hidden = YES;
}

-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    if(_bottomView.hidden)
        [self showControls:(_player.playerState != VHPlayerStatusPlaying)];
    else
        [self hideControls];
}

- (IBAction)playeBtnClicked:(UIButton *)sender {
    if(sender.selected)
    {
        [_player pause];
        sender.selected = NO;
    }
    else
    {
        if(_player.playerState == VHPlayerStatusStop || _player.playerState == VHPlayerStatusComplete )
        {
            [_player startPlay:self.recordID accessToken:self.accessToken];
            [self showProgressDialog:self.preView];
            [self startTimer];
        }
        else if(_player.playerState == VHPlayerStatusPause)
        {
            [_player resume];
        }
    }
}

- (IBAction)curTimeValueChange:(id)sender {
     _minLabel.text = [self timeFormat:_player.duration*_curTimeSlider.value];
}

- (IBAction)durationSliderTouchBegan:(UISlider *)slider {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls) object:nil];
    [_player pause];
}

- (IBAction)durationSliderTouchEnded:(UISlider *)slider {
    _player.currentPlaybackTime = _player.duration*_curTimeSlider.value;
    [_player resume];
    [self performSelector:@selector(hideControls) withObject:nil afterDelay:CONTROLS_SHOW_TIME];
}

- (IBAction)rateBtnClicked:(UIButton *)sender
{
    sender.tag+=5;
    if (sender.tag >20)
        sender.tag = 5;
    
    _player.rate = sender.tag/10.0;
    [sender setTitle:[NSString stringWithFormat:@"%.1f",_player.rate] forState:0];
}

#pragma mark - VHVodPlayerDelegate
- (void)player:(VHVodPlayer *)player statusDidChange:(int)state
{
    switch (state) {
        case VHPlayerStatusLoading:
        {
            [self showProgressDialog:self.preView];
        }
            break;
        case VHPlayerStatusPlaying:
        {
            _rateBtn.tag = (NSInteger)(_player.rate*10.0);
            [_rateBtn setTitle:[NSString stringWithFormat:@"%.1f",_player.rate] forState:0];
            [self showControls:NO];
            _playBtn.selected = YES;
            [self hideProgressDialog:self.preView];
        }
            break;
        case VHPlayerStatusStop:
        {
            [self showControls:YES];
            _playBtn.selected = NO;
            [self hideProgressDialog:self.preView];
        }
            break;
        case VHPlayerStatusPause:
            _playBtn.selected = NO;
            break;
            
        default:
            break;
    }
}

- (void)player:(VHVodPlayer *)player validDefinitions:(NSArray*)definitions curDefinition:(VHDefinition)definition
{
    NSLog(@"curDefinition: %ld definitions:%@",(long)definition,definitions);
}

- (void)player:(VHVodPlayer *)player stoppedWithError:(NSError *)error
{
    //允许iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self hideProgressDialog:self.preView];
    [self stopPlayer];
    [self showMsg:[NSString stringWithFormat:@"%@",error.domain] afterDelay:2];
}

- (void)player:(VHVodPlayer*)player docChannels:(NSArray*)docChannels
{

}

#pragma mark - VHDocumentDelegate
- (void)document:(VHDocument *)document error:(NSError *)error{
    [self showMsg:error.domain afterDelay:2];
}
- (void)document:(VHDocument *)document changePage:(VHDocumentView*)documentView{
    [self updateCurDocInfo];
}
- (void)document:(VHDocument *)document switchStatus:(BOOL)switchStatus{
    NSLog(@"%@",switchStatus?@"文档显示":@"文档隐藏");
    for (UIView *view in _document.documentViewsByIDs.allValues) {
        view.hidden = !switchStatus;
    }
    [self updateCurDocInfo];
}
- (void)document:(VHDocument *)document selectDocumentView:(VHDocumentView*)documentView{
    NSLog(@"选中文档cid: %@",documentView.cid);
    [_docConentView addSubview:_document.selectedView];
    [self updateCurDocInfo];
}
- (void)document:(VHDocument *)document addDocumentView:(VHDocumentView *)documentView{
    NSLog(@"新增文档cid: %@",documentView.cid);
    documentView.frame = _docConentView.bounds;
    if([_document.selectedView isEqual:documentView])
        [_docConentView addSubview:documentView];
    else
        [_docConentView insertSubview:documentView belowSubview:_document.selectedView];
}
- (void)document:(VHDocument *)document removeDocumentView:(VHDocumentView *)documentView{
    NSLog(@"删除文档cid: %@",documentView.cid);
    [self updateCurDocInfo];
}

#pragma mark -
- (void)updateCurDocInfo
{
    if(!_document.switchOn)
    {
        _infoLabel.text = @"主持人暂未演示文档";
        _cidLabel.text  = @"";
    }
    else
    {
        if(_document.selectedView)
        {
            if(_document.selectedView.type == VHDocumentViewType_Board)
                _infoLabel.text = @"白板";
            else
                _infoLabel.text = [NSString stringWithFormat:@"page:%d/%d step:%d/%d",
                                   _document.selectedView.currentPage+1,
                                   _document.selectedView.totalPage,
                                   _document.selectedView.currentStep+1,
                                   _document.selectedView.totalStep];
            _cidLabel.text  = _document.selectedView.cid;
        }
        else
        {
            _infoLabel.text = @"";
            _cidLabel.text  = @"";
        }
    }
}
@end
