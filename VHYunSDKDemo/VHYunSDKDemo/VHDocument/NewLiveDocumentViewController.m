//
//  NewVodDocumentViewController.m
//  VHYunSDKDemo
//
//  Created by vhall on 2017/12/14.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import "NewLiveDocumentViewController.h"
#import <VHDoc/VHDocument.h>
#import <VHLSS/VHLivePlayer.h>
#import <VHLSS/VHMessage.h>

@interface NewLiveDocumentViewController ()<VHLivePlayerDelegate,VHDocumentDelegate>

@property (strong, nonatomic)VHLivePlayer *player;
@property(nonatomic,strong)VHDocument * document;
@property (weak, nonatomic) IBOutlet UIView *preView;
@property (weak, nonatomic) IBOutlet UIView *docConentView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *cidLabel;

@end

@implementation NewLiveDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;

    //阻止iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    
    _document = [[VHDocument alloc]initWithChannelID:self.channelID roomID:self.roomID accessToken:self.accessToken];
    _document.delegate = self;
    _document.frame = _docConentView.bounds;
    _document.backgroundColor = MakeColorRGB(0xE2E8EB);
    
    if(self.roomID.length>0)
    {
        _player = [[VHLivePlayer alloc]init];
        _player.delegate = self;
        
        [self.preView insertSubview:_player.view atIndex:0];
        _player.view.frame = _preView.bounds;
        [_player startPlay:self.roomID accessToken:self.accessToken];
        [self showProgressDialog:self.preView];
    }
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
}

#pragma mark - VHLivePlayerDelegate
- (void)player:(VHLivePlayer *)player statusDidChange:(int)state
{
    switch (state) {
        case VHPlayerStatusLoading:
        {
            [self showProgressDialog:self.preView];
        }
            break;
        case VHPlayerStatusPlaying:
        {
            [self hideProgressDialog:self.preView];
        }
            break;
        case VHPlayerStatusStop:
        {
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

}

- (void)player:(VHLivePlayer *)player validDefinitions:(NSArray*)definitions curDefinition:(VHDefinition)definition
{
    NSLog(@"curDefinition: %ld definitions:%@",(long)definition,definitions);
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
            [self showMsg:@"主持人已停止推流" afterDelay:1.5];
        }
    }
    else if([roommsg.service_type isEqualToString:MSG_Service_Type_Online])
    {
        NSLog(@"直播间pv: %ld uv:%ld",(long)roommsg.pv,(long)roommsg.uv);
    }
}


#pragma mark - VHDocumentDelegate
- (void)document:(VHDocument *)document error:(NSError *)error{
    [self showMsg:error.domain afterDelay:2];
}
- (float)document:(VHDocument *)document delayChannelID:(NSString*)channelID
{
    return _player.realityBufferTime/1000.0;//文档直播同步
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
    [self updateCurDocInfo];
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
