//
//  WatchViewController.m
//  VHYunSDKDemo
//
//  Created by vhall on 2017/11/22.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import "WatchViewController.h"
#import <VHLSS/VHLivePlayer.h>
#import <Photos/Photos.h>
#import <VHLSS/VHMessage.h>

#define DefinitionNameList  (@[@"原画",@"超清",@"高清",@"标清",@"音频"])

@interface WatchViewController ()<VHLivePlayerDelegate>
{
    NSArray *_definitionBtns;
}

@property (strong, nonatomic)VHLivePlayer *player;

@property (weak, nonatomic) IBOutlet UIView *preView;
@property (weak, nonatomic) IBOutlet UIImageView *logView;
@property (weak, nonatomic) IBOutlet UIButton *stratBtn;
@property (weak, nonatomic) IBOutlet UILabel *downloadSpeedLabel;


@property (weak, nonatomic) IBOutlet UIView   *operationView;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn;

@property (weak, nonatomic) IBOutlet UIView   *definitionsView;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn0;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn1;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn2;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn3;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn4;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@end

@implementation WatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //阻止iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    _player = [[VHLivePlayer alloc]init];
    _player.delegate = self;
    _player.bufferTime = self.bufferTime;
    
    [self.preView insertSubview:_player.view atIndex:0];
    _player.view.frame = _preView.bounds;

    _operationView.hidden = YES;
    [_definitionBtn setTitle:DefinitionNameList[0] forState:UIControlStateNormal];
    _definitionsView.hidden = YES;
    _definitionBtns = @[_definitionBtn0,_definitionBtn1,_definitionBtn2,_definitionBtn3,_definitionBtn4];
    [self stratBtnClicked:nil];
}

- (void)viewDidLayoutSubviews
{
    _player.view.frame = _preView.bounds;
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
    if(_player.playerState != VHPlayerStatusStop)
    {
        [self stopPlayer];
    }
    [_player destroyPlayer];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)stratBtnClicked:(UIButton *)sender {
    if(!_stratBtn.selected)
    {
        //设备锁屏
        [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
        [self showProgressDialog:self.preView];
        _logView.hidden = YES;
        _infoLabel.text = @"";
        [_player startPlay:self.roomId accessToken:self.accessToken];
    }
    else
    {
        [self stopPlayer];
    }
}
- (IBAction)takeAPhotoBtnClicked:(id)sender {
    
    __weak typeof(self) wf = self;
    [_player takeVideoScreenshot:^(UIImage *image) {
        if(image)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [wf saveImage:image];
            });
        }
    }];
}
- (void)saveImage:(UIImage *)image
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"success = %d, error = %@", success, error);
        NSString*ret = @"已保存到相册";
        if(!success && error.userInfo[@"NSLocalizedDescription"])
            ret = error.userInfo[@"NSLocalizedDescription"];
        [self showMsg:ret afterDelay:2];
    }];
}

- (void)stopPlayer
{
    _logView.hidden = NO;
    _stratBtn.selected = NO;
    _operationView.hidden = YES;
    _definitionsView.hidden = YES;
    [_player stopPlay];
}

- (IBAction)speakerBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    _player.mute = sender.selected;
}


- (IBAction)definitionsBtnClicked:(UIButton *)sender {
    _definitionsView.hidden = !_definitionsView.hidden;
}

- (IBAction)definitionBtnClicked:(UIButton *)sender {
    if(sender.selected) return;
    
    [_player setCurDefinition:sender.tag];
    _definitionsView.hidden = YES;
    _logView.hidden = (sender.tag != VHDefinitionAudio);
}

- (IBAction)scalingModeBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    [_player setScalingMode: sender.selected?VHPlayerScalingModeAspectFill:VHPlayerScalingModeAspectFit];
}


#pragma mark - VHLssPlayerDelegate
- (void)player:(VHLivePlayer *)player statusDidChange:(int)state
{
    _logView.hidden = (_player.curDefinition != VHDefinitionAudio);
    switch (state) {
        case VHPlayerStatusLoading:
        {
            _operationView.hidden = NO;
            _stratBtn.selected = YES;
            [self showProgressDialog:self.preView];
        }
            break;
        case VHPlayerStatusPlaying:
        {
            _operationView.hidden = NO;
            _stratBtn.selected = YES;
            [self hideProgressDialog:self.preView];
        }
            break;
        case VHPlayerStatusStop:
        {
            _logView.hidden = NO;
            _stratBtn.selected = NO;
            _operationView.hidden = YES;
            _definitionsView.hidden = YES;
            [self hideProgressDialog:self.preView];

        }
            break;
        case VHPlayerStatusPause:
            
            break;
            
        default:
            break;
    }
}

- (void)player:(VHLivePlayer *)player stoppedWithError:(NSError *)error
{
    [self hideProgressDialog:self.preView];
    [self stopPlayer];
    [self showMsg:[NSString stringWithFormat:@"%@",error.domain] afterDelay:2];
}

- (void)player:(VHLivePlayer *)player downloadSpeed:(NSString*)speed
{
    _downloadSpeedLabel.text = [NSString stringWithFormat:@"%@ kb/s",speed];
    
//测试代码
    if([speed rangeOfString:@"-"].location == NSNotFound)
        _downloadSpeedLabel.text = [NSString stringWithFormat:@"%@ kb/s",speed];
    else
    {
        NSRange r = [speed rangeOfString:@"_" options:NSBackwardsSearch];
        if(r.location != NSNotFound)
        _infoLabel.text = [_infoLabel.text stringByAppendingFormat:@"\n%@",[speed substringToIndex:r.location]];
    }
}

- (void)player:(VHLivePlayer *)player validDefinitions:(NSArray*)definitions curDefinition:(VHDefinition)definition
{
    NSLog(@"curDefinition: %ld definitions:%@",(long)definition,definitions);
    
    if(definition>4)
        return;
    
    [_definitionBtn setTitle:DefinitionNameList[definition] forState:UIControlStateNormal];
    for (UIButton* btn in _definitionBtns) {
        btn.enabled = NO;
    }
    
    for (NSNumber *idx in definitions) {
        if([idx intValue]<5)
        {
            UIButton* btn  = _definitionBtns[[idx integerValue]];
            btn.enabled = YES;
            btn.selected = (definition == [idx integerValue]);
        }
    }
}

- (void)player:(VHLivePlayer *)player streamtype:(int)streamtype
{
    NSLog(@"streamtype: %ld",(long)streamtype);
}

- (void)player:(VHLivePlayer *)player roomMessage:(id)msg
{
    VHMessage *roommsg = (VHMessage *)msg;
    if([roommsg.service_type isEqualToString:MSG_Service_Type_Room])
    {
        if([roommsg.data[MSG_Type] isEqualToString:MSG_Room_Live_Start])
        {
            [self showMsg:@"主持人已开始推流" afterDelay:1.5];
        }
        else if([roommsg.data[MSG_Type] isEqualToString:MSG_Room_Live_Over])
        {
            [self hideProgressDialog:self.preView];
            [self stopPlayer];
            [self showMsg:@"主持人没有推流" afterDelay:1.5];
        }
    }
    else if([roommsg.service_type isEqualToString:MSG_Service_Type_Online])
    {
        NSLog(@"直播间pv: %ld uv:%ld",(long)roommsg.pv,(long)roommsg.uv);
    }
}

#pragma mark - shouldAutorotate
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
