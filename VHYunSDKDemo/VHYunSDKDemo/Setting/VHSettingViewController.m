//
//  VHSettingViewController.m
//  VHYunSDKDemo
//
//  Created by vhall on 2017/12/19.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//


#import "VHSettingViewController.h"
#import "VHSettingGroup.h"
#import "VHSettingTextFieldItem.h"
#import "VHSettingTableViewCell.h"
#import "VHSettingArrowItem.h"
#import "CustomPickerView.h"

@interface VHSettingViewController()<UITableViewDataSource,UITableViewDelegate,CustomPickerViewDataSource,CustomPickerViewDelegate,UITextFieldDelegate>
{
    NSArray * _selectArray;
    //基础设置
    VHSettingTextFieldItem *item00;
    //直播播放
    VHSettingTextFieldItem *item10;
    VHSettingTextFieldItem *item11;
    VHSettingTextFieldItem *item12;
    //推流
    VHSettingTextFieldItem *item20;
    VHSettingTextFieldItem *item21;
    VHSettingTextFieldItem *item22;
    VHSettingTextFieldItem *item23;
    VHSettingTextFieldItem *item24;
    VHSettingTextFieldItem *item25;
    VHSettingTextFieldItem *item26;
    //点播
    VHSettingTextFieldItem *item30;
    VHSettingTextFieldItem *item31;
    //文档直播
    VHSettingTextFieldItem *item40;
    VHSettingTextFieldItem *item41;
    //IM
    VHSettingTextFieldItem *item50;
    VHSettingTextFieldItem *item51;
    
    UISwitch *_noiseSwitch;//降噪开关
    UISlider *_volumeAmplificateSlider;//增益
}
@property(nonatomic,strong) NSMutableArray *groups;

@property(nonatomic,strong) CustomPickerView    *pickerView;//选择框控件
@property(nonatomic,strong) UITableView         *tableView;
@property(nonatomic,strong) UITextField         *tempTextField;
@end

@implementation VHSettingViewController

//-(instancetype)init
//{
//    return [super initWithStyle:UITableViewStyleGrouped];
//}


-(NSMutableArray *)groups
{
    if (!_groups)
    {
        _groups = [NSMutableArray array];
    }
    return _groups;
}


