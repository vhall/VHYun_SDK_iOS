//
//  VHMessage.h
//  VHBasePlatform
//
//  Created by vhall on 2017/11/30.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VHMessage : NSObject

- (instancetype)initWithDic:(NSDictionary*)dic;

@property (nonatomic,copy) NSString *msg_id;    //消息ID
@property (nonatomic,copy) NSString *channel;   //频道ID
@property (nonatomic,copy) NSString *event;     //收消息事件
@property (nonatomic,strong) id     data;       //消息体
@property (nonatomic,copy) NSString *date_time; //消息发送的日期时间，例：2017-11-29 11:22:33

@property (nonatomic,copy) NSString *third_party_user_id;//第三方用户唯一标识
@property (nonatomic,copy) NSString *avatar;    //第三方用户头像地址，例：https://qlogo1.store.qq.com/qzone/237739452/237739452/100
@property (nonatomic,copy) NSString *nick_name;//第三方用户昵
@end
