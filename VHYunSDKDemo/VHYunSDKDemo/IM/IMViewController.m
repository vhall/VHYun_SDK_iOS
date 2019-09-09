//
//  IMViewController.m
//  VHYunSDKDemo
//
//  Created by vhall on 2017/12/19.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import "IMViewController.h"
#import <VHIM/VHImSDK.h>
#import "UIImageView+WebCache.h"

#import <AVFoundation/AVFoundation.h>
#include <VHLSS/VHLivePublisher.h>

@interface IMViewController ()<VHImSDKDelegate,VHLivePublisherDelegate>
{
    NSMutableArray *_msgArr;
}
@property(nonatomic,strong)VHImSDK * chatSDK;
@property (weak, nonatomic) IBOutlet UITextField *msgTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UITextField *imagemsgTextField;


@property (strong, nonatomic)VHLivePublisher *publisher;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UILabel *bitRateLabel;
@property (weak, nonatomic) IBOutlet UIButton *videoStartAndStopBtn;

@property (assign, nonatomic) BOOL  isVideoStart;
@end

@implementation IMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _msgArr = [NSMutableArray array];
    
    _chatSDK = [[VHImSDK alloc]initWithChannelID:self.channelID accessToken:self.accessToken delegate:self];
    _chatSDK.delegate = self;
    
    _tableView.rowHeight = 60;
    
    if(self.roomID.length>0)
        [self initPubisher];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self.navigationController popViewControllerAnimated:NO];
}


- (IBAction)sendBtnClicked:(id)sender {
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if(_msgTextField.text.length > 0 )
    {
        __weak typeof(self) wf = self;
        [self showProgressDialog:_sendBtn];
        [_chatSDK sendMessage:_msgTextField.text completed:^(NSError *error) {
             [wf hideProgressDialog:wf.sendBtn];
            if(error)
                [wf showMsg:[NSString stringWithFormat:@"%ld%@",error.code,error.domain] afterDelay:2];
            else
                [wf showMsg:@"发送成功" afterDelay:2];
        }];
    }
}
- (IBAction)sendImageBtnClicked:(id)sender {
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if(_imagemsgTextField.text.length > 0 )
    {
        __weak typeof(self) wf = self;
        [self showProgressDialog:_sendBtn];
        [_chatSDK sendMessage:@[_imagemsgTextField.text] type:VHIMMessageTypeImage text:_msgTextField.text audit:YES completed:^(NSError *error) {
            [wf hideProgressDialog:wf.sendBtn];
            if(error)
                [wf showMsg:[NSString stringWithFormat:@"%ld%@",error.code,error.domain] afterDelay:2];
            else
                [wf showMsg:@"发送成功" afterDelay:2];
        }];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _msgArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static   NSString *Identifier = @"noiseSwitchCell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];

    VHMessage *message = _msgArr[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"[%@][%@]%@",message.nick_name?message.nick_name:@"",message.sender_id,message.date_time];
    cell.textLabel.text = str;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    if([message.service_type isEqualToString:MSG_Service_Type_IM])
    {
        if([message.data[MSG_Type] isEqualToString:MSG_IM_Type_Text])
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",message.data[MSG_IM_Text_Content]];
        else if([message.data[MSG_Type] isEqualToString:MSG_IM_Type_Image])
        {
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@,%@",message.data[MSG_IM_Text_Content],message.data[MSG_IM_Image_Urls]];
        }
        //其他情况可自行处理
    }
    else if([message.service_type isEqualToString:MSG_Service_Type_Customt])
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"【自定义】%@",message.data];
    }
    else if([message.service_type isEqualToString:MSG_Service_Type_Online])
    {
        if([message.data[MSG_Type] isEqualToString:MSG_Online_Join])
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"【上线】pv: %ld uv: %ld ",(long)message.pv,(long)message.uv];
        }
        else if([message.data[MSG_Type] isEqualToString:MSG_Online_Leave])
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"【下线】pv: %ld uv: %ld ",(long)message.pv,(long)message.uv];
        }
    }
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:9];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:message.avatar] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    cell.imageView.contentMode = UIViewContentModeScaleToFill; 
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - VHImSDKDelegate
/**
 *  接收IM消息
 *  @param imSDK IM实例
 *  @param message   IM消息
 */
- (void)imSDK:(VHImSDK *)imSDK receiveChatMessage:(VHMessage*)message
{
    [_msgArr insertObject:message atIndex:0];
    [_tableView reloadData];
}
/**
 *  上下线消息
 *  @param imSDK IM实例
 *  @param message   消息
 */
- (void)imSDK:(VHImSDK *)imSDK receiveOnlineMessage:(VHMessage*)message
{
    [_msgArr insertObject:message atIndex:0];
    [_tableView reloadData];
}

/**
 *  接收自定义消息
 *  @param imSDK IM实例
 *  @param message   自定义消息
 */
- (void)imSDK:(VHImSDK *)imSDK receiveCustomMessage:(VHMessage*)message
{
    [_msgArr insertObject:message atIndex:0];
    [_tableView reloadData];
}

/**
 *  错误回调
 *  @param imSDK IM实例
 *  @param error    错误
 */
- (void)imSDK:(VHImSDK *)imSDK error:(NSError *)error
{
    [self showMsg:[NSString stringWithFormat:@"%ld%@",(long)error.code,error.domain] afterDelay:2];
}



-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
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
