//
//  DocUploadViewController.m
//  VHYunSDKDemo
//
//  Created by vhall on 2019/4/24.
//  Copyright © 2019 www.vhall.com. All rights reserved.
//

#import "DocUploadViewController.h"
#import <Photos/Photos.h>
#import "MBProgressHUD.h"
#import <VHDoc/VHDocUpload.h>

@interface DocUploadViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIDocumentPickerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet UITextField *fileNameInput;

@end

@implementation DocUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"%@",[VHDocUpload getUploadConfig]);
    
    self.infoTextView.editable = NO;
}

- (void)dealloc {
    
}

- (IBAction)dismissBtnClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//iCloud上传
- (IBAction)iCloudBtnClick:(UIButton *)sender {
    if (![DocUploadViewController ICloudEnable]) {
        NSLog(@"iCloud没有开启");
        return;
    }
    NSArray *documentTypes = @[@"public.content",
                               @"public.text",
                               @"public.source-code",
                               @"public.image",
                               @"public.jpeg",
                               @"public.png",
                               @"com.adobe.pdf",
                               @"com.apple.keynote.key",
                               @"com.microsoft.word.doc",
                               @"com.microsoft.excel.xls",
                               @"com.microsoft.powerpoint.ppt"];
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeOpen];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}
//相册上传
- (IBAction)photoABtnClick:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //如果需要编辑图片，建议sourceType选择UIImagePickerControllerSourceTypeSavedPhotosAlbum，如果不需要，可选择UIImagePickerControllerSourceTypePhotoLibrary。
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}
//拍照上传
- (IBAction)cameraBtnClick:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UIImagePickerControllerDelegate
//selected
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //此处需要先dismiss掉picker，然后再present出alert，佛否则alert显示会出bug
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //获取经过编辑后的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) {
        //如果未编辑，取原图
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum)
    {
        NSURL *url = nil;
        if (@available(iOS 11.0, *)) {
            url = info[UIImagePickerControllerImageURL];
        } else {
            url = info[UIImagePickerControllerReferenceURL];
        }
        [self selectedImage:image url:url reName:nil];
    }
    else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        __block NSString *locolId = nil;
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //保存到相册
            PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            locolId = request.placeholderForCreatedAsset.localIdentifier;
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (error == nil) {
                //获取图片信息
                PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[locolId] options:nil];
                PHAsset *asset = [result firstObject];
                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                    
                    NSURL *url = info[@"PHImageFileURLKey"];
                    [self selectedImage:image url:url reName:nil];
                }];
            }
            else {
                NSLog(@"图片保存失败!");
            }
        }];
    }
}
//cancel
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIDocumentPickerDelegate
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray <NSURL *>*)urls
{
    [self selectedDocumentAtURLs:urls reName:nil];
}
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    [self selectedDocumentAtURLs:@[url] reName:nil];
}

#pragma mark - private
+ (BOOL)ICloudEnable {
    NSURL *url = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    return url != nil;
}
//相册/拍照文件上传
- (void)selectedImage:(UIImage *)image url:(NSURL *)url reName:(NSString *)name
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否上传此文档？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    __block NSString *fileRename = name;
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (self.fileNameInput.text) {
            fileRename = self.fileNameInput.text;
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"努力上传中...";
        UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        progressView.progressTintColor = [UIColor redColor];
        progressView.trackTintColor = [UIColor whiteColor];
        hud.customView = progressView;
        
        [VHDocUpload uploadImage:image referenceURL:url reName:fileRename accessToken:self.accessToken progress:^(NSProgress * _Nonnull progress) {
            hud.progress  = progress.completedUnitCount * 1.0 / progress.totalUnitCount;
            NSLog(@"progress:%f",hud.progress);
        } sucess:^(NSDictionary * _Nonnull responseObject) {
            NSLog(@"responseObject:%@",responseObject);
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [self printResponse:responseObject];
        } failure:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            NSLog(@"上传失败！%@",error);
            [self printError:error];
            [self showMsg:@"上传失败！" afterDelay:2];
        }];
        
        self.fileNameInput.text = nil;

    }];
    [alert addAction:cancel];
    [alert addAction:action];
    [self presentViewController:alert animated:NO completion:nil];
}
//iCloud文件上传
- (void)selectedDocumentAtURLs:(NSArray <NSURL *>*)urls reName:(NSString *)rename
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否上传此文档？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    __block NSString *fileRename = rename;
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (self.fileNameInput.text) {
            fileRename = self.fileNameInput.text;
        }
        
        for (NSURL *url in urls) {
            NSString *fileName = [url lastPathComponent];
            NSLog(@"==>fileName：%@",fileName);
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"努力上传中...";
            UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
            progressView.progressTintColor = [UIColor redColor];
            progressView.trackTintColor = [UIColor whiteColor];
            hud.customView = progressView;
            
            [VHDocUpload uploadICloudFileWithUrl:url fileRename:fileRename accessToken:self.accessToken progress:^(NSProgress * _Nonnull progress) {
                hud.progress  = progress.completedUnitCount / (1.0 * progress.totalUnitCount);
                NSLog(@"progress:%f",hud.progress);
            } sucess:^(NSDictionary * _Nonnull responseObject) {
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                [self showMsg:@"上传成功！" afterDelay:2];
                [self printResponse:responseObject];
            } failure:^(NSError * _Nonnull error) {
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                NSLog(@"上传失败！%@",error);
                [self printError:error];
                [self showMsg:@"上传失败！" afterDelay:2];
            }];
        }
        
        self.fileNameInput.text = nil;
    }];
    [alert addAction:cancel];
    [alert addAction:action];
    [self presentViewController:alert animated:NO completion:nil];
}

- (void)printResponse:(NSDictionary *)response {
    self.infoTextView.text = nil;
    for (NSString *key in response) {
        NSString *info = [NSString stringWithFormat:@"%@：%@ \n",key,response[key]];
        self.infoTextView.text = [self.infoTextView.text stringByAppendingString:info];
    }
    //复制到剪贴板
    UIPasteboard *pd = [UIPasteboard generalPasteboard];
    [pd setString:response[@"data"][@"document_id"]];
}
- (void)printError:(NSError *)error {
    self.infoTextView.text = [NSString stringWithFormat:@"%@",error];
}

@end
