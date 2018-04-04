//
//  ISVVideoEffectEditVC.h
//  IfengSmallVideo
//
//  Created by Hanxiaojie on 2018/2/27.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//


#import <AVFoundation/AVFoundation.h>
#import "IFVideoDefine.h"

@class TXVideoEditer;
@class VideoPreview;
@class VideoFingerEffectEditVC;
@protocol VideoFingerEffectEditVCDelegate <NSObject>

- (void)videoFingerEffectVcDidBack:(VideoFingerEffectEditVC*)editVc;
- (void)videoFingerEffectVcDidFinish:(VideoFingerEffectEditVC*)editVc  savedEffects:(NSArray<IFFingertipEffect*> *)savedFingertipEffects;

@end



@interface VideoFingerEffectEditVC : UIViewController

@property (nonatomic, weak) id<VideoFingerEffectEditVCDelegate> delegate;

- (id)initWithAsset:(AVAsset*)asset;
- (void)setupVideoAsset:(AVAsset*)asset;

@end
