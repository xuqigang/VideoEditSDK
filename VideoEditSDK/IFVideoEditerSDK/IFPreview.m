//
//  IFPreview.m
//  粒子动画
//
//  Created by Hanxiaojie on 2018/2/8.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import "IFPreview.h"

@interface IFPreview ()

{
    UIPanGestureRecognizer *_panGestureRecognizer;
    NSTimeInterval _lastPanGestureRecognizerTime;
}

@end

@implementation IFPreview

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.fingertipEnable = NO;
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerCicked:)];
        _lastPanGestureRecognizerTime = NSTimeIntervalSince1970;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        
    }
    return self;
}

- (void)setFingertipEnable:(BOOL)fingertipEnable {
    _fingertipEnable = fingertipEnable;
    _fingertipEnable ? [self addGestureRecognizer:_panGestureRecognizer] : [self removeGestureRecognizer:_panGestureRecognizer];
}

#pragma mark 手势拖动事件
- (void)panGestureRecognizerCicked:(UIPanGestureRecognizer*)pan
{
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    
    if ( !_delegate || (currentTime - _lastPanGestureRecognizerTime < 0.02 && pan.state == UIGestureRecognizerStateChanged)) {
        return;
    }
    _lastPanGestureRecognizerTime = currentTime;
    
    CGPoint curPosition = [pan locationInView:self];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"UIGestureRecognizerStateBegan");
            if ([_delegate respondsToSelector:@selector(preview:startDragAtPosition:)]) {
                [_delegate preview:self startDragAtPosition:curPosition];
            }
            break;
        case UIGestureRecognizerStateChanged:
            NSLog(@"UIGestureRecognizerStateChanged");
            if ([_delegate respondsToSelector:@selector(preview:changeDragAtPosition:)]) {
                [_delegate preview:self changeDragAtPosition:curPosition];
            }
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"UIGestureRecognizerStateEnded");
            if ([_delegate respondsToSelector:@selector(preview:endDragAtPosition:) ]) {
                [_delegate preview:self endDragAtPosition:curPosition];
            }
            break;
        default:
            NSLog(@"UIGestureRecognizerStateDefault");
            if ([_delegate respondsToSelector:@selector(preview:endDragAtPosition:) ]) {
                [_delegate preview:self endDragAtPosition:curPosition];
            }
            break;
    }
}


@end
