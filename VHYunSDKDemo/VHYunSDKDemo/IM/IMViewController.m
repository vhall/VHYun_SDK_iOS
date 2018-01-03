//
//  IMViewController.m
//  VHYunSDKDemo
//
//  Created by vhall on 2017/12/19.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import "IMViewController.h"
#import "VHImSDK.h"
#import "UIImageView+WebCache.h"

@interface IMViewController ()<VHImSDKDelegate>
{
    NSMutableArray *_msgArr;
}
@property(nonatomic,strong)VHImSDK * chatSDK;
@property (weak, nonatomic) IBOutlet UITextField *msgTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@end

@implementation IMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _msgArr = [NSMutableArray array];
    
    _chatSDK = [[VHImSDK alloc]initWithChannelID:self.channelID accessToken:self.accessToken];
    _chatSDK.delegate = self;
    
    _tableView.rowHeight = 60;
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
    NSString *str = [NSString stringWithFormat:@"[%@][%@]%@",message.nick_name?message.nick_name:@"",message.third_party_user_id,message.date_time];
    cell.textLabel.text = str;
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",message.data];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:9];
    cell.detailTextLabel.numberOfLines = 0;
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
- (void)imSDK:(VHImSDK *)imSDK receiveMessage:(VHMessage*)message
{
    [_msgArr insertObject:message atIndex:0];
    [_tableView reloadData];
}

- (void)imSDK:(VHImSDK *)imSDK error:(NSError *)error
{
    [self showMsg:[NSString stringWithFormat:@"%ld%@",error.code,error.domain] afterDelay:2];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}


@end
