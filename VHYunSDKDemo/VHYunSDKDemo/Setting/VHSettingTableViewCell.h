//
//  VHSettingTableViewCell.h
//  VHYunSDKDemo
//
//  Created by vhall on 2017/12/19.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//


#import <UIKit/UIKit.h>

@class VHSettingItem;
typedef void(^newInputText)(NSString *text);
typedef void(^changePosition)(UITextField *textField);
@interface VHSettingTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView*)tableView;
+(instancetype)cellWithTableView:(UITableView*)tableView style:(UITableViewCellStyle)style;
@property(nonatomic,strong) VHSettingItem  *item;
@property(nonatomic,strong) newInputText    inputText;
@property(nonatomic,strong) changePosition  changePosition;
@property (nonatomic,strong) UITextField *textField;
@end
