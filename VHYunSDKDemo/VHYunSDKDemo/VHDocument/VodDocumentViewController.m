//
//  VodDocumentViewController.m
//  VHYunSDKDemo
//
//  Created by vhall on 2017/12/14.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import "VodDocumentViewController.h"
#import "VHDocument.h"
#import "VHVodPlayer.h"
#define CONTROLS_SHOW_TIME  10  //底部进度条显示时间

@interface VodDocumentViewController ()<UIScrollViewDelegate,VHVodPlayerDelegate>
{
    NSTimer         *_timer;
    BOOL isFirstLayout;
}

@property (strong, nonatomic)VHVodPlayer *player;
@property(nonatomic,strong)VHDocument * document;
@property (weak, nonatomic) IBOutlet UIView *preView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;



@property (weak, nonatomic) IBOutlet UIView   *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel  *minLabel;
@property (weak, nonatomic) IBOutlet UISlider *curTimeSlider;
@property (weak, nonatomic) IBOutlet UILabel  *maxLabel;
@property (weak, nonatomic) IBOutlet UIButton *fullscreenBtn;


@end

@implementation VodDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initView];
    
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
}
- (void)viewDidLayoutSubviews
{
    _player.view.frame      = _preView.bounds;
    if(!isFirstLayout)
    {
        isFirstLayout = YES;
        _document.view.frame    = _scrollView.bounds;
        _scrollView.contentSize = CGSizeMake(_document.view.width+1, _document.view.height+1);
    }
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
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)initView
{
    _document = [[VHDocument alloc]initWithRecordID:self.recordID];
//    _document.delegate = self;
    _document.view.frame = _scrollView.bounds;
    _document.view.backgroundColor = MakeColorRGB(0xE2E8EB);
    [_scrollView addSubview:_document.view];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(_scrollView.width+1, _scrollView.height+1);
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

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _document.view;
}
// called before the scroll view begins zooming its content缩放开始的时候调用
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view NS_AVAILABLE_IOS(3_2){
//    NSLog(@"%s",__func__);
}
// scale between minimum and maximum. called after any 'bounce' animations缩放完毕的时候调用。
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    //把当前的缩放比例设进ZoomScale，以便下次缩放时实在现有的比例的基础上
//    NSLog(@"scale is %f",scale);
    [_scrollView setZoomScale:scale animated:NO];
    if(scale <= 1.0)
        _scrollView.contentSize = CGSizeMake(_scrollView.width+1, _scrollView.height+1);
}
// 缩放时调用 可以实时监测缩放比例
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    //    NSLog(@"......scale is %f",scrollView.zoomScale);
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
}

- (void)player:(VHVodPlayer *)player stoppedWithError:(NSError *)error
{
    [self hideProgressDialog:self.preView];
    [self stopPlayer];
    [self showMsg:[NSString stringWithFormat:@"%@",error.domain] afterDelay:2];
}

@end
