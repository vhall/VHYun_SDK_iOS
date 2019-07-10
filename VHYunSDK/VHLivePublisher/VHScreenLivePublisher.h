//
//  VHScreenLivePublisher.h
//  VHLivePublisher
//
//  Created by vhall on 2019/6/11.
//  Copyright © 2019 www.vhall.com. All rights reserved.
//

#import "VHLivePublisher.h"

NS_ASSUME_NONNULL_BEGIN

@interface VHScreenLivePublisher : VHLivePublisher
/**
 *  开始录屏直播推流 注意必须是 iOS 12及以上系统使用
 *  @param roomID       房间ID
 *  @param accessToken  accessToken
 *  @param extension    extension App bundleID
 */
- (BOOL)startPublish:(NSString*)roomID accessToken:(NSString*)accessToken extension:(NSString*)extension;

/**
 *  停止推流
 */
- (BOOL)stopPublish;
@end

NS_ASSUME_NONNULL_END
