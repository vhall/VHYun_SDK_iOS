//
//  CustomPickerView.h
//  VHYunSDKDemo
//
//  Created by vhall on 2017/12/19.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//


#import "ITTXibView.h"

@class CustomPickerView;
@protocol CustomPickerViewDelegate <NSObject>

- (void)pickerView:(CustomPickerView *)pickerView didSelectRow:(NSInteger)row;

@end

@protocol CustomPickerViewDataSource <NSObject>

- (NSString*)pickerView:(CustomPickerView *)pickerView titleWithRow:(NSInteger)row;
- (NSInteger)pickerView:(CustomPickerView *)pickerView numberOfRows:(NSInteger)row;

@end

@interface CustomPickerView : ITTXibView
{
    
}

@property(assign,nonatomic)id <CustomPickerViewDelegate>delegate;
@property(assign,nonatomic)id <CustomPickerViewDataSource> dataSource;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,assign,readonly)BOOL isShow;

-(void)showPickerView:(UIView*)superView;
-(void)hidePickerView;

@end
