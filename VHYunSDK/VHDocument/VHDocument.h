//
//  VHDocument.h
//  VHDocument
//
//  Created by vhall on 2017/12/12.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHDocumentView.h"

@protocol VHDocumentDelegate;

@interface VHDocument : NSObject
@property (nonatomic,weak)id <VHDocumentDelegate>      delegate;

/**
 * 文档显示view
 */
@property (nonatomic,strong,readonly)VHDocumentView *view;

/**
 * 当前显示DocumentID
 */
@property (nonatomic,strong,readonly)NSString* curDocumentID;

/**
 * 文档模块初始化
 */
- (instancetype)initWithChannelID:(NSString*)channelID accessToken:(NSString*)accessToken;

/**
 * 直播+文档模块初始化 生成roomID的回放时会 绑定演示的文档
 * roomID 绑定到直播间
 */
- (instancetype)initWithChannelID:(NSString*)channelID roomID:(NSString*)roomID accessToken:(NSString*)accessToken;

/**
 * 直播+文档模块初始化 生成roomID的回放时会 绑定演示的文档
 * roomID 绑定到直播间
 * isLoadLastDoc 是否加载上次演示的文档及调到对应页码，一般用于主播演示端不显示上次演示内容 设置后需先设置文档再演示
 */
- (instancetype)initWithChannelID:(NSString*)channelID roomID:(NSString*)roomID accessToken:(NSString*)accessToken loadLastDoc:(BOOL)isLoadLastDoc;

/**
 * 点播文档模块初始化
 */
- (instancetype)initWithRecordID:(NSString*)recordID;

/**
 * 点播文档模块初始化
 * channelID 有点播模块回调数据
 */
- (instancetype)initWithRecordID:(NSString*)recordID channelID:(NSString*)channelID;

/**
 * 设置要演示的文档
 * @param documentID 文档id
 */
- (void)setDocWithID:(NSString*) documentID;

/**
 * 设置要演示的文档
 * @param documentID 文档id
 */
- (void)setDocWithID:(NSString*) documentID success:(void(^)(void))success failed:(void(^)(NSError *error))failedBlock;


- (void)destroyDocument;

/**
 *  获得当前SDK版本号
 */
+ (NSString *) getSDKVersion;
@end

@protocol VHDocumentDelegate <NSObject>

@optional
/*
 *  documentView Load完成 完成后
 */
- (void)documentViewDidLoad;

/**
 *  直播文档同步
 *  @param document 文档实例
 *  @param channelID   文档channelID
 *  @return float   延迟执行时间 即直播延迟时间 realityBufferTime
 */
- (float)document:(VHDocument *)document delayChannelID:(NSString*)channelID;

/**
 *  翻页消息
 *  @param document 文档实例
 *  @param documentID   文档id 为空时没有 文档
 *  @param curPage  当前页码 0开始
 */
- (void)document:(VHDocument *)document documentID:(NSString*) documentID curPage:(int)curPage;

/**
 *  错误回调
 *  @param document 文档实例
 *  @param error    错误
 */
- (void)document:(VHDocument *)document error:(NSError *)error;

@end
