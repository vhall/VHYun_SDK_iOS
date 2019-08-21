//
//  DocumentDemoViewController.m
//  VHYunSDKDemo
//
//  Created by vhall on 2018/10/15.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import "NewDocumentDemoViewController.h"
#import <VHDoc/VHDocument.h>
#import <AVFoundation/AVFoundation.h>
#include <VHLSS/VHLivePublisher.h>

#define OBJ_Color @[@"#FF0000",@"#FF7D00",@"#FFFF00",@"#00FF00",@"#0000FF",@"#00FFFF",@"#FF00FF",@"#000000"]

@interface VHDocSelectButton:UIButton
@property (strong)NSString *cid;
@end
@implementation VHDocSelectButton
@end

@interface NewDocumentDemoViewController ()<VHDocumentDelegate,VHLivePublisherDelegate>
{
    UIColor   *_color;
    NSInteger _size;
    NSMutableDictionary *_tabItemDic;
}
@property(nonatomic,strong)VHDocument * document;
@property (weak, nonatomic) IBOutlet UIView *preView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIView *pptOptView;
@property (weak, nonatomic) IBOutlet UITextField *docIDTextField;

@property (weak, nonatomic) IBOutlet UILabel *lineSizeLabel;

@property (weak, nonatomic) IBOutlet UILabel *cidLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UISwitch *showDocSwitch;

@property (weak, nonatomic) IBOutlet UIButton *editGraffitEnableBtn;

@property (strong, nonatomic)VHLivePublisher *publisher;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UILabel *bitRateLabel;
@property (weak, nonatomic) IBOutlet UIButton *videoStartAndStopBtn;

@property (assign, nonatomic) BOOL  isVideoStart;
@property(nonatomic,assign)BOOL isPublish;
@end

@implementation NewDocumentDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //阻止iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    _size = 5;
    [self initView];
    if(self.roomID.length>0)
        [self initPubisher];
}

- (void)dealloc
{
    //允许iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)initView
{
    _document = [[VHDocument alloc]initWithChannelID:self.channelID roomID:self.roomID accessToken:self.accessToken loadLastDoc:_isLoadLastDoc];
    _document.delegate = self;
    self.isPublish = NO;
}

- (void)setIsPublish:(BOOL)isPublish
{
    _isPublish = isPublish;
    _document.editEnable = _isPublish;//设置为可编译状态
    _pptOptView.hidden = !_isPublish;
    _deleteBtn.hidden = _pptOptView.hidden;
    [self updateCurDocInfo];
}

- (void)viewDidLayoutSubviews
{
    _document.frame    = _preView.bounds;
    for (UIButton *btn in _tabItemDic.allValues) {
        btn.top = _preView.top-15;
    }
}

- (IBAction)backBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)pptShowOptBtnClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.isPublish = sender.selected;
}

- (IBAction)setDocBtnClicked:(UIButton *)sender
{
    if(_docIDTextField.text.length==0)
        return;
    
//    [_document setDocWithDocumentID:_docIDTextField.text success:^{
//
//    } failed:^(NSError * _Nonnull error) {
//
//    }];
}

- (IBAction)pptOptBtnClicked:(UIButton*)sender {
    switch (sender.tag) {
        case 100://上一页
            [_document.selectedView prevPage];
            break;
        case 101://上一步
            [_document.selectedView prevStep];
            break;
        case 102://下一步
            [_document.selectedView nextStep];
            break;
        case 103://下一页
            [_document.selectedView nextPage];
            break;
        default:
            break;
    }
}

- (void)selectBtnClicked:(VHDocSelectButton*)sender {
    if(_document.editEnable)
    {
        [_document selectWithCID:sender.cid];
    }
}

- (IBAction)deleteBtnClicked:(id)sender {
    if(_document.editEnable)
    {
        if(_document.documentViewsByIDs.allKeys.count>0)
        {
            [_document destroyWithCID:_document.selectedView.cid];
            if(_document.documentViewsByIDs.allKeys.count>0)
                [_document selectWithCID:_document.documentViewsByIDs.allKeys[0]];
        }
    }
}

- (IBAction)createDocBtnClicked:(id)sender {

    if(_docIDTextField.text.length==0)
        return;
    
    [_document createDocumentWithFrame:_preView.bounds size:CGSizeMake(800, 600) documentID:_docIDTextField.text backgroundColor:[UIColor whiteColor]];
}

- (IBAction)createBoardBtnClicked:(id)sender {
    [_document createBoardWithFrame:_preView.bounds size:CGSizeMake(800, 600) backgroundColor:MakeColor(arc4random()%256, arc4random()%256, arc4random()%256, 1)];
}
- (IBAction)switchOnValueChange:(UISwitch *)sender {
    if(_document.editEnable)
        _document.switchOn = sender.on;
}

