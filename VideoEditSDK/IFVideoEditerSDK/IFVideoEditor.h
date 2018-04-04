//
//  IFVideoEditor.h
//  粒子动画
//
//  Created by Hanxiaojie on 2018/2/2.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "IFFingertipEffect.h"



@interface IFVideoEditor : NSObject

@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign, readonly) NSTimeInterval duration;
@property (nonatomic, assign) BOOL fingertipEnable;
@property (nonatomic, assign) CGFloat rate;
@property (nonatomic, strong) NSArray<IFFingertipEffect*>* savedFingertipEffects;

- (instancetype)initWithURL:(NSURL*)url preview:(UIView*)preview;

- (instancetype)initWithPlayerItem:(AVPlayerItem*)playerItem preview:(UIView*)preview;

- (void)play;
- (void)stop;
- (void)setupEffects:(NSArray<IFFingertipEffect*>*) effects;
/*
 *设置当前正在使用的指尖特效
 */
- (void)setupCurrentUsingEffect:(IFFingertipEffect*)fingertipEffect;
/*
 *删除最后一个特效
 */
- (void)removeLastFingertipEffect;
/*
 *删除所有指尖特效
 */
- (void)removeAllFingertipEffect;

/*
 *预览指定时刻的视频帧
 */
- (void)showVideoFrameAtTime:(NSTimeInterval)time;

/*
 *导出视频
 */
- (void)exportAsynchronouslyWithCompletionHandler:(void (^)(NSURL *urlPath)) completionHandle;
/*
 *释放编辑资源
 */
- (void)invalidate;
@end
