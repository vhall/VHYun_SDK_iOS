//
//  InitSDKViewController.m
//  VHYunSDKDemo_LSS
//
//  Created by vhall on 2019/7/19.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "InitSDKViewController.h"
#import <objc/message.h>
#import "UIView+ITTAdditions.h"
#import "VHStystemSetting.h"

@interface InitSDKViewController ()
@property (weak, nonatomic) IBOutlet UITextField *appIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *userIDTextField;
@property (weak, nonatomic) IBOutlet UILabel *bundleIDLabel;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *avatarTextField;
@end

@implementation InitSDKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
    
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
    NSLog(@"微吼云 Foundation Version: %@",[VHLiveBase getSDKVersion]);
    
    [VHLiveBase setAppGroup:DEMO_GroupID];

    _appIDTextField.text = DEMO_Setting.appID;
    _userIDTextField.text = DEMO_Setting.third_party_user_id;
    _nicknameTextField.text = DEMO_Setting.nickName;
    _avatarTextField.text = DEMO_Setting.avatar;
    _bundleIDLabel.text = [NSBundle mainBundle].bundleIdentifier;
}

- (IBAction)nextBtnClicked:(id)sender {
    [self hideKeyBoard];

    DEMO_Setting.appID = _appIDTextField.text;
    DEMO_Setting.third_party_user_id =_userIDTextField.text;
    
    if(DEMO_Setting.appID.length<=0)
    {
        [self showMsg:@"appID 不能为空" afterDelay:1];
        return;
    }
    if(DEMO_Setting.third_party_user_id.length<=0)
    {
        [self showMsg:@"用户ID 不能为空" afterDelay:1];
        return;
    }
    DEMO_Setting.nickName = _nicknameTextField.text;
    DEMO_Setting.avatar   = _avatarTextField.text;

    __weak typeof(self)wf = self;
    [VHLiveBase registerApp:DEMO_Setting.appID completeBlock:^(NSError *error) {
        if(error)
        {
            [wf showMsg:error.domain afterDelay:2];
        }
        else
        {
            [wf dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [VHLiveBase setThirdPartyUserId:DEMO_Setting.third_party_user_id context:@{@"nick_name":DEMO_Setting.nickName,@"avatar":DEMO_Setting.avatar}];
}

- (void)hideKeyBoard
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