- (IBAction)btnClicked:(UIButton*)sender {
    for (int i = 1; i <= 99; i++) {
        UIButton*v = [_pptOptView viewWithTag:i];
        if([v isKindOfClass:[UIButton class]])
        {
            v.selected = NO;
        }
    }
    
    if(!_document.selectedView.editGraffitEnable)
        return;
    
    sender.selected = NO;
    switch (sender.tag) {
        case VHDrawType_Pen:
        case VHDrawType_Highlighter:
        case VHDrawType_Rectangle:
        case VHDrawType_Circle:
//        case VHDrawType_Arrow:
        case VHDrawType_Isosceles_Triangle:
        case VHDrawType_right_Triangle:
        case VHDrawType_Single_Arrow:
        case VHDrawType_Double_Arrow:
        {
            sender.selected = YES;
            _document.selectedView.drawType = sender.tag;
            [_document.selectedView setColor:_color];
            [_document.selectedView setSize:_size];
        }
            break;
//        case VHDrawType_Text:
//        {
//            sender.selected = YES;
//            _document.view.drawType = sender.tag;
//        }
//            break;
//        case VHDrawType_Image:
//        {
//
//        }
//            break;
        case 110://选择修改模式
        {
            sender.selected = YES;
            _document.selectedView.drawAction = VHDrawAction_Modify;
        }
            break;
        case 111:_document.selectedView.drawAction = VHDrawAction_Delete; break;//Del
        case 112:[_document.selectedView clear];break;//DelAll
        case 113:[_document.selectedView undo];break;//Undo
        case 114:[_document.selectedView redo];break;//Redo
        default:break;
    }
}
- (IBAction)sliderValueChanged:(UISlider *)sender {
    switch (sender.tag) {
        case 90:
        {
            _size = sender.value;
            [_document.selectedView setSize:_size];
            _lineSizeLabel.text = [NSString stringWithFormat:@"线/字大小:%d",(int)_size];
        }
            break;
        default:
            break;
    }
}
- (IBAction)colorValueChanged:(UISegmentedControl *)sender {
    NSString *colorStr = OBJ_Color[sender.selectedSegmentIndex];
    _color = [NewDocumentDemoViewController CGColor:colorStr];
    [_document.selectedView setColor:_color];
}

- (IBAction)editGraffitEnablebtnClicked:(UIButton*)sender {
    sender.selected = !sender.selected;
    _document.selectedView.editGraffitEnable = sender.selected;
    if(!_document.selectedView.editGraffitEnable)
        [self btnClicked:nil];
}

- (IBAction)fileBtnClicked:(UIButton *)sender {
//    UploadFileViewController * vc = [[UploadFileViewController alloc] init];
//    vc.accessToken = _accessToken;
//    [self presentViewController:vc animated:YES completion:nil];
}

 #pragma mark - documentUI
- (void)addTabItem:(VHDocumentView*)documentView
{
    VHDocSelectButton *btn = [VHDocSelectButton buttonWithType:UIButtonTypeSystem];
    btn.cid = documentView.cid;
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn setTitle:documentView.cid forState:UIControlStateNormal];
    btn.frame = CGRectMake(_tabItemDic.count*51,_preView.top-15, 50, 15);
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    [btn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if(!_tabItemDic)
        _tabItemDic = [NSMutableDictionary dictionary];
    [_tabItemDic setObject:btn forKey:documentView.cid];
    
    [self.view insertSubview:btn atIndex:0];
}


 #pragma mark - VHDocumentDelegate
- (void)document:(VHDocument *)document error:(NSError *)error{
    [self showMsg:[NSString stringWithFormat:@"%@(%ld)",error.domain,(long)error.code] afterDelay:2];
}
- (float)document:(VHDocument *)document delayChannelID:(NSString*)channelID{
    return 0.0;//延迟处理时间
}
- (void)document:(VHDocument *)document changePage:(VHDocumentView*)documentView{
    [self updateCurDocInfo];
}
- (void)document:(VHDocument *)document switchStatus:(BOOL)switchStatus{
    NSLog(@"%@",switchStatus?@"文档显示":@"文档隐藏");
    
    if(_document.editEnable)return;
    
    [self updateCurDocInfo];
    
    for (UIView *view in _document.documentViewsByIDs.allValues) {
        view.hidden = !switchStatus;
    }
    
    _showDocSwitch.on = switchStatus;
}

