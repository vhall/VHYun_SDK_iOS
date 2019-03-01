//
//  VHInteractiveViewController+TableView.m
//  VHYunSDKDemo
//
//  Created by vhall on 2018/5/9.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import "VHInteractiveViewController+TableView.h"
#import "VHInteractiveTableViewCell.h"

#import "VHInteractiveViewController+Room.h"

@implementation VHInteractiveViewController (TableView)

- (void)updateUserListData
{
    //只有用户列表显示的情况下才刷新数据
    if (self.tableView.hidden) {
        return;
    }
    __weak typeof(self) wf = self;
    [self inviteUserList:^(NSArray *userList,NSError* error) {
        if(userList)
        {
            wf.userList = userList;
            [wf.tableView reloadData];
        }
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    VHInteractiveTableViewCell *cell =[VHInteractiveTableViewCell  cellWithTableView:tableView];
    cell.item = self.userList[indexPath.row];
    
    __weak typeof(self) wf = self;
    cell.action = ^(NSInteger type, NSDictionary *item) {
        [wf action:type item:item];
    };
    return cell;
}

- (void)action:(NSInteger)type item:(NSDictionary*)item
{
    
    NSString* third_user_id = item[@"third_party_user_id"];
    int status              = [item[@"status"] intValue]; // 用户状态 1 推流中 2 观看中 3 受邀中 4 申请上麦中

    switch (status) {
        case 1://1 下麦
        {
            if(type == 1)
                [self kickoutStreamWithThirdUserId:third_user_id];
            else
                [self kickoutRoomWithThirdUserId:third_user_id];
        }
            break;
        case 2://2 邀请上麦
        {
            if(type == 1)
                [self invitePublishWithThirdUserId:third_user_id];
            else
                [self kickoutRoomWithThirdUserId:third_user_id];
        }
            break;
        case 3://3 受邀中
        {
            if(type == 1)
                [self updateUserListData];
            else
                [self kickoutRoomWithThirdUserId:third_user_id];
        }
            break;
        case 4://4 同意上麦 type == 1 同意   0拒绝
        {
            [self acceptPublishRequest: (type == 1) thirdUserId:third_user_id];
        }
            break;
//        case 5://5 允许踢出房间用户重新进入房间 恢复
//        {
//            [self kickoutRoom:NO thirdUserId:third_user_id];
//            [self performSelector:@selector(updateUserListData) withObject:nil afterDelay:1];
//        }
//            break;

        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
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

@end
