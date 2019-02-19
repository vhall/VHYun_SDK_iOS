//
//  VHDocumentViewWK.h
//  VHDocumentViewWK
//
//  Created by vhall on 2018/6/23.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,VHDocumentViewType) {
    VHDocumentViewType_PPT          = 1 ,   //文档模式
    VHDocumentViewType_WhiteBoard   = 2 ,   //白板模式 此版本暂不支持
};

typedef NS_ENUM(NSInteger,VHDrawAction) {
    VHDrawAction_Add          = 1 ,   //添加画板元素 设置 VHDrawType 时会自动设置为此选项
    VHDrawAction_Modify       = 2 ,   //选择后修改 画板元素
    VHDrawAction_Delete       = 3 ,   //删除画板元素
};


typedef NS_ENUM(NSInteger,VHDrawType) {
    VHDrawType_Pen          = 1 ,   //画笔
    VHDrawType_Highlighter  = 2 ,   //荧光笔
    VHDrawType_Rectangle    = 3 ,   //矩形
    VHDrawType_Circle       = 4 ,   //圆
    VHDrawType_Arrow        = 5 ,   //箭头 此版本暂不支持
    VHDrawType_Text         = 6 ,   //文字 此版本暂不支持
    VHDrawType_Image        = 7 ,   //图片 此版本暂不支持
};

@protocol VHDocumentViewDelegate;
@class VHDocumentConfig;
@interface VHDocumentView : UIView
+ (NSString*)getDocumentViewVersion;

/*
 * 接收消息并在涂鸦画板处理
 */
- (void)setDocumentMsg:(id)msg;

/*
 * 代理 editEnable 为YES 时有效
 */
@property (nonatomic,weak)id <VHDocumentViewDelegate>  delegate;
/*
 * 文档播发器准备完成
 */
@property (nonatomic,assign,readonly)BOOL   isLoad;//load完


#pragma mark - edit Option
/*
 * 是否可以编辑 作为发起端 默认NO 不可编辑
 */
@property (nonatomic,assign)BOOL    editEnable;

#pragma mark - PPT
/*
 * 文档hash
 */
@property (nonatomic,strong)NSString*    doc_hash;
/*
 * 总页数
 */
@property (nonatomic,assign)int    totalPage;
/*
 * 总步数
 */
@property (nonatomic,assign)int    totalStep;
/*
 * 当前页
 */
@property (nonatomic,assign)int    currentPage;
/*
 * 当前步
 */
@property (nonatomic,assign)int    currentStep;

/*
 * 跳转至第几页
 */
- (void)gotoPage:(int) page;
/*
 * 跳转至第几页的第几步
 */
- (void)gotoPage:(int) page step:(int)step;
/*
 * 上一页
 */
- (void)prevPage;
/*
 * 下一页
 */
- (void)nextPage;
/*
 * 上一步
 */
- (void)prevStep;
/*
 * 下一步
 */
- (void)nextStep;


#pragma mark - Graffit
/*
 * 是否开启涂鸦模式
 */
@property (nonatomic,assign)BOOL    editGraffitEnable;
/*
 * 绘制命令类型
 */
@property (nonatomic,assign)VHDrawAction  drawAction;

/*
 * 绘制类型
 * 注意：设置此参数时  editType 自动设置为 VHEditType_Add 模式
 */
@property (nonatomic,assign)VHDrawType  drawType;


/*
 * 设置颜色、大小
 */
- (void)setColor:(UIColor*)color;

/*
 * 大小
 */
- (void)setSize:(NSInteger)size;

/*
 * 清空
 */
- (void)clear;


// 以下方法 此版本暂不支持
/*
 * 添加图片
 */
- (void)addImage:(NSString*)image;

/*
 * 撤销
 */
- (void)undo;

/*
 * 重做
 */
- (void)redo;


/*
 * 初始化
 * @param frame  显示区域大小
 * @param type   文档类型

 */
- (instancetype)initWithFrame:(CGRect)frame type:(VHDocumentViewType)type graffitiUrl:(NSString*)graffitiUrl;

/*
 * 配置文档显示区域 注意要在- (void)documentView:(VHDocumentView *)documentView load:(BOOL)isLoad; 事件中设置
 * @param config 文档参数
 */
- (void)setDocParamWithConfig:(VHDocumentConfig*)config;

/*
 * resize 重置容器大小
 */
- (void)resize;
/*
 * 设置当前文档
 * hash 文档hash
 * extData jsonstr @"{\"height\":540,\"show_page\":\"2\",\"ext\":\"pptx\",\"width\":960,\"show_step\":0,\"page\":22,\"docId\":\"ac116232\",\"hash\":\"eb21f459f9a0661e4b54ea283be632bc\"}"
 */
- (void)setDocByHash:(NSString*) hash extData:(NSString*)extData;

@end


/*
 * 事件回调
 */
@protocol VHDocumentViewDelegate <NSObject>

@optional
/*
 *  init完成
 */
- (void)documentView:(VHDocumentView *)documentView load:(BOOL)isLoad;

/*
 * 事件回调可以通过网络发送给服务器
 */
- (void)documentView:(VHDocumentView *)documentView msg:(NSString*)msg;

/*
 * 翻页事件
 */
- (void)documentView:(VHDocumentView *)documentView flipOver:(BOOL)isFlipOver;

/*
 * 错误
 */
- (void)documentView:(VHDocumentView *)documentView error:(NSError*)error;

@end
