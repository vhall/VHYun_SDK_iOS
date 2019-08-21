//
//  CALayer+XibConfiguration.m
//  VhallIphone
//
//  Created by vhall on 15/9/8.
//  Copyright (c) 2015年 www.vhall.com. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)
-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
