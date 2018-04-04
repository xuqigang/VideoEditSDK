//
//  ISVWarningView.m
//  IfengSmallVideo
//
//  Created by Hanxiaojie on 2018/3/6.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import "ISVWarningView.h"

@implementation ISVWarningView

+ (void)showWarning:(UIViewController*) delegate Message:(NSString*)title leftTitle:(NSString*)leftTitle rightTitle:(NSString*)rightTitle leftAction:(void (^)(void))leftAction rightAction:(void(^)(void))rightAction
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:title
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:leftTitle style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              leftAction ? leftAction() : nil;
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             rightAction ? rightAction() : nil;
                                                         }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    if ([delegate isKindOfClass:[UIViewController class]]) {
        [delegate presentViewController:alert animated:YES completion:nil];
    } else {
        NSLog(@"ISVWarningView delegate 必须是UIViewController类型");
    }
   
}

@end
