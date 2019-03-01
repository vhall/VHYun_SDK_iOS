//
//  VHLayoutView_1vN_Pip_Left.m
//  VHYunSDKDemo
//
//  Created by vhall on 2018/5/23.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import "VHLayoutView_1vN_Pip_Left.h"
@interface VHLayoutView_1vN_Pip_Left()<UIScrollViewDelegate>
@end


@implementation VHLayoutView_1vN_Pip_Left

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
    
    if(self.items.count>0)
    {
        if(self.items.count>1)
        {
            BOOL isLandscape = self.width>self.height;
            
            float dot_h = self.scrollView.width* (isLandscape?3.0/4:4.0/3);
            float h = dot_h*(self.items.count-1);
            
            float startPos = 0;
//            if(h<self.scrollView.height)
//                startPos = (self.scrollView.height-h)/2;
            
            self.scrollView.contentSize = CGSizeMake(self.scrollView.width, (h<self.scrollView.height)?self.scrollView.height+1:h );
            
            for (int i = 1; i<self.items.count; i++) {
                VHLayoutItem* itemT = self.items[i];
                itemT.view.frame = CGRectMake(0,startPos+i*dot_h-dot_h , self.scrollView.width,dot_h);
                if(itemT.frameChangeItem)
                    itemT.frameChangeItem(itemT);
                [self.scrollView addSubview:itemT.view];
            }
        }
        VHLayoutItem* item = self.items[0];
        item.view.frame = CGRectMake(0,0 , self.width,self.height);
        if(item.frameChangeItem)
            item.frameChangeItem(item);
        [self insertSubview:item.view atIndex:0];
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
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, w, self.height-120)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    _scrollView.frame = CGRectMake(0, 70, w, self.height-120);
    return _scrollView;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
        [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //超出范围的只播放音频
    BOOL isLandscape = self.width>self.height;
    float dot_h = self.scrollView.width* (isLandscape?3.0/4:4.0/3);
    
    float offsetY = self.scrollView.contentOffset.y;
    float offsetYMax = self.scrollView.contentOffset.y+self.scrollView.height;
    float startPos = 0;
    for (int i = 1; i<self.items.count; i++)
    {
        int y = startPos+i*dot_h;
        VHLayoutItem* itemT = self.items[i];
        if(offsetY >= y || offsetYMax <= (y-dot_h))
        {
            [((VHRenderView*)itemT.view) muteVideo];
        }
        else
        {
            [((VHRenderView*)itemT.view) unmuteVideo];
        }
    }
}

@end
