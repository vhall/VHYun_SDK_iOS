#!/bin/sh
#


SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)
cd $SCRIPT_DIR

echo "|-------------------------------  Del Start    ---------------------------|"

lipo -remove x86_64 ./VHMediaSDK/VhallLiveBaseApi.framework/VhallLiveBaseApi -o ./VHMediaSDK/VhallLiveBaseApi.framework/VhallLiveBaseApi

lipo -remove x86_64 ./VHInteractive/VhallSignalingDynamic.framework/VhallSignalingDynamic -o ./VHInteractive/VhallSignalingDynamic.framework/VhallSignalingDynamic
lipo -remove i386   ./VHInteractive/VhallSignalingDynamic.framework/VhallSignalingDynamic -o ./VHInteractive/VhallSignalingDynamic.framework/VhallSignalingDynamic

lipo -remove x86_64 ./VHInteractive/WebRTC.framework/WebRTC -o ./VHInteractive/WebRTC.framework/WebRTC

echo "|-------------------------------Del Successful----------------------------|"
