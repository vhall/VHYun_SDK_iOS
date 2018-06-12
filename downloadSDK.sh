#!/bin/sh
#

# 下载 微吼云 SDK
# 版本号如下
echo "|-------------------------------sdk version-------------------------------------|"
VHYunSDKVersion="VHYunSDK_iOS_v1.2"

echo $VHYunSDKVersion

#清除现有文件
echo "|-------------------------------clear sdk dir...--------------------------------|"
rm -rf VHYunSDK

#下载sdk zip文件
echo "|-------------------------------download VHYunSDK-------------------------------|"
curl -o VHYunSDK.zip "http://static01-open.e.vhall.com/vhallyun/sdk/$VHYunSDKVersion.zip" --max-time 600 --retry 5
echo "|-------------------------------download Successful-----------------------------|"

#解压zip文件
echo "|-------------------------------unzip VHYunSDK----------------------------------|"
unzip VHYunSDK.zip -x __MACOSX/*


#移除zip文件
echo "|-------------------------------remove zip--------------------------------------|"
rm -rf VHYunSDK.zip