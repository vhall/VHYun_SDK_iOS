//
//  VHLayoutView.h
//  VHYunSDKDemo
//
//  Created by vhall on 2018/5/23.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VHLayoutItem.h"
#import <VHRTC/VHInteractiveRoom.h>

@interface VHLayoutView : UIView

/*
 * 所有展示的 VHLayoutItem 列表
 */
@property (nonatomic,strong)NSArray *items;

/*
 * 添加 view 到布局中 并创建 VHLayoutItem 放入items列表
 * @param view       要添加的 view 默认放到队列末尾
 * @param attributes 对应的属性
 * @param block      手势点击事件，设置为nil不添加手势
 */
- (VHLayoutItem*)addRenderView:(UIView *)view
                    attributes:(id) attributes
                  clickedBlock:(ClickedItemBlock) block;

- (VHLayoutItem*)addRenderView:(UIView *)view
                    attributes:(id) attributes
                  clickedBlock:(ClickedItemBlock) block
                  frameChangeBlock:(FrameChangeBlock) frameChangeBlock;

/*
 * 添加 view 到布局对应位置 并创建 VHLayoutItem 放入items列表
 * @param view       要添加的 view 默认放到队列末尾
 * @param posID      view 放置位置编号
 * @param attributes 对应的属性
 * @param block      手势点击事件，设置为nil不添加手势
 */
- (VHLayoutItem*)addRenderView:(UIView *)view
                         posID:(NSInteger)posID
                    attributes:(id) attributes
                  clickedBlock:(ClickedItemBlock) block;

- (VHLayoutItem*)addRenderView:(UIView *)view
                         posID:(NSInteger)posID
                    attributes:(id) attributes
                  clickedBlock:(ClickedItemBlock) block
              frameChangeBlock:(FrameChangeBlock) frameChangeBlock;

/*
 * 删除 view 对应 item
 * @param view 删除 view
 */
- (void)removeRenderView:(UIView *)view;

/*
 * 删除 所有Views对应的 items
 */
- (void)removeAllViews;

/*
 * 把item 切换到 0 号位
 * @param item 要切换到0号位的item
 * @param room 用于切换大小流
 */
- (void)changePosWithItem:(VHLayoutItem*) item room:(VHInteractiveRoom*)room;

/*
 * 把item 切换到 0 号位
 * @param view 要切换到0号位的 view
 * @param room 用于切换大小流
 */
- (void)changePosWithView:(UIView *)view room:(VHInteractiveRoom*)room;

/*
 * 限制刷新
 */
@property (assign,nonatomic) BOOL isLimitUpdateUI;

/*
 * 手动关闭开启别人视频
 */
- (void)muteVideo:(BOOL)isMute view:(UIView *)view;

//内部自动触发不需要调用 返回 NO 则不刷新UI
- (BOOL)updateUI;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;
@end
