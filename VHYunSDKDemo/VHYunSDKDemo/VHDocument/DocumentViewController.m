//
//  DocumentViewController.m
//  VHYunSDKDemo
//
//  Created by vhall on 2017/12/14.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import "DocumentViewController.h"
#import "VHDocument.h"

@interface DocumentViewController ()<UIScrollViewDelegate>
{
    BOOL isFirstLayout;
}

@property(nonatomic,strong)VHDocument * document;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *docIDTextField;


@end

@implementation DocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}
- (void)viewDidLayoutSubviews
{
    if(!isFirstLayout)
    {
        isFirstLayout = YES;
        _document.view.frame    = _scrollView.bounds;
        _scrollView.contentSize = CGSizeMake(_document.view.width+1, _document.view.height+1);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    NSLog(@"%@: dealloc",[self class]);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)nextPage:(UIStepper *)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if(_docIDTextField.text.length > 0)
    {
        [_scrollView setZoomScale:1.0 animated:NO];
        NSString *page = [NSString stringWithFormat:@"%d",(int)sender.value];
        [_document nextPage:_docIDTextField.text pageID:page accessToken:self.accessToken];
    }
}


- (void)initView
{
    _document = [[VHDocument alloc]initWithChannelID:self.channelID accessToken:self.accessToken];
//    _document.delegate = self;
    _document.view.frame = _scrollView.bounds;
    _document.view.backgroundColor = MakeColorRGB(0xE2E8EB);
    [_scrollView addSubview:_document.view];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(_scrollView.width+1, _scrollView.height+1);
    
    _docIDTextField.text = DEMO_CustomDocID;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _document.view;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
// called before the scroll view begins zooming its content缩放开始的时候调用
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view NS_AVAILABLE_IOS(3_2){
//    NSLog(@"%s",__func__);
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
// scale between minimum and maximum. called after any 'bounce' animations缩放完毕的时候调用。
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    //把当前的缩放比例设进ZoomScale，以便下次缩放时实在现有的比例的基础上
//    NSLog(@"scale is %f",scale);
    [_scrollView setZoomScale:scale animated:NO];
    if(scale <= 1.0)
        _scrollView.contentSize = CGSizeMake(_scrollView.width+1, _scrollView.height+1);
}
// 缩放时调用 可以实时监测缩放比例
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    NSLog(@"......scale is %f",scrollView.zoomScale);
}
@end
