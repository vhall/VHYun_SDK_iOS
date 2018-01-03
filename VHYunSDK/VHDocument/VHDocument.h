//
//  VHDocument.h
//  VHDocument
//
//  Created by vhall on 2017/12/12.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VHDocumentDelegate;

@interface VHDocument : NSObject
@property (nonatomic,weak)id <VHDocumentDelegate>      delegate;
/**
 * 文档显示view
 */
@property (nonatomic,strong,readonly)UIView             *view;

/**
 * 是否显示Indicator  默认 YES 加载ppt时显示loading 如果失败则提示下载错误
 */
@property (nonatomic,assign)BOOL showIndicator;

/**
 * 点播文档模块初始化
 */
- (instancetype)initWithRecordID:(NSString*)recordID;

/**
 * 文档模块初始化
 */
- (instancetype)initWithChannelID:(NSString*)channelID accessToken:(NSString*)accessToken;

/**
 * 高级功能
 * 自定义翻页接口
 * return NO 基础模块未初始化
 */
- (BOOL)nextPage:(NSString*)documentID pageID:(NSString*)pageID;

@end

@protocol VHDocumentDelegate <NSObject>

@optional
/**
 *  错误回调
 *  @param document 文档实例
 *  @param error    错误
 */
- (void)document:(VHDocument *)document error:(NSError *)error;

@end
