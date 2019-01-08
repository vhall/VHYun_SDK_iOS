//
//  DocumentDemoViewController.m
//  VHYunSDKDemo
//
//  Created by vhall on 2018/10/15.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import "DocumentDemoViewController.h"
#import "VHDocument.h"
//#import "UploadFileViewController.h"


#define OBJ_Color @[@"#FF0000",@"#FF7D00",@"#FFFF00",@"#00FF00",@"#0000FF",@"#00FFFF",@"#FF00FF",@"#000000"]

@interface DocumentDemoViewController ()<VHDocumentDelegate>
{
    UIColor   *_color;
    NSInteger _size;
}
@property(nonatomic,strong)VHDocument * document;
@property (weak, nonatomic) IBOutlet UIView *preView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIView *pptOptView;
@property (weak, nonatomic) IBOutlet UITextField *docIDTextField;

@property (weak, nonatomic) IBOutlet UILabel *lineSizeLabel;
@end

@implementation DocumentDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //阻止iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    _size = 5;
    [self initView];
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
    _document = [[VHDocument alloc]initWithChannelID:self.channelID roomID:self.roomID  accessToken:self.accessToken];
    _document.delegate = self;
    _document.view.frame = _preView.bounds;
    _document.view.backgroundColor = MakeColorRGB(0xE2E8EB);
    [_preView addSubview:_document.view];
    
    _document.view.editEnable = _isPublish;
    _pptOptView.hidden = !_isPublish;
}

- (void)viewDidLayoutSubviews
{
    _document.view.frame    = _preView.bounds;
}

- (IBAction)backBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)pptShowOptBtnClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _document.view.editEnable = sender.selected;
    _pptOptView.hidden = !sender.selected;
}

- (IBAction)pptOptBtnClicked:(UIButton*)sender {
    switch (sender.tag) {
        case 100://上一页
            [_document.view prevPage];
            break;
        case 101://上一步
            [_document.view prevStep];
            break;
        case 102://下一步
            [_document.view nextStep];
            break;
        case 103://下一页
            [_document.view nextPage];
            break;
        default:
            break;
    }
}

- (IBAction)setDocBtnClicked:(id)sender {
    __weak typeof(self) wf = self;
    [_document setDocWithID:_docIDTextField.text];
}


- (IBAction)btnClicked:(UIButton*)sender {
    for (int i = 1; i <= 10; i++) {
        UIButton*v = [_pptOptView viewWithTag:i];
        if([v isKindOfClass:[UIButton class]])
        {
            v.selected = NO;
        }
    }
    
    if(!_document.view.editGraffitEnable)
        return;
    
    sender.selected = NO;
    switch (sender.tag) {
        case VHDrawType_Pen:
        case VHDrawType_Highlighter:
        case VHDrawType_Rectangle:
        case VHDrawType_Circle:
        case VHDrawType_Arrow:
        {
            sender.selected = YES;
            _document.view.drawType = sender.tag;
            [_document.view setColor:_color];
            [_document.view setSize:_size];
        }
            break;
        case VHDrawType_Text:
        {
            sender.selected = YES;
            _document.view.drawType = sender.tag;
        }
            break;
        case VHDrawType_Image:
        {

        }
            break;
        case 10://选择修改模式
        {
            sender.selected = YES;
            _document.view.drawAction = VHDrawAction_Modify;
        }
            break;
        case 11:_document.view.drawAction = VHDrawAction_Delete; break;//Del
        case 12:[_document.view clear];break;//DelAll
        case 13:[_document.view undo];break;//Undo
        case 14:[_document.view redo];break;//Redo
        default:break;
    }
}
- (IBAction)sliderValueChanged:(UISlider *)sender {
    switch (sender.tag) {
        case 90:
        {
            _size = sender.value;
            [_document.view setSize:_size];
            _lineSizeLabel.text = [NSString stringWithFormat:@"线/字大小:%d",(int)_size];
        }
            break;
        default:
            break;
    }
}
- (IBAction)colorValueChanged:(UISegmentedControl *)sender {
    NSString *colorStr = OBJ_Color[sender.selectedSegmentIndex];
    _color = [DocumentDemoViewController CGColor:colorStr];
    [_document.view setColor:_color];
}

- (IBAction)editGraffitEnablebtnClicked:(UIButton*)sender {
    sender.selected = !sender.selected;
    _document.view.editGraffitEnable = sender.selected;
    if(!_document.view.editGraffitEnable)
        [self btnClicked:nil];
}

- (IBAction)fileBtnClicked:(UIButton *)sender {
//    UploadFileViewController * vc = [[UploadFileViewController alloc] init];
//    vc.accessToken = _accessToken;
//    [self presentViewController:vc animated:YES completion:nil];
}

 #pragma mark - VHDocumentDelegate
- (void)documentViewDidLoad
{

}
- (void)document:(VHDocument *)document documentID:(NSString*) documentID curPage:(int)curPage
{
    _docIDTextField.text = documentID;
    _infoLabel.text = [NSString stringWithFormat:@"Page: %d/%d  Step:%d/%d",_document.view.currentPage+1,_document.view.totalPage,_document.view.currentStep+1,_document.view.totalStep];
}

- (void)document:(VHDocument *)document error:(NSError *)error
{
    [self showMsg:error.domain afterDelay:2];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
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

@end
