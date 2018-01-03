//
//  VHStystemSetting.h
//  VHYunSDKDemo
//
//  Created by vhall on 2017/12/19.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DEMO_Setting [VHStystemSetting sharedSetting]

@interface VHStystemSetting : NSObject
+ (VHStystemSetting *)sharedSetting;

//基础设置
@property(nonatomic, strong)NSString* third_party_user_id;  //第三方ID

//直播播放
@property(nonatomic, strong)NSString* playerRoomID;         //看直播房间ID
@property(nonatomic, strong)NSString* playerAccessToken;    //看直播 AccessToken
@property(nonatomic, assign)NSInteger bufferTime;           //RTMP观看缓冲时间

//推流
@property(nonatomic, strong)NSString* publishRoomID;        //发直播房间ID
@property(nonatomic, strong)NSString* publishAccessToken;   //发直播 AccessToken
@property(nonatomic, strong)NSString* videoResolution;      //发起直播分辨率 VideoResolution [0,3] 默认1
@property(nonatomic, assign)NSInteger videoBitRate;         //发直播视频码率
@property(nonatomic, assign)NSInteger audioBitRate;         //发直播视频码率
@property(nonatomic, assign)NSInteger videoCaptureFPS;      //发直播视频帧率 ［1～30］ 默认10
@property(nonatomic, assign)BOOL      isOpenNoiseSuppresion;//开启降噪 默认YES
@property(nonatomic, assign)float     volumeAmplificateSize;//开启降噪 默认1.0

//点播
@property(nonatomic, strong)NSString* recordID;             //点播房间ID
@property(nonatomic, strong)NSString* vodAccessToken;       //点播 AccessToken

//文档直播
@property(nonatomic, strong)NSString* docChannelID;         //文档ChannelID
@property(nonatomic, strong)NSString* docAccessToken;       //文档AccessToken

//IM
@property(nonatomic, strong)NSString* imChannelID;          //im ChannelID
@property(nonatomic, strong)NSString* imAccessToken;       //im AccessToken

@end
