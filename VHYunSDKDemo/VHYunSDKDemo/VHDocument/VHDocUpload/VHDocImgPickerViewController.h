//
//  VHDocImgPickerViewController.h
//  VHYunSDKDemo
//
//  Created by vhall on 2019/5/8.
//  Copyright © 2019 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHDocImgPickerViewController : UIViewController

- (instancetype)initWithDocumentTypes:(NSArray <NSString *>*)allowedUTIs inMode:(UIDocumentPickerMode)mode NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithImageSourceType:(UIImagePickerControllerSourceType)sourceType;

@end

NS_ASSUME_NONNULL_END
