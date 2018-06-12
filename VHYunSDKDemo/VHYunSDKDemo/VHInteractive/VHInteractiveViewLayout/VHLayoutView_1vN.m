//
//  VHLayoutView_1vN.m
//  VHYunSDKDemo
//
//  Created by vhall on 2018/5/23.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import "VHLayoutView_1vN.h"

@implementation VHLayoutView_1vN
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)dealloc
{
//    NSLog(@"dealloc: %@",[self class]);
}
#pragma mark - private
- (BOOL)updateUI
{
    if(![super updateUI])
        return NO;
    
    if(self.items.count>1)
    {
        BOOL isLandscape = self.width>self.height;
        
        float dot_w = self.scrollView.height* (isLandscape?4.0/3:3.0/4);
        float w = dot_w*(self.items.count-1);
        
        float startPos = 0;
        if(w<self.scrollView.width)
            startPos = (self.scrollView.width-w)/2;
        
        self.scrollView.contentSize = CGSizeMake((w<self.scrollView.width)?self.scrollView.width+1:w, self.scrollView.height);
        
        for (int i = 1; i<self.items.count; i++) {
            VHLayoutItem* item = self.items[i];
            item.view.frame = CGRectMake(startPos+i*dot_w-dot_w, 0, dot_w, self.scrollView.height);
            if(item.frameChangeItem)
                item.frameChangeItem(item);
            [self.scrollView addSubview:item.view];
        }
        
        CGRect rect = CGRectMake(0, _scrollView.height, self.width, self.height-_scrollView.height);
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
    float h = isLandscape ? self.height/4 : self.height/5;
    if(!_scrollView)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, h)];
        _scrollView.backgroundColor = [UIColor blackColor];
        [self addSubview:_scrollView];
    }
    _scrollView.frame = CGRectMake(0, 0, self.width, h);
    return _scrollView;
}

@end
