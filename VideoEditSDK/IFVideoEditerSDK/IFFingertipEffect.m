//
//  IFFingertipEffect.m
//  粒子动画
//
//  Created by Hanxiaojie on 2018/2/8.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import "IFFingertipEffect.h"

@interface IFFingertipEffect ()

@end

@implementation IFFingertipEffect
- (instancetype)initDefaultEmitterLayer
{
    self = [super init];
    if (self) {
        //设置发射器
        
        self.emitterPosition=CGPointMake(0,0);
        self.lastPosition = self.emitterPosition;
        self.emitterSize=CGSizeMake(22, 22);
        self.emitterShape = kCAEmitterLayerSurface;
        self.renderMode = kCAEmitterLayerAdditive;
        self.preservesDepth = YES;
        self.birthRate = 0;
        //发射单元
        //彩带
        CAEmitterCell * smoke = [CAEmitterCell emitterCell];
        
        smoke.birthRate=10;
        smoke.lifetime=0.5;
        smoke.lifetimeRange=0.5;
        smoke.scale = 0.4;
        smoke.scaleRange = 0.4;
        smoke.color=[UIColor colorWithRed:0 green:1 blue:0 alpha:1].CGColor;
        smoke.alphaRange = 0;
        smoke.redRange =255;
        smoke.blueRange = 22;
        smoke.greenRange = 1.5;
        smoke.contents=(id)[[UIImage imageNamed:@"snow1"]CGImage];
        [smoke setName:@"snow1"];
        
        smoke.velocity=100;
        smoke.velocityRange=50;
        smoke.emissionLongitude=M_PI+M_PI;
        smoke.emissionRange=M_PI * 2;
        smoke.spin = M_PI_2;
        smoke.spinRange = M_PI_2;
        smoke.alphaSpeed = 0.5;
        self.emitterCells=[NSArray arrayWithObjects:smoke,nil];
    }
    return self;
}
- (id)copyWithZone:(NSZone *)zone
{
    return [self initDefaultEmitterLayer];
}

//将IFFingertipEffect 复制一份
- (IFFingertipEffect *)copyEffect
{
    IFFingertipEffect * emitterLayer = [[IFFingertipEffect alloc] initDefaultEmitterLayer];
    return emitterLayer;
}
- (IFFingertipEffect *)copyEffectAndAnimations
{
    IFFingertipEffect * emitterLayer = [[IFFingertipEffect alloc] initDefaultEmitterLayer];
    NSArray *animationKeys = [self animationKeys];
    for (NSString * animationKey in animationKeys) {
        CABasicAnimation *animation = (CABasicAnimation*) [self animationForKey:animationKey];
        if ([animation.keyPath isEqualToString:@"emitterPosition"]) {
            
            CABasicAnimation *anim = [CABasicAnimation animation];
            anim.keyPath = @"emitterPosition";
            anim.fromValue = animation.fromValue;
            anim.toValue =animation.toValue;
            anim.removedOnCompletion = NO;
            anim.duration = 0.01;
            anim.beginTime =animation.beginTime;
            //保存动画最前面效果
            anim.fillMode = kCAFillModeForwards;
            anim.repeatCount = 0;
            [emitterLayer addAnimation:anim forKey:[NSString stringWithFormat:@"%.6f",animation.beginTime]];
            
        } else {
            
            CABasicAnimation *runAnim = (CABasicAnimation*)[self animationForKey:@"RunEmitter"];
            CABasicAnimation *anim = [CABasicAnimation animation];
            anim.keyPath = @"birthRate";
            anim.fromValue = @(0);
            anim.toValue = @(10);
            anim.removedOnCompletion = NO;
            anim.duration = 0.1;
            anim.beginTime =runAnim.beginTime;
            //保存动画最前面效果
            anim.fillMode = kCAFillModeForwards;
            anim.repeatCount = 0;
            [emitterLayer addAnimation:anim forKey:@"RunEmitter"];
            
            CABasicAnimation *stopAnim = (CABasicAnimation*)[self animationForKey:@"StopEmitter"];
            
            CABasicAnimation *anim1 = [CABasicAnimation animation];
            anim1.keyPath = @"birthRate";
            anim1.fromValue = @(10);
            anim1.toValue = @(0);
            anim1.removedOnCompletion = NO;
            anim1.duration = 0.1;
            anim1.beginTime =stopAnim.beginTime;
            //保存动画最前面效果
            anim1.fillMode = kCAFillModeForwards;
            anim1.repeatCount = 0;
            [emitterLayer addAnimation:anim1 forKey:@"StopEmitter"];
            
        }
    }
    return emitterLayer;
}
/*
 *开始特效
 */
- (void)startEffectPosition:(CGPoint)point beginTime:(NSTimeInterval)beginTime
{
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"birthRate";
    anim.fromValue = @(0);
    anim.toValue = @(10);
    self.emitterPosition = point;
    self.lastPosition = point;
    anim.removedOnCompletion = NO;
    anim.duration = 0.02;
    anim.beginTime =beginTime;
    //保存动画最前面效果
    anim.fillMode = kCAFillModeForwards;
    anim.repeatCount = 0;
    [self addAnimation:anim forKey:@"RunEmitter"];
}
/*
 *修改特效位置
 */
