//
//  ISVVideoEffectEditVC.m
//  IfengSmallVideo
//
//  Created by Hanxiaojie on 2018/2/27.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import "VideoFingerEffectEditVC.h"
#import "ISVWarningView.h"
@interface VideoFingerEffectEditVC ()<IFPreviewDelegate>
{
    AVAsset* _videoAsset;  //视频编辑资源
}


@property (nonatomic, strong) IFVideoEditor *videoEditor;
@property (nonatomic, strong) IFPreview *videoPreview;
@property (nonatomic, strong) IFFingertipEffect *currentSelectedEffect;

@end

@implementation VideoFingerEffectEditVC

- (id)initWithAsset:(AVAsset*)asset
{
    self = [super init];
    if (self) {
        _videoAsset = asset;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupVideoSDK];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.videoEditor play];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void) setupUI
{
    self.videoPreview = [[IFPreview alloc] initWithFrame:self.view.bounds];
    self.videoPreview.delegate = self;
    self.videoPreview.fingertipEnable = YES;
    [self.view addSubview:self.videoPreview];
    
    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backupButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(statusHeight + 10);
        make.size.mas_equalTo(CGSizeMake(50, 26));
    }];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishButton setTitle:@"保存" forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(finishButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishButton];
    [finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(statusHeight + 10);
        make.size.mas_equalTo(CGSizeMake(50, 26));
    }];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton setTitle:@"撤销" forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-49);
        make.size.mas_equalTo(CGSizeMake(50, 26));
    }];
    
}
- (void) setupVideoSDK {
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:_videoAsset];
    self.videoEditor = [[IFVideoEditor alloc] initWithPlayerItem:playerItem preview:self.videoPreview];
    self.currentSelectedEffect = [[IFFingertipEffect alloc] initDefaultEmitterLayer];
    [self.videoEditor setupCurrentUsingEffect:self.currentSelectedEffect];
}
- (void)setupVideoAsset:(AVAsset*)asset
{
    _videoAsset = asset;
    [self setupVideoSDK];
    
}

#pragma mark -----点击事件--------
- (void) backupButtonClicked:(UIButton *) button
{
    [ISVWarningView showWarning:self Message:@"是否保存已添加的特效?" leftTitle:@"不保存" rightTitle:@"保存" leftAction:^{
        if (_delegate && [_delegate respondsToSelector:@selector(videoFingerEffectVcDidBack:)]) {
            [_delegate videoFingerEffectVcDidBack:self];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } rightAction:^{
        [self finishButtonClicked:nil];
    }];
    
}
- (void) finishButtonClicked:(UIButton *) button
{
    [MBProgressHUD showProgressWithText:@"正在保存....."];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(videoFingerEffectVcDidFinish:savedEffects:)]) {
            [weakSelf.delegate videoFingerEffectVcDidFinish:self savedEffects:self.videoEditor.savedFingertipEffects];
        }
        [MBProgressHUD hiddenProgress];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    });
}

- (void)deleteButtonClicked:(UIButton*)button
{
    [self.videoEditor removeLastFingertipEffect];
}

@end
