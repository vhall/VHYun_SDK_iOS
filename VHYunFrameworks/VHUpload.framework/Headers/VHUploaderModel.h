//
//  VHUploaderModel.h
//  VHUpload
//
//  Created by vhall on 2019/10/24.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///文件状态 准备上传、正在上传、上传失败、上传成功
typedef NS_ENUM(NSInteger,VHUploadFileState) {
    VHUploadFileStatePrepare,
    VHUploadFileStateUploding,
    VHUploadFileStateFailed,
    VHUploadFileStateUploded,
};

@interface VHVodInfo : NSObject

/**
 上传时设置的文件名。不传默认取文件路径的后缀。无类型后缀
 */
@property (nonatomic, copy) NSString *name;
/**
 文件标识
 */
@property (nonatomic, copy) NSString *tags;
/**
 文件描述
 */
@property (nonatomic, copy) NSString *desc;
/**
 用户自定义参数
 */
@property (nonatomic, copy) NSString *userData;

@end

@interface VHUploadFileInfo : NSObject

/**
 文件状态
 */
@property (nonatomic, assign) VHUploadFileState fileState;
/**
 传入的文件路径
 */
@property (nonatomic, copy) NSString *filePath;
/**
 上传文件路径，内部使用
 */
@property (nonatomic, copy) NSString *uploadPath;
/**
 文件类型
 */
@property (nonatomic, copy) NSString *MIMEType;
/**
 文件大小
 */
@property (nonatomic, assign) int64_t totalBytes;
/**
 自定义参数，暂时未使用
 */
@property (nonatomic, strong, nullable) NSDictionary *callbackParam;
/**
 文件MD5
 */
@property (nonatomic, copy) NSString *fileMD5;
/**
 上传信息
 */
@property (nonatomic, strong) VHVodInfo *vodInfo;

@end

///上传SDK Model类
@interface VHUploaderModel : NSObject


/**
 获取文件大小
 @param filePath 文件路径
 @warning error 读取出错回调
 */
+ (unsigned long long)getSizeWithFilePath:(nonnull NSString *)filePath error:(NSError **)error;


@end

NS_ASSUME_NONNULL_END
