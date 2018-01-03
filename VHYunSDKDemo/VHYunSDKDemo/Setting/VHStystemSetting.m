//
//  VHStystemSetting.m
//  VHYunSDKDemo
//
//  Created by vhall on 2017/12/19.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//


#import "VHStystemSetting.h"
#import <objc/message.h>

@implementation VHStystemSetting

static VHStystemSetting *pub_sharedSetting = nil;

+ (VHStystemSetting *)sharedSetting
{
    @synchronized(self)
    {
        if (pub_sharedSetting == nil)
        {
            pub_sharedSetting = [[VHStystemSetting alloc] init];
        }
    }
    
    return pub_sharedSetting;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (pub_sharedSetting == nil) {
            
            pub_sharedSetting = [super allocWithZone:zone];
            return pub_sharedSetting;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        //基础设置
        _third_party_user_id= [standardUserDefaults objectForKey:@"VHthird_party_user_id"];  //第三方ID
        
        //直播播放
        _playerRoomID       = [standardUserDefaults objectForKey:@"VHplayerRoomID"];         //看直播房间ID
        _playerAccessToken  = [standardUserDefaults objectForKey:@"VHplayerAccessToken"];    //看直播 AccessToken
        _bufferTime         = [standardUserDefaults integerForKey:@"VHbufferTime"];          //RTMP观看缓冲时间
        
        //推流
        _publishRoomID      = [standardUserDefaults objectForKey:@"VHpublishRoomID"];        //发直播房间ID
        _publishAccessToken = [standardUserDefaults objectForKey:@"VHpublishAccessToken"];   //发直播 AccessToken
        _videoResolution    = [standardUserDefaults objectForKey:@"VHvideoResolution"];      //发起直播分辨率 VideoResolution [0,3] 默认1
        _videoBitRate       = [standardUserDefaults integerForKey:@"VHvideoBitRate"];         //发直播视频码率
        _audioBitRate       = [standardUserDefaults integerForKey:@"VHaudioBitRate"];         //发直播视频码率
        _videoCaptureFPS    = [standardUserDefaults integerForKey:@"VHvideoCaptureFPS"];      //发直播视频帧率 ［1～30］ 默认10
        if([standardUserDefaults valueForKey:@"VHisOpenNoiseSuppresion"])
            self.isOpenNoiseSuppresion = [standardUserDefaults boolForKey:@"VHisOpenNoiseSuppresion"];
        else
            self.isOpenNoiseSuppresion = YES;
        
        if([standardUserDefaults valueForKey:@"VHvolumeAmplificateSize"])
            self.volumeAmplificateSize = [standardUserDefaults floatForKey:@"VHvolumeAmplificateSize"];
        else
            self.volumeAmplificateSize = 1.0;
        
        //点播
        _recordID           = [standardUserDefaults objectForKey:@"VHrecordID"];            //点播房间ID
        _vodAccessToken     = [standardUserDefaults objectForKey:@"VHvodAccessToken"];      //点播 AccessToken
        
        //文档直播
        _docChannelID       = [standardUserDefaults objectForKey:@"VHdocChannelID"];        //文档ChannelID
        _docAccessToken     = [standardUserDefaults objectForKey:@"VHdocAccessToken"];      //文档AccessToken
        
        //IM
        _imChannelID       = [standardUserDefaults objectForKey:@"VHimChannelID"];        //文档ChannelID
        _imAccessToken     = [standardUserDefaults objectForKey:@"VHimAccessToken"];      //文档AccessToken
        
        //基础设置
        if(_third_party_user_id == nil)
            _third_party_user_id = @"third_party_user_id";
        //直播播放
        if(_playerRoomID.length == 0)
            _playerRoomID       = DEMO_PlayerRoomID;
        if(_playerAccessToken.length == 0)
            _playerAccessToken  = DEMO_AccessToken;
        if(_bufferTime <=0)
            _bufferTime = 6;
        //推流
        if(_publishRoomID.length == 0)
            _publishRoomID      = DEMO_PublishRoomID;
        if(_publishAccessToken.length == 0)
            _publishAccessToken = DEMO_AccessToken;
        if(_videoResolution.length == 0)
            _videoResolution = @"2";
        if(_videoBitRate<=0)
            _videoBitRate = 600;
        if(_audioBitRate<=0)
            _audioBitRate = 16;
        if(_videoCaptureFPS < 10 || _videoCaptureFPS >30)
            _videoCaptureFPS = 15;
        //点播
        if(_recordID.length == 0)
            _recordID       = DEMO_RecordID;
        if(_vodAccessToken.length == 0)
            _vodAccessToken  = DEMO_AccessToken;
        
        //文档直播
        if(_docChannelID.length == 0)
            _docChannelID   = DEMO_DocChannelID;
        if(_docAccessToken.length == 0)
            _docAccessToken = DEMO_AccessToken;
        
        //IM
        if(_imChannelID.length == 0)
            _imChannelID   = DEMO_IMChannelID;
        if(_imAccessToken.length == 0)
            _imAccessToken = DEMO_AccessToken;
    }
    return self;
}
#pragma mark - 基础设置
- (void)setThird_party_user_id:(NSString *)third_party_user_id
{
    _third_party_user_id = third_party_user_id;
    if(third_party_user_id.length == 0)
    {
        _third_party_user_id = DEMO_third_party_user_id;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VHthird_party_user_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [VHLiveBase setThirdPartyUserId:_third_party_user_id];
        return;
    }
    [VHLiveBase setThirdPartyUserId:_third_party_user_id];
    [[NSUserDefaults standardUserDefaults] setObject:third_party_user_id forKey:@"VHthird_party_user_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - 直播播放
- (void)setPlayerRoomID:(NSString *)playerRoomID
{
    _playerRoomID = playerRoomID;
    if(playerRoomID.length == 0)
    {
        _playerRoomID = DEMO_PlayerRoomID;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VHplayerRoomID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:playerRoomID forKey:@"VHplayerRoomID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPlayerAccessToken:(NSString *)playerAccessToken
{
    _playerAccessToken = playerAccessToken;
    if(playerAccessToken.length == 0)
    {
        _playerAccessToken = DEMO_AccessToken;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VHplayerAccessToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:playerAccessToken forKey:@"VHplayerAccessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setBufferTime:(NSInteger)bufferTime
{
    if(bufferTime <=0)
        bufferTime = 2;
    
    _bufferTime = bufferTime;
    [[NSUserDefaults standardUserDefaults] setInteger:bufferTime forKey:@"VHbufferTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 推流
- (void)setPublishRoomID:(NSString *)publishRoomID
{
    _publishRoomID = publishRoomID;
    if(publishRoomID.length == 0)
    {
        _publishRoomID = DEMO_PublishRoomID;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VHpublishRoomID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:publishRoomID forKey:@"VHpublishRoomID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setPublishAccessToken:(NSString *)publishAccessToken
{
    _publishAccessToken = publishAccessToken;
    if(publishAccessToken.length == 0)
    {
        _publishAccessToken = DEMO_AccessToken;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VHpublishAccessToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:publishAccessToken forKey:@"VHpublishAccessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setVideoResolution:(NSString*)videoResolution
{
    if(videoResolution == nil || videoResolution.length == 0)
        return;
    if([videoResolution integerValue]<0 || [videoResolution integerValue]>3)
        return;
    
    _videoResolution = videoResolution;
    [[NSUserDefaults standardUserDefaults] setObject:_videoResolution forKey:@"VHvideoResolution"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setVideoBitRate:(NSInteger)videoBitRate
{
    if(videoBitRate<=0)
        return;
    
    _videoBitRate = videoBitRate;
    [[NSUserDefaults standardUserDefaults] setInteger:videoBitRate forKey:@"VHvideoBitRate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setAudioBitRate:(NSInteger)audioBitRate
{
    if(audioBitRate<=0)
        return;
    
    _audioBitRate = audioBitRate;
    [[NSUserDefaults standardUserDefaults] setInteger:audioBitRate forKey:@"VHaudiobitRate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setVideoCaptureFPS:(NSInteger)videoCaptureFPS
{
    if(videoCaptureFPS <10 || videoCaptureFPS >30)
        videoCaptureFPS = 15;
    
    _videoCaptureFPS = videoCaptureFPS;
    [[NSUserDefaults standardUserDefaults] setInteger:videoCaptureFPS forKey:@"VHvideoCaptureFPS"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setIsOpenNoiseSuppresion:(BOOL)isOpenNoiseSuppresion
{
    _isOpenNoiseSuppresion = isOpenNoiseSuppresion;
    [[NSUserDefaults standardUserDefaults] setBool:_isOpenNoiseSuppresion forKey:@"VHisOpenNoiseSuppresion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setVolumeAmplificateSize:(float)volumeAmplificateSize
{
    _volumeAmplificateSize = volumeAmplificateSize;
    [[NSUserDefaults standardUserDefaults] setFloat:_volumeAmplificateSize forKey:@"VHvolumeAmplificateSize"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 点播
- (void)setRecordID:(NSString *)recordID
{
    _recordID = recordID;
    if(recordID.length == 0)
    {
        _recordID = DEMO_RecordID;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VHrecordID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:recordID forKey:@"VHrecordID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setVodAccessToken:(NSString *)vodAccessToken
{
    _vodAccessToken = vodAccessToken;
    if(vodAccessToken.length == 0)
    {
        _vodAccessToken = DEMO_AccessToken;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VHvodAccessToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:vodAccessToken forKey:@"VHvodAccessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 文档直播
- (void)setDocChannelID:(NSString *)docChannelID
{
    _docChannelID = docChannelID;
    if(docChannelID.length == 0)
    {
        _docChannelID = DEMO_DocChannelID;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VHdocChannelID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_docChannelID forKey:@"VHdocChannelID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setDocAccessToken:(NSString *)docAccessToken
{
    _docAccessToken = docAccessToken;
    if(docAccessToken.length == 0)
    {
        _docAccessToken = DEMO_AccessToken;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VHdocAccessToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_docAccessToken forKey:@"VHdocAccessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - IM
- (void)setImChannelID:(NSString *)imChannelID
{
    _imChannelID = imChannelID;
    if(imChannelID.length == 0)
    {
        _imChannelID = DEMO_IMChannelID;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VHimChannelID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_imChannelID forKey:@"VHimChannelID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setImAccessToken:(NSString *)imAccessToken
{
    _imAccessToken = imAccessToken;
    if(imAccessToken.length == 0)
    {
        _imAccessToken = DEMO_AccessToken;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VHimAccessToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_imAccessToken forKey:@"VHimAccessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
