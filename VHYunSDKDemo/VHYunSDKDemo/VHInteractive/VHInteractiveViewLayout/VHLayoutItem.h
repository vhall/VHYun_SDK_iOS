//
//  VHLayoutItem.h
//  VHYunSDKDemo
//
//  Created by vhall on 2018/5/23.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VHLayoutItem;
/*
 * 流状态监听回调block定义
 */
typedef void(^ClickedItemBlock)(VHLayoutItem* _Nonnull item);
typedef void(^FrameChangeBlock)(VHLayoutItem* _Nonnull item);

@interface VHLayoutItem : NSObject
@property (nonatomic,assign)NSInteger posId;//位置编号
@property (nonatomic,weak)UIView *view;
@property (nonatomic,strong)id attributes;
@property (nonatomic,copy)ClickedItemBlock clickedItem;
@property (nonatomic,copy)FrameChangeBlock frameChangeItem;

@end
