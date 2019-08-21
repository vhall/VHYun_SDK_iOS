//
//  VHDocUpload.h
//  VHDocument
//
//  Created by vhall on 2019/4/26.
//  Copyright © 2019 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHDocUpload : NSObject

/**
 *  获取可上传的文件类型、上传长度限制
 */
+ (NSDictionary *)getUploadConfig;

/**
 *  iCloud文件上传
 *  documentsURL 文件地址；rename 文件重命名，文件名不需带文件类型后缀
 */
+ (void)uploadICloudFileWithUrl:(NSURL *)documentsURL
                     fileRename:(nullable NSString *)rename
                    accessToken:(NSString *)token
                       progress:(nullable void (^)(NSProgress * progress))uploadProgress
                         sucess:(void(^)(NSDictionary *responseObject))uploadSuccess
                        failure:(void(^)(NSError *error))uploadFailure;

/**
 图片上传，相册、拍照文件上传。
 url为referenceURL，相册UIImagePickerControllerReferenceURL，拍照PHImageFileURLKey，可为空，为空时不会上传源文件名称。
 rename，通过此值修改上传文件名称，文件名不需带文件类型后缀。
 */
+ (void)uploadImage:(UIImage *)image
       referenceURL:(nullable NSURL *)url
             reName:(nullable NSString *)rename
        accessToken:(NSString *)token
           progress:(nullable void (^)(NSProgress * progress))uploadProgress
             sucess:(void(^)(NSDictionary *responseObject))uploadSuccess
            failure:(void(^)(NSError *error))uploadFailure;


@end

NS_ASSUME_NONNULL_END
