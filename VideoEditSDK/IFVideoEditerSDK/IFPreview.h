//
//  IFPreview.h
//  粒子动画
//
//  Created by Hanxiaojie on 2018/2/8.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IFPreview;

@protocol IFPreviewDelegate <NSObject>

- (void)preview:(IFPreview*)preview startDragAtPosition:(CGPoint) position;
- (void)preview:(IFPreview*)preview changeDragAtPosition:(CGPoint) position;
- (void)preview:(IFPreview*)preview endDragAtPosition:(CGPoint) position;

@end

@interface IFPreview : UIView

@property (nonatomic, weak) id<IFPreviewDelegate> delegate;
@property (nonatomic, assign) BOOL fingertipEnable;

- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER; 


@end
