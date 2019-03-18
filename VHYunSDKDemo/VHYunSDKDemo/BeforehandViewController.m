//
//  BeforehandViewController.m
//  VHYunSDKDemo
//
//  Created by vhall on 2019/3/12.
//  Copyright © 2019年 www.vhall.com. All rights reserved.
//

#import "BeforehandViewController.h"
#import "AppDelegate.h"

@interface BeforehandViewController ()
@property (weak, nonatomic) IBOutlet UITextField *appIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *userIDTextField;
@property (weak, nonatomic) IBOutlet UILabel *bundleIDLabel;
@end

@implementation BeforehandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _appIDTextField.text = DEMO_Setting.appID;
    _userIDTextField.text = DEMO_third_party_user_id;
    _bundleIDLabel.text = [NSBundle mainBundle].bundleIdentifier;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)nextBtnClicked:(id)sender {
    [self hideKeyBoard];
    if(_appIDTextField.text.length<=0)
    {
        [self showMsg:@"appID 不能为空" afterDelay:1];
        return;
    }
    if(_userIDTextField.text.length<=0)
    {
        [self showMsg:@"用户ID 不能为空" afterDelay:1];
        return;
    }
    
    DEMO_Setting.appID = _appIDTextField.text;
    DEMO_Setting.third_party_user_id =_userIDTextField.text;
    
    [VHLiveBase registerApp:DEMO_Setting.appID];
    [VHLiveBase setThirdPartyUserId:DEMO_Setting.third_party_user_id];
    
    UIWindow *mainWindow = nil;
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        mainWindow = [app.delegate window];
    }
    else
    {
        mainWindow = [app keyWindow];
    }
    
    //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    //由storyboard根据myView的storyBoardID来获取我们要切换的视图
    UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"ViewController"];
    
    mainWindow.rootViewController = myView;
    [((AppDelegate*)app.delegate) updateInfo];
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
