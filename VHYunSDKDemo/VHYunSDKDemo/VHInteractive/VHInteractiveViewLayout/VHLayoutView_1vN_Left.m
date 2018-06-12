//
//  VHLayoutView_1vN_Left.m
//  VHYunSDKDemo
//
//  Created by vhall on 2018/5/24.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import "VHLayoutView_1vN_Left.h"

@implementation VHLayoutView_1vN_Left

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }     */


#pragma mark - private
- (BOOL)updateUI
{
    if(![super updateUI])
        return NO;

    if(self.items.count>1)
    {
        BOOL isLandscape = self.width>self.height;
        
        float dot_h = self.scrollView.width* (isLandscape?3.0/4:4.0/3);
        float h = dot_h*(self.items.count-1);
        
        float startPos = 0;
        if(h<self.scrollView.height)
            startPos = (self.scrollView.height-h)/2;
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, (h<self.scrollView.height)?self.scrollView.height+1:h);
        
        for (int i = 1; i<self.items.count; i++) {
            VHLayoutItem* item = self.items[i];
            item.view.frame = CGRectMake(0, startPos+i*dot_h-dot_h, self.scrollView.width, dot_h);
            if(item.frameChangeItem)
                item.frameChangeItem(item);
            [self.scrollView addSubview:item.view];
        }
        
        CGRect rect =  CGRectMake(_scrollView.width, 0 , self.width-_scrollView.width, self.height);
        VHLayoutItem* item = self.items[0];
        item.view.frame = rect;
        if(item.frameChangeItem)
            item.frameChangeItem(item);
        [self insertSubview:item.view atIndex:0];
    }
    else if(self.items.count==1)
    {
        [_scrollView removeFromSuperview];
        self.scrollView = nil;
        
        VHLayoutItem* item = self.items[0];
        item.view.frame = CGRectMake(0,0 , self.width,self.height);
        if(item.frameChangeItem)
            item.frameChangeItem(item);
        [self insertSubview:item.view atIndex:0];
    }
    else
    {
        [_scrollView removeFromSuperview];
        self.scrollView = nil;
    }
    return YES;
}

#pragma mark - Set/Get
- (UIScrollView*)scrollView
{
    BOOL isLandscape = self.width>self.height;
    float w = isLandscape ? self.width/5 : self.width/4;
    if(!_scrollView)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, w, self.height)];
        _scrollView.backgroundColor = [UIColor blackColor];
        [self addSubview:_scrollView];
    }
    _scrollView.frame = CGRectMake(0, 0, w, self.height);
    return _scrollView;
}
@end
