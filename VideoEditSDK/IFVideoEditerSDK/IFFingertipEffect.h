//
//  IFFingertipEffect.h
//  粒子动画
//
//  Created by Hanxiaojie on 2018/2/8.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface IFFingertipEffect : CAEmitterLayer

//特效的最后一次坐标
@property (nonatomic, assign) CGPoint lastPosition;

- (instancetype)initDefaultEmitterLayer;
- (IFFingertipEffect *)copyEffect;
- (IFFingertipEffect *)copyEffectAndAnimations;
/*
 *开始特效
 */
- (void)startEffectPosition:(CGPoint)point beginTime:(NSTimeInterval)beginTime;
/*
 *修改特效位置
 */
- (void)changeEffectPosition:(CGPoint)point beginTime:(NSTimeInterval)beginTime;
/*
*结束特效
*/
- (void)endEffectPosition:(CGPoint)point beginTime:(NSTimeInterval)beginTime;

- (IFFingertipEffect *)exportHandlerWithFrame:(CGRect)frame naturalSize:(CGSize)naturalSize;

/*
 特效清空、释放
 */
- (void)invalidate;

@end
