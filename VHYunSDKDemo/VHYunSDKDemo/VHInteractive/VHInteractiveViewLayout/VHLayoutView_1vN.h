//
//  VHLayoutView_1vN.h
//  VHYunSDKDemo
//  posID 示意图
//  ┌┅┅┅┅┅┬┅┅┅┬┅┅┅┬┅┅┅┅┅┅┅┅┐
//  ┆   1 ┆ 2 ┆ 3 ┆...     ┆ scrollView
//  ├┈┅┅┅┅┴┅┅┅┴┅┅┅┴┅┅┅┅┅┅┅┈┤
//  ┆                      ┆
//  ┆          0           ┆ 
//  ┆                      ┆
//  └┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┘
//  Created by vhall on 2018/5/23.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VHLayoutView.h"

@interface VHLayoutView_1vN : VHLayoutView
@property (nonatomic,strong)UIScrollView   *scrollView;

@end
