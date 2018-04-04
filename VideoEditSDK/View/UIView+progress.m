//
//  UIView+progress.m
//  VideoEditSDK
//
//  Created by Hanxiaojie on 2018/3/23.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import "UIView+progress.h"

@implementation UIView (progress)
+ (void)showProgressWithText:(NSString*)text {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.detailsLabel.text = text;
}


+ (void)hiddenProgress {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}
@end