-(void)initWithView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:)
                                            name:UIKeyboardDidHideNotification object:nil];
    [[UIApplication sharedApplication].keyWindow setBackgroundColor:[UIColor whiteColor]];
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    headerView.backgroundColor=[UIColor blackColor];
    [self.view insertSubview:headerView atIndex:0];
    
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0,20, 44, 44)];
    [back setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:back];

    
    UILabel *title=[[UILabel alloc] init];
    [title setTextColor:[UIColor whiteColor]];
    [title setText:@"参数设置"];
    [title setFont:[UIFont systemFontOfSize:18]];
    [title sizeToFit];
    title.center = CGPointMake(headerView.center.x, 40);
    [headerView addSubview:title];

    _pickerView = [CustomPickerView loadFromXib];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_pickerView setTitle:@"请选择分辨率"];
    
    _noiseSwitch = [[UISwitch alloc]init];
    [_noiseSwitch addTarget:self action:@selector(noiseSwitch) forControlEvents:UIControlEventValueChanged];
    _volumeAmplificateSlider = [[UISlider alloc]init];
    _volumeAmplificateSlider.minimumValue = 0;
    _volumeAmplificateSlider.maximumValue = 1.0;
    [_volumeAmplificateSlider addTarget:self action:@selector(volumeAmplificate) forControlEvents:UIControlEventValueChanged];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
   // tableView.backgroundColor=[UIColor whiteColor];
    _tableView.userInteractionEnabled=YES;

    _tableView.dataSource= self;
    _tableView.delegate = self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    if ([_tableView  respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [_tableView reloadData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    _selectArray = @[@"352X288",@"640X480",@"960X540",@"1280X720"];
    self.title = @"设置";
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
    [self setupGroup4];
    [self setupGroup5];
    [self initWithView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _pickerView.frame = [UIScreen mainScreen].bounds;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setupGroup0
{
    item00 = [VHSettingTextFieldItem itemWithTitle:@"第三方ID"];
    item00.text = DEMO_Setting.third_party_user_id;
    VHSettingGroup *group= [VHSettingGroup groupWithItems:@[item00]];
    group.headerTitle = @"基础设置";
    [self.groups addObject:group];
}
-(void)setupGroup1
{
    item10 = [VHSettingTextFieldItem  itemWithTitle:@"看直播房间ID"];
    item10.text=DEMO_Setting.playerRoomID;
    item11 = [VHSettingTextFieldItem  itemWithTitle:@"看直播AccessToken"];
    item11.text=DEMO_Setting.playerAccessToken;
    item12 = [VHSettingTextFieldItem  itemWithTitle:@"缓存时间"];
    item12.text=[NSString stringWithFormat:@"%ld",(long)DEMO_Setting.bufferTime];
    VHSettingGroup *group= [VHSettingGroup groupWithItems:@[item10,item11,item12]];
    group.headerTitle = @"看直播设置";
    [self.groups addObject:group];
}

-(void)setupGroup2
{
    __weak typeof(self) weakSelf = self;
    item20 = [VHSettingTextFieldItem  itemWithTitle:@"推流房间ID"];
    item20.text = DEMO_Setting.publishRoomID;
    item21 = [VHSettingTextFieldItem  itemWithTitle:@"推流AccessToken"];
    item21.text =  DEMO_Setting.publishAccessToken;
    item22 = [VHSettingTextFieldItem  itemWithTitle:@"分辨率"];
    item22.text = _selectArray[[DEMO_Setting.videoResolution intValue]];
    item22.operation=^(NSIndexPath *indexPath)
    {
        [weakSelf.tempTextField endEditing:YES];
        [weakSelf.pickerView showPickerView:weakSelf.view];
    };
    item23 = [VHSettingTextFieldItem  itemWithTitle:@"视频码率(kpbs)"];
    item23.text = [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.videoBitRate];
    item24 = [VHSettingTextFieldItem  itemWithTitle:@"视频帧率(fps)"];
    item24.text =  [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.videoCaptureFPS];
    item25 = [VHSettingTextFieldItem  itemWithTitle:@"音频码率(kpbs)"];
    item25.text = [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.audioBitRate];
    VHSettingGroup *group= [VHSettingGroup groupWithItems:@[item20,item21,item22,item23,item24,item25]];
    group.headerTitle = @"推流设置";
    [self.groups addObject:group];
    //此处还有一个噪音开关 和 音频增益 tableView 读取时会加2行
}

-(void)setupGroup3
{
    item30 = [VHSettingTextFieldItem  itemWithTitle:@"点播房间ID"];
    item30.text=DEMO_Setting.recordID;
    item31 = [VHSettingTextFieldItem  itemWithTitle:@"点播AccessToken"];
    item31.text=DEMO_Setting.vodAccessToken;
    VHSettingGroup *group= [VHSettingGroup groupWithItems:@[item30,item31]];
    group.headerTitle = @"点播设置";
    [self.groups addObject:group];
}

-(void)setupGroup4
{
    item40 = [VHSettingTextFieldItem  itemWithTitle:@"文档channelID"];
    item40.text=DEMO_Setting.docChannelID;
    item41 = [VHSettingTextFieldItem  itemWithTitle:@"文档AccessToken"];
    item41.text=DEMO_Setting.docAccessToken;
    VHSettingGroup *group= [VHSettingGroup groupWithItems:@[item40,item41]];
    group.headerTitle = @"文档设置";
    [self.groups addObject:group];
}

-(void)setupGroup5
{
    item50 = [VHSettingTextFieldItem  itemWithTitle:@"IM channelID"];
    item50.text=DEMO_Setting.imChannelID;
    item51 = [VHSettingTextFieldItem  itemWithTitle:@"IM AccessToken"];
    item51.text=DEMO_Setting.imAccessToken;
    VHSettingGroup *group= [VHSettingGroup groupWithItems:@[item50,item51]];
    group.headerTitle = @"IM设置";
    [self.groups addObject:group];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    VHSettingGroup *group =self.groups[section];
    if(section == 2)
        return group.items.count+2;//增加 噪音开关 和 音频增益 两行
    return group.items.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VHSettingGroup *group=self.groups [indexPath.section];
    if(indexPath.section == 2 && indexPath.row == group.items.count)
    {
        static   NSString *Identifier = @"noiseSwitchCell";
        UITableViewCell *noiseSwitchcell =[tableView dequeueReusableCellWithIdentifier:Identifier];
        if (noiseSwitchcell == nil)
            noiseSwitchcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        _noiseSwitch.on = DEMO_Setting.isOpenNoiseSuppresion;
        noiseSwitchcell.textLabel.text = @"音频降噪";
        noiseSwitchcell.textLabel.font = [UIFont systemFontOfSize:14];
        _noiseSwitch.left = self.view.width - 60;
        _noiseSwitch.top = 10;
        [noiseSwitchcell.contentView addSubview:_noiseSwitch];
        return noiseSwitchcell;
    }

    if(indexPath.section == 2 && indexPath.row == group.items.count+1)
    {
        static   NSString *Identifier = @"volumeAmplificateCell";
        UITableViewCell *volumeAmplificatecell =[tableView dequeueReusableCellWithIdentifier:Identifier];
        if (volumeAmplificatecell == nil)
            volumeAmplificatecell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        _volumeAmplificateSlider.value = DEMO_Setting.volumeAmplificateSize;
        volumeAmplificatecell.textLabel.text = [NSString stringWithFormat:@"音频增益 -- %0.2f",DEMO_Setting.volumeAmplificateSize];
        volumeAmplificatecell.textLabel.font = [UIFont systemFontOfSize:14];
        _volumeAmplificateSlider.left  = 150;
        _volumeAmplificateSlider.top   = 10;
        _volumeAmplificateSlider.width = self.view.width - 160;
        [volumeAmplificatecell.contentView addSubview:_volumeAmplificateSlider];
        return volumeAmplificatecell;
    }
    
    __weak typeof(self) weakSelf=self;
    VHSettingTableViewCell *cell =[VHSettingTableViewCell  cellWithTableView:tableView];
    VHSettingItem          *item = group.items[indexPath.row];
    item.indexPath=indexPath;
    cell.item  =item;
    
    cell.inputText= ^(NSString *text)
    {
        if ([text isEqualToString:@""])
        {
            text = nil;
        }
        
        [weakSelf value:text indexPath:indexPath];
    };
    
    cell.changePosition=^(UITextField *textField)
    {
        weakSelf.tempTextField=textField;
    };
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VHSettingGroup *group=self.groups [indexPath.section];
    if(indexPath.section == 1 && indexPath.row == group.items.count)
    {
        return;
    }
    VHSettingItem  *item = group.items[indexPath.row];
    if (item.operation)
    {
        item.operation(indexPath);
    }else if ([item isKindOfClass:[VHSettingTextFieldItem class]])
    {
        
    }else if ([item isKindOfClass:[VHSettingArrowItem  class]])
    {
        VHSettingArrowItem *arrowItem = (VHSettingArrowItem*)item;
        if (arrowItem.desVc)
        {
            UIViewController *vc =[[arrowItem.desVc alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    // 取出组模型
    VHSettingGroup *group =  self.groups[section];
    return group.headerTitle;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:   (NSInteger)section{
    // 取出组模型
    VHSettingGroup *group =  self.groups[section];
    return group.footTitle;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)showKeyboard:(NSNotification *)noti
{
    self.view.transform = CGAffineTransformIdentity;
    UIView *editView = _tempTextField;
    
    CGRect tfRect = [editView.superview convertRect:editView.frame toView:self.view];
    NSValue *value = noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    NSLog(@"%@", value);
    CGRect keyBoardF = [value CGRectValue];
    
    CGFloat animationTime = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGFloat _editMaxY = CGRectGetMaxY(tfRect);
    CGFloat _keyBoardMinY = CGRectGetMinY(keyBoardF);
    NSLog(@"%f %f", _editMaxY, _keyBoardMinY);
    if (_keyBoardMinY < _editMaxY) {
        CGFloat moveDistance = _editMaxY - _keyBoardMinY;
        [UIView animateWithDuration:animationTime animations:^{
            self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -moveDistance);
        }];
    }
}

- (void)hideKeyboard:(NSNotification *)noti
{
    [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
    [UIView setAnimationDuration:0.3];
    self.view.transform = CGAffineTransformIdentity;
    
    [UIView commitAnimations];
}

#pragma mark event
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)customPickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
{
    NSString * title =_selectArray[row];
    [item22 setText:title];
    DEMO_Setting.videoResolution =  [NSString stringWithFormat:@"%ld",(long)row];
    [_tableView reloadData];
}
#pragma mark - CustomPickerViewDataSource
- (NSString*)titleOfRowCustomPickerViewWithRow:(NSInteger)row
{
    NSString * title =_selectArray[row];
    return title;
}

- (NSInteger)numberOfRowsInPickerView
{
    return _selectArray.count;
}

-(void)value:(NSString*)text indexPath:(NSIndexPath*)indexpath
{
    switch (indexpath.section) {
        case 0:
        {
            switch (indexpath.row) {
                case 0:
                {
                    DEMO_Setting.third_party_user_id = text;
                    item00.text = DEMO_Setting.third_party_user_id;
                }
                    break;
                default:break;
            }
        }
            break;
        case 1:
        {
            switch (indexpath.row) {
                case 0:
                {
                    DEMO_Setting.playerRoomID = text;
                    item10.text = DEMO_Setting.playerRoomID;
                }
                    break;
                case 1:
                {
                    DEMO_Setting.playerAccessToken = text;
                    item11.text = DEMO_Setting.playerAccessToken;
                }
                    break;
                case 2:
                {
                    DEMO_Setting.bufferTime = [text integerValue];
                    item12.text = [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.bufferTime];
                }
                    break;
                default:break;
            }
        }
            break;
        case 2:
        {
            switch (indexpath.row) {
                case 0:
                {
                    DEMO_Setting.publishRoomID = text;
                    item20.text = DEMO_Setting.publishRoomID;
                }
                    break;
                case 1:
                {
                    DEMO_Setting.publishAccessToken = text;
                    item21.text = DEMO_Setting.publishAccessToken;
                }
                    break;
                case 2:break;
                case 3:
                {
                    DEMO_Setting.videoBitRate= [text integerValue];
                    item23.text = [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.videoBitRate];
                }
                    break;
                case 4:
                {
                    DEMO_Setting.videoCaptureFPS = [text integerValue];
                    item24.text =  [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.videoCaptureFPS];
                }
                    break;
                case 5:
                {
                    DEMO_Setting.audioBitRate = [text integerValue];
                    item25.text = [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.audioBitRate];
                }
                    break;
                default:break;
            }
        }
            break;
        case 3:
        {
            switch (indexpath.row) {
                case 0:
                {
                    DEMO_Setting.recordID = text;
                    item30.text = DEMO_Setting.recordID;
                }
                    break;
                case 1:
                {
                    DEMO_Setting.vodAccessToken = text;
                    item31.text = DEMO_Setting.vodAccessToken;
                }
                    break;
                default:break;
            }
        }
            break;
        case 4:
        {
            switch (indexpath.row) {
                case 0:
                {
                    DEMO_Setting.docChannelID = text;
                    item40.text = DEMO_Setting.docChannelID;
                }
                    break;
                case 1:
                {
                    DEMO_Setting.docAccessToken = text;
                    item41.text = DEMO_Setting.docAccessToken;
                }
                    break;
                default:break;
            }
        }
            break;
        case 5:
        {
            switch (indexpath.row) {
                case 0:
                {
                    DEMO_Setting.imChannelID = text;
                    item50.text = DEMO_Setting.imChannelID;
                }
                    break;
                case 1:
                {
                    DEMO_Setting.imAccessToken = text;
                    item51.text = DEMO_Setting.imAccessToken;
                }
                    break;
                default:break;
            }
        }
            break;
        default:
            break;
    }
}

- (void)noiseSwitch
{
    DEMO_Setting.isOpenNoiseSuppresion = _noiseSwitch.on;
}

- (void)volumeAmplificate
{
    DEMO_Setting.volumeAmplificateSize = _volumeAmplificateSlider.value;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow: ((VHSettingGroup*)self.groups[2]).items.count+1 inSection:2];
    UITableViewCell * cell = [_tableView cellForRowAtIndexPath:indexpath];
    cell.textLabel.text = [NSString stringWithFormat:@"音频增益 -- %0.2f",DEMO_Setting.volumeAmplificateSize];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
     [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

-(BOOL)shouldAutorotate
{
    return NO;
}
@end













