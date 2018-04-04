//
//  IFVideoEditor.m
//  粒子动画
//
//  Created by Hanxiaojie on 2018/2/2.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import "IFVideoEditor.h"
#import "IFPreview.h"

@interface IFVideoEditor ()<IFPreviewDelegate>
{
    IFFingertipEffect *_currentUsingEffect;//当前正在应用的指尖特效
    IFFingertipEffect *_currentAddingEffect;//当前正在添加的指尖特效
    IFPreview *_videoPreview; //视频预览view
}
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVSynchronizedLayer *synchronizedLayer;
@property (nonatomic, strong) NSMutableArray *fingertipEffects;

@end

@implementation IFVideoEditor

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fingertipEffects = [NSMutableArray arrayWithCapacity:3];
    }
    return self;
}

- (instancetype)initWithURL:(NSURL*)url preview:(UIView*)preview
{
    NSParameterAssert(url);
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    return [self initWithPlayerItem:playerItem preview:preview];
}
- (instancetype)initWithPlayerItem:(AVPlayerItem*)playerItem preview:(UIView*)preview
{
    self = [self init];
    if (self) {
        
        NSParameterAssert(playerItem);
        
        self.synchronizedLayer = [AVSynchronizedLayer synchronizedLayerWithPlayerItem:playerItem];
        
        self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;

        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.videoGravity=AVLayerVideoGravityResizeAspect; //视频填充模式
        if (preview && [preview isKindOfClass:[UIView class]]) {
            
            _videoPreview = [[IFPreview alloc] initWithFrame:preview.bounds];
            _videoPreview.delegate = self;
            _videoPreview.fingertipEnable = YES;
            [preview addSubview:_videoPreview];
            
            self.playerLayer.frame = _videoPreview.bounds;
            [_videoPreview.layer addSublayer:self.playerLayer];
            self.synchronizedLayer.frame = _videoPreview.bounds;
            [_videoPreview.layer addSublayer:self.synchronizedLayer];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    }
    return self;
}


- (BOOL)fingertipEnable{
    return _videoPreview.fingertipEnable;
}
//设置是否开启指尖魔法
- (void)setFingertipEnable:(BOOL)fingertipEnable {
    _videoPreview.fingertipEnable = fingertipEnable;
}

- (NSTimeInterval)currentTime {
    if (self.player && self.player.currentItem) {
        return CMTimeGetSeconds(self.player.currentItem.currentTime);
    } else {
        return 0;
    }
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    CMTime start = CMTimeMake((int64_t)(currentTime * 100), 100);
    [self.player seekToTime:start toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (NSTimeInterval)duration {
    return CMTimeGetSeconds(self.player.currentItem.asset.duration);
}

- (void)setRate:(CGFloat)rate {
    _rate = rate;
    [self play];
}

- (void)play
{
    if (_rate) {
        [self.player playImmediatelyAtRate:_rate];
    } else {
        [self.player playImmediatelyAtRate:1.0];
    }
}
- (void)stop {
    [self.player pause];
}
//设置默认
- (void)setupEffects:(NSArray<IFFingertipEffect*>*) effects
{
    NSArray *subLayers = [self.synchronizedLayer sublayers];
    for (CALayer *layer in subLayers) {
        if ([layer isKindOfClass:[IFFingertipEffect class]]) {
            IFFingertipEffect * fingertipEffect = (IFFingertipEffect*)layer;
            [fingertipEffect invalidate];
        }
    }
    for (IFFingertipEffect * fingerEffect in effects) {
        [self.synchronizedLayer addSublayer:fingerEffect];
    }
}

- (NSArray<IFFingertipEffect*>*)savedFingertipEffects
{
    NSMutableArray *fingerTips = [NSMutableArray new];
    NSArray *subLayers = [self.synchronizedLayer sublayers];
    for (CALayer *layer in subLayers) {
        if ([layer isKindOfClass:[IFFingertipEffect class]]) {
            IFFingertipEffect * fingertipEffect = (IFFingertipEffect*)layer;
            [fingerTips addObject:[fingertipEffect copyEffectAndAnimations]];
        }
    }
    return fingerTips;
    
}
/*
 *设置当前正在使用的指尖特效
 */
- (void)setupCurrentUsingEffect:(IFFingertipEffect*)fingertipEffect
{
    _currentUsingEffect = fingertipEffect;
}

/*
 *开始特效
 */
- (void)startEffectPosition:(CGPoint)point
{
    NSParameterAssert(_currentUsingEffect);
    _currentAddingEffect = [_currentUsingEffect copyEffect];
    NSLog(@"%@",_currentAddingEffect);
    [self.synchronizedLayer addSublayer:_currentAddingEffect];
    [self.fingertipEffects addObject:_currentAddingEffect];
    [_currentAddingEffect startEffectPosition:point beginTime:self.currentTime];
}
/*
 *修改特效位置
 */
- (void)changeEffectPosition:(CGPoint)point
{
    [_currentAddingEffect changeEffectPosition:point beginTime:self.currentTime];
}
/*

 *结束特效
 */
- (void)endEffectPosition:(CGPoint)point
{
    [_currentAddingEffect endEffectPosition:point beginTime:self.currentTime];
}
/*
 *删除所有指尖特效
 */
- (void)removeAllFingertipEffect;
{
    
    NSArray *layers = [self.synchronizedLayer sublayers];
    NSLog(@"%@",layers);
    for (int i = 0; i < layers.count; i ++) {
        CALayer * layer = layers[i];
        if ([layer isKindOfClass:[IFFingertipEffect class]]) {
            IFFingertipEffect *effect = (IFFingertipEffect*)layer;
            [effect invalidate];
        }
    }
    
    [self.fingertipEffects removeAllObjects];
}
/*
 *删除最后一个特效
 */
- (void)removeLastFingertipEffect
{
    IFFingertipEffect *lastFingertipEffect = [self.fingertipEffects lastObject];
    if (lastFingertipEffect) {
        [lastFingertipEffect invalidate];
        [self.fingertipEffects removeObject:lastFingertipEffect];
    }
}
/*
 秒数转CMTime
 */
- (CMTime)SecondsGetCMTime:(NSTimeInterval) seconds {
    return CMTimeMake((int64_t)(seconds * 10000), 10000);
}

/*
 预览指定时刻的视频帧
 */
- (void)showVideoFrameAtTime:(NSTimeInterval)time
{
    
}

/*
 导出视频
 */
- (void)exportAsynchronouslyWithCompletionHandler:(void (^)(NSURL *urlPath)) completionHandle
{
    if (self.player && self.player.currentItem) {
        NSArray *assetKeysToLoad = @[@"tracks", @"duration", @"composable",@"naturalSize"];
        AVAsset * asset = self.player.currentItem.asset;
        [asset loadValuesAsynchronouslyForKeys:assetKeysToLoad completionHandler:^(){
            // 测试是否成功加载
            BOOL bSuccess = YES;
            for (NSString *key in assetKeysToLoad) {
                NSError *error;
                if ([asset statusOfValueForKey:key error:&error] == AVKeyValueStatusFailed) {
                    NSLog(@"Key value loading failed for key:%@ with error: %@", key, error);
                    bSuccess = NO;
                    break;
                }
            }
            if (bSuccess && [asset isComposable]) {
                
                NSLog(@"视频总时长：%lf",CMTimeGetSeconds(asset.duration));
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self startExportAsset:asset complition:completionHandle];
                });
                
            }
            else {
                completionHandle ? completionHandle(nil) : nil;
            }
        }];
    } else {
        completionHandle ? completionHandle(nil) : nil;
    }
}

