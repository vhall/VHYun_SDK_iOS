//
//  VHUploaderClient.h
//  VHVODUpload
//
//  Created by vhall on 2019/10/22.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHUploaderModel.h"

@class VHUploaderClient;

NS_ASSUME_NONNULL_BEGIN

/**
 文件上传进度回调
 @param fileInfo     当前上传的文件
 @param uploadedSize 当前已上传段长度
 @param totalSize    一共需要上传的总长度，即当前文件大小
 @warning 上传进度计算：float progress = 1.f * uploadedSize / totalSize;
 */
typedef void (^OnUploadProgressCallback) (VHUploadFileInfo*  _Nullable fileInfo, int64_t uploadedSize, int64_t totalSize);

///上传成功回调
typedef void (^OnUploadSucessCallback) (VHUploadFileInfo* _Nullable fileInfo);

///上传失败回调
typedef void (^OnUploadFailedCallback) (VHUploadFileInfo* _Nullable fileInfo, NSError *error);


///上传SDK 上传类
@interface VHUploaderClient : NSObject

/**
 获取SDK版本号
 */
+ (NSString *)getSDKVersion;

/**
 设置日志打印
 */
+ (void)logEnable:(BOOL)enable;

/**
 初始化
 */
- (instancetype)initWithAccessToken:(NSString *)accessToken;

/**
 单文件上传
 @param filePath 文件路径，不可为空
 @param vodInfo  文件扩展信息，可为空
 @param progressCallback 上传进度回调
 @param successCallback  上传成功回调
 @param failedCallback   上传失败回调
 @warning 异步函数。支持文件大小<5g。上传进度回调是在子线程中，如果有UI处理请注意返回主线程。
 */
- (void)uploadFilePath:(NSString *)filePath
               vodInfo:(nullable VHVodInfo *)vodInfo
              progress:(OnUploadProgressCallback)progressCallback
               success:(OnUploadSucessCallback)successCallback
               failure:(OnUploadFailedCallback)failedCallback;

/**
 分片上传 大文件上传使用分片的方式，如果小文件使用分片，反而效率会低。
 @param filePath 文件路径，不可为空
 @param vodInfo  文件扩展信息，可为空
 @param progressCallback 上传进度回调
 @param successCallback  上传成功回调
 @param failedCallback   上传失败回调
 @warning 适用于大文件上传，如果不是大文件不建议使用分片。
        使用分片上传，如果网络问题导致重新上传时，不需要从头重新开始上传。
        异步函数。支持文件大小<5g。上传进度回调是在子线程中，如果有UI处理请注意返回主线程。
 */
- (void)multipartUpload:(NSString *)filePath
                vodInfo:(nullable VHVodInfo *)vodInfo
               progress:(OnUploadProgressCallback)progressCallback
                success:(OnUploadSucessCallback)successCallback
                failure:(OnUploadFailedCallback)failedCallback;


/**
 断点续传上传
 @param filePath 文件路径，不可为空
 @param vodInfo  文件扩展信息，可为空
 @param progressCallback 上传进度回调
 @param successCallback  上传成功回调
 @param failedCallback   上传失败回调
 @warning 异步函数。支持文件大小<5g。上传进度回调是在子线程中，如果有UI处理请注意返回主线程。当次上传任务内可续传，如果结束任务本次上传将不会再继续。
 */
- (void)resumableUpload:(NSString *)filePath
                vodInfo:(nullable VHVodInfo *)vodInfo
               progress:(OnUploadProgressCallback)progressCallback
                success:(OnUploadSucessCallback)successCallback
                failure:(OnUploadFailedCallback)failedCallback;


@end

NS_ASSUME_NONNULL_END
