//
//  ISVWarningView.h
//  IfengSmallVideo
//
//  Created by Hanxiaojie on 2018/3/6.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISVWarningView : UIView

+ (void)showWarning:(UIViewController*) delegate Message:(NSString*)title leftTitle:(NSString*)leftTitle rightTitle:(NSString*)rightTitle leftAction:(void (^)(void))leftAction rightAction:(void(^)(void))rightAction;


@end
