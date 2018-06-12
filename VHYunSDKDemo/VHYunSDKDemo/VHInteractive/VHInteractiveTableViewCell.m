//
//  VHSettingTableViewCell.m
//  VHYunSDKDemo
//
//  Created by vhall on 2017/12/19.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//


#import "VHInteractiveTableViewCell.h"


/**
 开启一个定时器
 
 @param target 定时器持有者
 @param timeInterval 执行间隔时间
 @param handler 重复执行事件
 */
void dispatchTimer(id target, double timeInterval,void (^handler)(dispatch_source_t timer))
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer =dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), (uint64_t)(timeInterval *NSEC_PER_SEC), 0);
    // 设置回调
    __weak __typeof(target) weaktarget  = target;
    dispatch_source_set_event_handler(timer, ^{
        if (!weaktarget)  {
            dispatch_source_cancel(timer);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) handler(timer);
            });
        }
    });
    // 启动定时器
    dispatch_resume(timer);
}


@interface VHInteractiveTableViewCell ()<UITextFieldDelegate>
{
    int _left_time;
}
@property(nonatomic,strong) UILabel  *titleLabel;
@property(nonatomic,strong) UILabel  *statusLabel;
@property(nonatomic,strong) UIButton *statusBtn;
@property(nonatomic,strong) UIButton *statusBtn1;
@property(nonatomic,assign) NSInteger  status;
@end

@implementation VHInteractiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self= [ super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = MakeColor(0, 0, 0, 0.3);
        
        UIView  *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, [UIScreen mainScreen].bounds.size.height, 1)];
        line.backgroundColor=MakeColorRGB(0xf5f5f5);
        line.alpha=0.6;
        [self.contentView addSubview:line];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, self.contentView.height)];
        [titleLabel setFont:[UIFont systemFontOfSize:12]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:titleLabel];
        _titleLabel =titleLabel;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, self.contentView.height)];
        [label setFont:[UIFont systemFontOfSize:12]];
        [label setTextColor:MakeColor(200, 200, 200, 1)];
        [self.contentView addSubview:label];
        _statusLabel =label;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 0.5;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 50, self.contentView.height)];
        [self.contentView addSubview:btn];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _statusBtn = btn;
        
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 60, self.contentView.height)];
        [self.contentView addSubview:btn1];
        [btn1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _statusBtn1 = btn1;
        _statusBtn1.titleLabel.adjustsFontSizeToFitWidth = YES;
        _statusBtn1.titleLabel.minimumScaleFactor = 0.5;
    }
    return self;
}

+(instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style
{
    static   NSString *ID = @"Interactivecell";
    VHInteractiveTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell= [[VHInteractiveTableViewCell alloc] initWithStyle:style reuseIdentifier:ID];
    }
    return cell;
}

+(instancetype)cellWithTableView:(UITableView*)tableView
{
    return [VHInteractiveTableViewCell cellWithTableView:tableView style:UITableViewCellStyleValue1];
}

- (void)setItem:(NSDictionary *)item
{
    _item = item;
    
    _titleLabel.text = _item[@"third_party_user_id"];
    _status   = [_item[@"status"] integerValue]; // 用户状态 1 推流中 2 观看中 3 受邀中  4 申请上麦中
    
    _statusBtn.hidden  = [DEMO_Setting.third_party_user_id isEqualToString:_titleLabel.text];
    _statusBtn1.hidden = [DEMO_Setting.third_party_user_id isEqualToString:_titleLabel.text];
    _statusLabel.width = _statusBtn.hidden?100:50;
    
    [_statusBtn setTitle:@"踢出" forState:0];
    _statusBtn.tag = 0;
    _statusBtn1.tag = 1;
    switch (_status) {
        case 1:{
            _statusLabel.text = @"已上麦";
            [_statusBtn1 setTitle:@"下麦" forState:0];
        }
            break;
        case 2:{
            _statusLabel.text = @"未上麦";
            [_statusBtn1 setTitle:@"邀请" forState:0];
        }
            break;
        case 3:{
            _left_time = [_item[@"left_time"] intValue];
            _statusLabel.text = [NSString stringWithFormat:@"受邀中"];
//            _statusLabel.text = [NSString stringWithFormat:@"受邀中(%d)",_left_time];
            
//            __block int timeCount = _left_time;
//            __weak typeof(self) wf = self;
//            dispatchTimer(self, 1.0, ^(dispatch_source_t timer) {
//                NSRange r = [wf.statusLabel.text rangeOfString:@"受邀中"];
//                if (r.location == NSNotFound || timeCount < 0) {
//                    dispatch_source_cancel(timer);
//                    if(wf.action)
//                        wf.action(1,wf.item);
//                } else {
////                    NSLog(@"%d", timeCount);
//                    wf.statusLabel.text = [NSString stringWithFormat:@"受邀中(%d)",timeCount];
//                    timeCount -= 1;
//                }
//            });
            
            _statusBtn1.hidden = YES;
        }
            break;
        case 4:{
            _statusLabel.text = @"申请中";
            [_statusBtn1 setTitle:@"同意" forState:0];
            [_statusBtn setTitle:@"拒绝" forState:0];
        }
            break;
//        case 5:{
//            _statusLabel.text = @"被踢出";
//            _statusBtn1.hidden = YES;
//            [_statusBtn setTitle:@"恢复" forState:0];
//        }
//            break;
        default:
            _statusLabel.text = @"-";
            break;
    }
    
    if(_statusBtn.hidden)
        _statusLabel.text = [_statusLabel.text stringByAppendingString:@" (myself)"];
}

-(void)layoutSubviews
{
    _titleLabel.height = self.contentView.height;
    _statusLabel.height = self.contentView.height;
    _statusBtn.height = self.contentView.height;
    _statusBtn1.height = self.contentView.height;
    
    _statusLabel.left = self.contentView.width - _statusBtn.width - _statusBtn1.width -50;
    _statusBtn.right = self.contentView.width;
    _statusBtn1.right = self.contentView.width - _statusBtn.width;
}

- (void)btnClicked:(UIButton*)btn
{
    if(_action)
        _action(btn.tag,_item);
}

@end
