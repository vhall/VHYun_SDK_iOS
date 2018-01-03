//
//  WatchVodViewController.m
//  VHYunSDKDemo
//
//  Created by vhall on 2017/11/24.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import "WatchVodViewController.h"
#import "VHVodPlayer.h"

#define CONTROLS_SHOW_TIME  10  //底部进度条显示时间

#define DefinitionNameList  (@[@"原画",@"超清",@"高清",@"标清",@"音频"])

@interface WatchVodViewController ()<VHVodPlayerDelegate>
{
    NSTimer         *_timer;
    NSArray *_definitionBtns;
}
@property (strong, nonatomic)VHVodPlayer *player;

@property (weak, nonatomic) IBOutlet UIView *preView;


@property (weak, nonatomic) IBOutlet UIView   *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel  *minLabel;
@property (weak, nonatomic) IBOutlet UISlider *curTimeSlider;
@property (weak, nonatomic) IBOutlet UILabel  *maxLabel;
@property (weak, nonatomic) IBOutlet UIButton *fullscreenBtn;


@property (weak, nonatomic) IBOutlet UIButton *definitionBtn;

@property (weak, nonatomic) IBOutlet UIView   *definitionsView;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn0;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn1;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn2;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn3;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn4;
@end

@implementation WatchVodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //阻止iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    _player = [[VHVodPlayer alloc]init];
    _player.delegate = self;
    _player.isUseDefaultControl = NO;//不适用默认UI Control
    
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
    
    [_definitionBtn setTitle:DefinitionNameList[0] forState:UIControlStateNormal];
    _definitionsView.hidden = YES;
    _definitionBtns = @[_definitionBtn0,_definitionBtn1,_definitionBtn2,_definitionBtn3,_definitionBtn4];
}

- (void)viewDidLayoutSubviews
{
    _player.view.frame = _preView.bounds;
    _fullscreenBtn.selected = ([UIApplication sharedApplication].statusBarOrientation != UIDeviceOrientationPortrait);
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
    [_player stopPlay];
    [_player destroyPlayer];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)stopPlayer
{
    [_player stopPlay];
    [self stopTimer];
}

- (IBAction)scalingModeBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    [_player setScalingMode: sender.selected?VHPlayerScalingModeAspectFill:VHPlayerScalingModeAspectFit];
}

- (IBAction)definitionsBtnClicked:(UIButton *)sender {
    _definitionsView.hidden = !_definitionsView.hidden;
}

- (IBAction)definitionBtnClicked:(UIButton *)sender {
    if(sender.selected) return;
    
    [_player setCurDefinition:sender.tag];
    _definitionsView.hidden = YES;
//    _logView.hidden = (sender.tag != VHDefinitionAudio);
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

- (NSString*)timeFormat:(NSTimeInterval)time
{
    NSString *str = @"00:00";
    long t = ceil(time);
    
    int hh = (int)(t/3600);
    int mm = (int)(t-hh*3660)/60;
    int ss = (int)(t%60);
    str = [NSString stringWithFormat:@"%02d:%02d:%02d",hh,mm,ss];
    return str;
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
        if(_player.playerState == VHPlayerStatusStop)
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
- (IBAction)fullscreenBtnClicked:(UIButton *)sender {
    [self rotateScreen:!sender.selected];
}

- (void)rotateScreen:(BOOL)isLandscapeRight
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        NSNumber *num = [[NSNumber alloc] initWithInt:(isLandscapeRight?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait)];
        [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)num];
        [UIViewController attemptRotationToDeviceOrientation];
        //这行代码是关键
    }
    SEL selector=NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation =[NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val =isLandscapeRight?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
    [[UIApplication sharedApplication] setStatusBarHidden:isLandscapeRight withAnimation:UIStatusBarAnimationSlide];
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
    
    [_definitionBtn setTitle:DefinitionNameList[definition] forState:UIControlStateNormal];
    for (UIButton* btn in _definitionBtns) {
        btn.enabled = NO;
    }
    
    for (NSNumber *idx in definitions) {
        UIButton* btn  = _definitionBtns[[idx integerValue]];
        btn.enabled = YES;
        btn.selected = (definition == [idx integerValue]);
    }
}

- (void)player:(VHVodPlayer *)player stoppedWithError:(NSError *)error
{
    //允许iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self hideProgressDialog:self.preView];
    [self stopPlayer];
    [self showMsg:[NSString stringWithFormat:@"%@",error.domain] afterDelay:2];
}

-(BOOL)shouldAutorotate
{
    return YES;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
    
@end
