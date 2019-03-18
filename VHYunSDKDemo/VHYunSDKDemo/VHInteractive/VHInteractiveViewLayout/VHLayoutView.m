//
//  VHLayoutView.m
//  VHYunSDKDemo
//
//  Created by vhall on 2018/5/23.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import "VHLayoutView.h"

@interface VHLayoutView ()
{
    NSMutableArray *_items;
}
@end

@implementation VHLayoutView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        _items = [NSMutableArray array];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _items = [NSMutableArray array];
}


- (VHLayoutItem*)addRenderView:(UIView *)view
                    attributes:(id) attributes
                  clickedBlock:(ClickedItemBlock) block
{
    return [self addRenderView:view posID:_items.count attributes:attributes clickedBlock:block];
}

- (VHLayoutItem*)addRenderView:(UIView *)view
                    attributes:(id) attributes
                  clickedBlock:(ClickedItemBlock) block
              frameChangeBlock:(FrameChangeBlock) frameChangeBlock
{
    return [self addRenderView:view posID:_items.count attributes:attributes clickedBlock:block frameChangeBlock:frameChangeBlock];
}

- (VHLayoutItem*)addRenderView:(UIView *)view
                         posID:(NSInteger)posID
                    attributes:(id) attributes
                  clickedBlock:(ClickedItemBlock) block
{
    return [self addRenderView:view posID:posID attributes:attributes clickedBlock:block frameChangeBlock:nil];
}

- (VHLayoutItem*)addRenderView:(UIView *)view
                         posID:(NSInteger)posID
                    attributes:(id) attributes
                  clickedBlock:(ClickedItemBlock) block
              frameChangeBlock:(FrameChangeBlock) frameChangeBlock;
{
    if(!view)
        return nil;
    
    VHLayoutItem* item = nil;
    for (VHLayoutItem* i in _items) {
        if([i.view isEqual:view])
        {
            item = i;
            break;
        }
    }
    if(!item)
    {
        if(posID>_items.count)
            posID=_items.count;
        
        item = [[VHLayoutItem alloc]init];
        item.posId      = posID;
        [_items insertObject:item atIndex:posID];
        
        for (NSInteger i = posID+1; i<_items.count; i++) {
            VHLayoutItem* itemT = _items[i];
            itemT.posId = i;
        }
    }
    item.clickedItem    = block;
    item.frameChangeItem = frameChangeBlock;
    item.view           = view;
    item.attributes     = attributes;
     
    [self updateUI];
    return item;
}

- (void)removeRenderView:(UIView *)view
{
    for (NSInteger i = 0; i<_items.count; i++) {
        VHLayoutItem* item = _items[i];
        if([item.view isEqual:view])
        {
            [_items removeObject:item];
            dispatch_async(dispatch_get_main_queue(), ^{
                [item.view removeFromSuperview];
            });
            i--;
            continue;
        }
        item.posId = i;
    }
    [self updateUI];
}
- (void)removeAllViews
{
    for (VHLayoutItem* item in _items) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [item.view removeFromSuperview];
        });
    }

    [_items removeAllObjects];
    [self updateUI];
}


- (void)changePosWithItem:(VHLayoutItem*) item room:(VHInteractiveRoom*)room
{
    if (item.posId !=0)
    {
        VHLayoutItem *items0 = _items[0];
        
        NSInteger posID = item.posId;
        item.posId = items0.posId;
        items0.posId = posID;
        
        [_items removeObject:item];
        [_items removeObject:items0];
        
        [_items insertObject:item atIndex:0];
        [_items insertObject:items0 atIndex:items0.posId];
        
        //大小流切换
        if(!((VHRenderView*)item.view).isLocal && ((VHRenderView*)item.view).simulcastLayers > 1)//大窗口
        {
            [room switchDualStream:((VHRenderView*)item.view).streamId type:1 finish:^(int code, NSString * _Nullable message) {
            }];
        }
        if(!((VHRenderView*)items0.view).isLocal && ((VHRenderView*)items0.view).simulcastLayers > 1)//小窗口
        {
            [room switchDualStream:((VHRenderView*)items0.view).streamId type:0 finish:^(int code, NSString * _Nullable message) {
            }];
        }
        
        [self updateUI];
    }
} ;

- (void)changePosWithView:(UIView *)view room:(VHInteractiveRoom*)room
{
    VHLayoutItem* item = nil;
    for (VHLayoutItem* i in _items) {
        if([i.view isEqual:view])
        {
            item = i;
            break;
        }
    }
    [self changePosWithItem:item room:room];
}

- (void)muteVideo:(BOOL)isMute view:(UIView *)view
{
    VHLayoutItem* item = nil;
    for (VHLayoutItem* i in _items) {
        if([i.view isEqual:view])
        {
            item = i;
            break;
        }
    }
    
    [item userMuteVideo:isMute];
}
#pragma mark - private
- (BOOL)updateUI
{
    return !_isLimitUpdateUI;
        
}
#pragma mark - Set/Get
- (void)setIsLimitUpdateUI:(BOOL)isLimitUpdateUI
{
    _isLimitUpdateUI = isLimitUpdateUI;
    [self updateUI];
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updateUI];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateUI];
}

- (void)setItems:(NSArray *)items
{
    [_items removeAllObjects];
    [_items addObjectsFromArray:items];
    [self updateUI];
}

- (NSArray*)items
{
    return _items;
}
@end
