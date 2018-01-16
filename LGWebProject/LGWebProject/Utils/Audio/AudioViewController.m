//
//  AudioViewController.m
//  IOSHorienMallProject
//
//  Created by iOSgo on 2017/8/23.
//  Copyright © 2017年 敲代码mac1号. All rights reserved.
//

#import "AudioViewController.h"
#import "SYAudio.h"

@interface AudioViewController ()

@property (nonatomic, strong) NSString *filePath;

@end

@implementation AudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"录音";
    
    [self setUI];
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-backkkkkk@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
}

- (void)backAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)setUI {
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    backBtn.frame = CGRectMake(0, 20, 44.0, 44.0);
    [backBtn setImage:[UIImage imageNamed:@"icon-backkkkkk@2x"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(10.0, (CGRectGetHeight(self.view.bounds) - 10.0 - 40.0), (CGRectGetWidth(self.view.bounds) - 10.0 * 2), 40.0);
    button.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    [button setTitle:@"按下开始录音" forState:UIControlStateNormal];
    [button setTitle:@"正在录音 释放停止录音" forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    // 录音响应
    [button addTarget:self action:@selector(recordStartButtonDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(recordStopButtonUp:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(recordStopButtonExit:) forControlEvents:UIControlEventTouchDragExit];
    
}

- (void)recordStartButtonDown:(UIButton *)button
{
    [self startRecorder];
}

- (void)recordStopButtonUp:(UIButton *)button
{
    [self saveRecorder];
}

- (void)recordStopButtonExit:(UIButton *)button
{
    [self saveRecorder];
}


#pragma mark - 音频处理方法

// 开始录音
- (void)startRecorder
{
    self.filePath = [SYAudioFile SYAudioGetFilePathWithDate];
    [[SYAudio shareAudio] audioRecorderStartWithFilePath:self.filePath];
}

// 停止录音，并保存
- (void)saveRecorder
{
    [[SYAudio shareAudio] audioRecorderStop];
    
    // 保存音频信息
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.filePath forKey:@"FilePath"];
    NSString *fileName = [SYAudioFile SYAudioGetFileNameWithFilePath:self.filePath type:YES];
    [dict setValue:fileName forKey:@"FileName"];
    long long fileSize = [SYAudioFile SYAudioGetFileSizeWithFilePath:self.filePath];
    [dict setValue:@(fileSize) forKey:@"FileSize"];
    NSTimeInterval fileTime = [[SYAudio shareAudio] durationAudioRecorderWithFilePath:self.filePath];
    [dict setValue:@(fileTime) forKey:@"FileTime"];
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.getFilepath(self.filePath);
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}


@end
