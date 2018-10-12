//
//  VHGraffitiViewController.m
//  VHYunSDKDemo
//
//  Created by vhall on 2018/6/19.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import "VHGraffitiViewController.h"
#import "VHGraffiti.h"
#import "UIImageView+WebCache.h"

#define OBJ_Color @[@"#FF0000",@"#FF7D00",@"#FFFF00",@"#00FF00",@"#0000FF",@"#00FFFF",@"#FF00FF"]

@interface VHGraffitiViewController ()<VHGraffitiBoardViewDelegate>
{
    UIColor   *_color;
    NSInteger _size;
}
@property (strong, nonatomic) VHGraffiti *graffitiView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView  *ctrlView;
@property (weak, nonatomic) IBOutlet UILabel *lineSizeLabel;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@end

@implementation VHGraffitiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _graffitiView = [[VHGraffiti alloc]initWithFrame:_scrollView.bounds channelID:_channelID];
    _graffitiView.delegate   = self;
    _graffitiView.editEnable = YES;
    [_scrollView addSubview:_graffitiView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    _graffitiView.frame = _scrollView.bounds;
}
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnClicked:(UIButton*)sender {
    for (int i = 1; i <= 10; i++) {
        UIButton*v = [_ctrlView viewWithTag:i];
        if([v isKindOfClass:[UIButton class]])
        {
            v.selected = NO;
        }
    }
    
    sender.selected = NO;
    switch (sender.tag) {
        case VHDrawType_Pen:
        case VHDrawType_Highlighter:
        case VHDrawType_Rectangle:
        case VHDrawType_Circle:
        case VHDrawType_Arrow:
        case VHDrawType_Text:
        {
            sender.selected = YES;
            _graffitiView.drawType = sender.tag;
        }
            break;
        case VHDrawType_Image:
        {
            if(_urlTextField.text.length>0)
            {
                sender.selected = YES;
                [_graffitiView addImage:_urlTextField.text];
            }
        }
            break;
        case 10://选择修改模式
        {
            sender.selected = YES;
            _graffitiView.editType = VHEditType_Modify;
        }
            break;
        case 11:_graffitiView.editType = VHEditType_Delete; break;//Del
        case 12:[_graffitiView clear];break;//DelAll
        case 13:[_graffitiView undo];break;//Undo
        case 14:[_graffitiView redo];break;//Redo
        default:break;
    }
}


- (IBAction)sliderValueChanged:(UISlider *)sender {
    switch (sender.tag) {
        case 90:
        {
            _size = sender.value;
            [_graffitiView setColor:_color size:_size];
            _lineSizeLabel.text = [NSString stringWithFormat:@"线/字大小:%d",(int)_size];
        }
            break;
        default:
            break;
    }
}
- (IBAction)colorValueChanged:(UISegmentedControl *)sender {
    NSString *colorStr = OBJ_Color[sender.selectedSegmentIndex];
    _color = [VHGraffitiViewController CGColor:colorStr];
    [_graffitiView setColor:_color size:_size];
}

+ (UIColor*)CGColor:(NSString*)str
{
    NSRange r = [str rangeOfString:@"#"];
    if(r.location != NSNotFound)
        str = [str stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
    
    r = [str rangeOfString:@"0x"];
    if(r.location == NSNotFound)
        return [UIColor clearColor];
    
    unsigned long c = strtoul([str UTF8String],0,16);
    return [UIColor colorWithRed: ((c>>16)&0xFF) / 255.0  green: ((c>>8)&0xFF) / 255.0  blue: (c&0xFF) / 255.0  alpha: 1 ];
}

@end