- (void)startExportAsset:(AVAsset*)videoAsset complition:(void (^)(NSURL *urlPath)) completionHandle{
    
    //1 创建AVAsset实例 AVAsset包含了video的所有信息 self.videoUrl输入视频的路径
    
    CMTime startTime = kCMTimeZero;
    CMTime endTime = videoAsset.duration;
    
    //声音采集
    
    //2 创建AVMutableComposition实例. apple developer 里边的解释 【AVMutableComposition is a mutable subclass of AVComposition you use when you want to create a new composition from existing assets. You can add and remove tracks, and you can add, remove, and scale time ranges.】
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    //3 视频通道  工程文件中的轨道，有音频轨、视频轨等，里面可以插入各种对应的素材
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    //把视频轨道数据加入到可变轨道中 这部分可以做视频裁剪TimeRange
    [videoTrack insertTimeRange:CMTimeRangeMake(startTime, endTime)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    //音频通道
    AVMutableCompositionTrack * audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //音频采集通道
    AVAssetTrack * audioAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    [audioTrack insertTimeRange:CMTimeRangeMake(startTime, endTime) ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    
    //3.1 AVMutableVideoCompositionInstruction 视频轨道中的一个视频，可以缩放、旋转等
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoTrack.timeRange.duration);
    // 3.2 AVMutableVideoCompositionLayerInstruction 一个视频轨道，包含了这个轨道上的所有视频素材
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    //    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        //        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        //        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:endTime];
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    //AVMutableVideoComposition：管理所有视频轨道，可以决定最终视频的尺寸，裁剪需要在这里进行
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    overlayLayer.frame = CGRectMake(0, 0, renderWidth, renderHeight);
    [overlayLayer setMasksToBounds:NO];
    if (self.synchronizedLayer) {
        for (CALayer *layer in self.synchronizedLayer.sublayers) {
            NSLog(@"class = %@",layer);
            
            if ([layer isKindOfClass:[IFFingertipEffect class]]) {
                IFFingertipEffect * emitterLayer = (IFFingertipEffect*)layer;
                IFFingertipEffect * eLayer = [emitterLayer exportHandlerWithFrame:self.playerLayer.bounds naturalSize:naturalSize];
                [overlayLayer addSublayer:eLayer];
            } else {
                [overlayLayer addSublayer:layer];
            }
            
        }
    }
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, renderWidth, renderHeight);
    videoLayer.frame = CGRectMake(0, 0, renderWidth, renderHeight);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    
    mainCompositionInst.animationTool = [AVVideoCompositionCoreAnimationTool
                                         videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    // 4 - 输出路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[NSUUID UUID].UUIDString]];
    unlink([myPathDocs UTF8String]);
    NSURL* videoUrl = [NSURL fileURLWithPath:myPathDocs];
    
    // 5 - 视频文件输出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=videoUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //这里是输出视频之后的操作，做你想做的
            completionHandle ? completionHandle(videoUrl) : nil;
        });
    }];
    
    
    
}

/*
 释放编辑资源
 */
- (void)invalidate
{
    [self.player pause];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.playerLayer removeFromSuperlayer];
    NSArray *layers = [self.synchronizedLayer sublayers];
    [layers makeObjectsPerformSelector:@selector(removeAllAnimations)];
    [layers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    [self.synchronizedLayer removeFromSuperlayer];
    self.synchronizedLayer = nil;
    self.playerLayer = nil;
    self.player = nil;
}

#pragma mark - AVPlayerItemDidPlayToEndTimeNotification
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    if (p && [p isKindOfClass:[AVPlayerItem class]]) {
        [p seekToTime:kCMTimeZero completionHandler:nil];
    }
}

#pragma mark IFPreviewDelegate

- (void)preview:(IFPreview*)preview startDragAtPosition:(CGPoint) position
{
    [self startEffectPosition:position];
}
- (void)preview:(IFPreview*)preview changeDragAtPosition:(CGPoint) position
{
    [self changeEffectPosition:position];
}
- (void)preview:(IFPreview*)preview endDragAtPosition:(CGPoint) position
{
    [self endEffectPosition:position];
}

@end