- (void)changeEffectPosition:(CGPoint)point beginTime:(NSTimeInterval)beginTime
{
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"emitterPosition";
    anim.fromValue = [NSValue valueWithCGPoint:self.lastPosition];
    anim.toValue = [NSValue valueWithCGPoint:point];
    self.lastPosition = point;
    anim.removedOnCompletion = NO;
    anim.duration = 0.02;
    anim.beginTime =beginTime;
    //保存动画最前面效果
    anim.fillMode = kCAFillModeForwards;
    anim.repeatCount = 0;
    [self addAnimation:anim forKey:[NSString stringWithFormat:@"%.6f",beginTime]];
}
/*
 
 *结束特效
 */
- (void)endEffectPosition:(CGPoint)point beginTime:(NSTimeInterval)beginTime
{
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"birthRate";
    anim.fromValue = @(10);
    anim.toValue = @(0);
    self.lastPosition = point;
    anim.removedOnCompletion = NO;
    anim.duration = 0.02;
    anim.beginTime =beginTime;
    //保存动画最前面效果
    anim.fillMode = kCAFillModeForwards;
    anim.repeatCount = 0;
    [self addAnimation:anim forKey:@"StopEmitter"];
}

- (IFFingertipEffect *)exportHandlerWithFrame:(CGRect)frame naturalSize:(CGSize)naturalSize
{
    
    IFFingertipEffect * emitterLayer = [[IFFingertipEffect alloc] initDefaultEmitterLayer];
    
    NSArray<CAEmitterCell*> *cells = emitterLayer.emitterCells;
    for (CAEmitterCell * cell in cells) {
        cell.scale = (naturalSize.width)/(750.0) * 0.5;
        cell.scaleRange = (naturalSize.width)/(750.0) * 0.5;
    }
    emitterLayer.emitterSize=CGSizeMake(11, 11);
    NSArray *animationKeys = [self animationKeys];
    for (NSString * animationKey in animationKeys) {
        CABasicAnimation *animation = (CABasicAnimation*) [self animationForKey:animationKey];
        if ([animation.keyPath isEqualToString:@"emitterPosition"]) {
            CGPoint fromeValue;
            [animation.fromValue getValue:&fromeValue];
            fromeValue = [self convertPoint:fromeValue withFrame:frame naturalSize:naturalSize];
            
            CGPoint toValue;
            [animation.toValue getValue:&toValue];
            toValue = [self convertPoint:toValue withFrame:frame naturalSize:naturalSize];
            
            CABasicAnimation *anim = [CABasicAnimation animation];
            anim.keyPath = @"emitterPosition";
            anim.fromValue = [NSValue valueWithCGPoint:fromeValue];
            anim.toValue = [NSValue valueWithCGPoint:toValue];
            anim.removedOnCompletion = NO;
            anim.duration = 0.01;
            anim.beginTime =animation.beginTime;
            //保存动画最前面效果
            anim.fillMode = kCAFillModeForwards;
            anim.repeatCount = 0;
            [emitterLayer addAnimation:anim forKey:[NSString stringWithFormat:@"%.6f",animation.beginTime]];
            
        } else {
            
            CABasicAnimation *runAnim = (CABasicAnimation*)[self animationForKey:@"RunEmitter"];
            CABasicAnimation *anim = [CABasicAnimation animation];
            anim.keyPath = @"birthRate";
            anim.fromValue = @(0);
            anim.toValue = @(10);
            anim.removedOnCompletion = NO;
            anim.duration = 0.1;
            anim.beginTime =runAnim.beginTime;
            //保存动画最前面效果
            anim.fillMode = kCAFillModeForwards;
            anim.repeatCount = 0;
            [emitterLayer addAnimation:anim forKey:@"RunEmitter"];
            
            CABasicAnimation *stopAnim = (CABasicAnimation*)[self animationForKey:@"StopEmitter"];
            
            CABasicAnimation *anim1 = [CABasicAnimation animation];
            anim1.keyPath = @"birthRate";
            anim1.fromValue = @(10);
            anim1.toValue = @(0);
            anim1.removedOnCompletion = NO;
            anim1.duration = 0.1;
            anim1.beginTime =stopAnim.beginTime;
            //保存动画最前面效果
            anim1.fillMode = kCAFillModeForwards;
            anim1.repeatCount = 0;
            [emitterLayer addAnimation:anim1 forKey:@"StopEmitter"];
            
        }
    }
    
    return emitterLayer;
}

- (CGPoint)convertPoint:(CGPoint)p withFrame:(CGRect)frame naturalSize:(CGSize )naturalSize {
    CGFloat x = naturalSize.width * (p.x / frame.size.width);
    CGFloat y = naturalSize.height * (1 -p.y / frame.size.height);
    return CGPointMake(x, y);
}

/*
 特效清空
 */
- (void)invalidate
{
    [self removeAllAnimations];
    [self removeFromSuperlayer];
}

- (void)dealloc {
    NSLog(@"%@特效清空完毕",NSStringFromClass([self class]));
}

@end