- (void)document:(VHDocument *)document selectDocumentView:(VHDocumentView*)documentView
{
    NSLog(@"选中文档cid: %@",documentView.cid);
    _cidLabel.text = documentView.cid;
    [_preView addSubview:_document.selectedView];

    for (UIButton *btn in _tabItemDic.allValues) {
        btn.selected = NO;
    }
    UIButton *btn = ((UIButton *)(_tabItemDic[documentView.cid]));
    btn.selected = YES;
    [_preView sendSubviewToBack:btn];
    
    _editGraffitEnableBtn.selected = !_document.selectedView.editGraffitEnable;
    [self editGraffitEnablebtnClicked:_editGraffitEnableBtn];
    
    [self updateCurDocInfo];
}

- (void)document:(VHDocument *)document addDocumentView:(VHDocumentView *)documentView
{
    NSLog(@"新增文档cid: %@",documentView.cid);
    documentView.frame = _preView.bounds;
    if([_document.selectedView isEqual:documentView])
        [_preView addSubview:documentView];
    else
        [_preView insertSubview:documentView belowSubview:_document.selectedView];
    
    [self addTabItem:documentView];
    [self updateCurDocInfo];
}

- (void)document:(VHDocument *)document removeDocumentView:(VHDocumentView *)documentView
{
    NSLog(@"删除文档cid: %@",documentView.cid);
    [((UIButton *)(_tabItemDic[documentView.cid])) removeFromSuperview];
    [_tabItemDic removeObjectForKey:documentView.cid];
    
    int i = 0;
    for (UIButton *btn in _tabItemDic.allValues) {
        btn.left = 51*i++;
    }
    [self updateCurDocInfo];
}

#pragma mark - textFieldShouldReturn
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
- (void)updateCurDocInfo
{
    if(!_document.switchOn && !_document.editEnable)
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

+ (UIColor*)CGColor:(NSString*)str
{
    NSRange r = [str rangeOfString:@"#"];
    if(r.location != NSNotFound)
        str = [str stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
    
    r = [str rangeOfString:@"0x"];
    if(r.location == NSNotFound)
        return [UIColor clearColor];
    
    unsigned long c = strtoul([str UTF8String],0,16);
    return [UIColor colorWithRed: ((c>>16)&0xFF) / 255.0  green: ((c>>8)&0xFF) / 255.0  blue: (c&0xFF) / 255.0  alpha: 1 ];
}


-(BOOL)shouldAutorotate
{
    return YES;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


#pragma mark - 直播
- (void)initPubisher
{
    self.cameraView.hidden = NO;
    
    VHPublishConfig* config = [VHPublishConfig configWithType:VHPublishConfigTypeDefault];
    self.publisher = [[VHLivePublisher alloc] initWithConfig:config];
    self.publisher.delegate            = self;
    self.publisher.preView.frame = self.cameraView.bounds;
    [self.publisher setContentMode:VHVideoCaptureContentModeAspectFill];
    [self.cameraView insertSubview:self.publisher.preView atIndex:0];
    //开始视频采集、并显示预览界面
    [self.publisher startCapture];
}
- (IBAction)startPublish:(id)sender
{
#if (TARGET_IPHONE_SIMULATOR)
    [self showMsg:@"无法在模拟器上发起直播！" afterDelay:1.5];
    return;
#endif
    
    if (!_isVideoStart)
    {
        [self showProgressDialog:self.cameraView];
        [_publisher startPublish:self.roomID accessToken:self.accessToken];
    }else{
        _isVideoStart=NO;
        [self stopPublish];
    }
}

- (void)stopPublish
{
    _bitRateLabel.text = @"";
    _isVideoStart = NO;
    [self hideProgressDialog:self.cameraView];
    _videoStartAndStopBtn.selected = NO;
    [_publisher stopPublish];//停止活动
}

#pragma mark - VHLivePublisherDelegate
- (void)onPublishStatus:(VHPublishStatus)status info:(NSDictionary*)info
{
    NSLog(@"状态：%ld %@",(long)status,info);
    switch (status) {
        case VHPublishStatusPushConnectSucceed:
        {
            [self hideProgressDialog:self.cameraView];
            _isVideoStart = YES;
            _videoStartAndStopBtn.selected = YES;
        }
            break;
        case VHPublishStatusUploadSpeed:
            _bitRateLabel.text = [NSString stringWithFormat:@"%@ kb/s",info[@"content"]];
            break;
        case VHPublishStatusUploadNetworkException:
            _bitRateLabel.textColor = [UIColor redColor];
            break;
        case VHPublishStatusUploadNetworkOK:
            _bitRateLabel.textColor = [UIColor greenColor];
            break;
        default:
            break;
    }
}

- (void)onPublishError:(VHPublishError)error info:(NSDictionary*)info
{
    NSLog(@"错误：%ld %@",(long)error,info);
    [self showMsg:[NSString stringWithFormat:@"%@ %@",info[@"code"],info[@"content"]] afterDelay:2];

    [self stopPublish];
}

@end
