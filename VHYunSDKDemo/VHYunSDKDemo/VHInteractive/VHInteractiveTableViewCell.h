//
//  VHSettingTableViewCell.h
//  VHYunSDKDemo
//
//  Created by vhall on 2017/12/19.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//


#import <UIKit/UIKit.h>
//type 0 踢出，1 下麦， 2 邀请， 3 取消邀请 4 申请中 同意
typedef void(^actionBlock)(NSInteger type,NSDictionary* item);

@interface VHInteractiveTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView*)tableView;
+(instancetype)cellWithTableView:(UITableView*)tableView style:(UITableViewCellStyle)style;

@property(nonatomic,strong) actionBlock  action;
@property (nonatomic,copy)NSDictionary *item;
@end
