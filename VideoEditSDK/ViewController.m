//
//  ViewController.m
//  VideoEditSDK
//
//  Created by Hanxiaojie on 2018/3/23.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import "ViewController.h"
#import "IFVideoDefine.h"
#import "VideoFingerEffectEditVC.h"

@interface ViewController ()
{
    AVAsset *_videoAsset;
}
@property (nonatomic, strong) VideoFingerEffectEditVC *fingerEffectEditVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *videoUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"IMG_5762" ofType:@"mp4"]];
    _videoAsset = [AVAsset assetWithURL:videoUrl];
}

#pragma mark - 实例化对象
- (VideoFingerEffectEditVC*)fingerEffectEditVC{
    if (!_fingerEffectEditVC) {
        _fingerEffectEditVC = [[VideoFingerEffectEditVC alloc] initWithAsset:_videoAsset];
    }
    return _fingerEffectEditVC;
}

- (IBAction)fingerEffectEditer:(UIButton *)sender {
    
    [self.navigationController pushViewController:self.fingerEffectEditVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
