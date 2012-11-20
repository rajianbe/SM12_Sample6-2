//
//  ViewController.m
//  Sample6-2
//
//  Created by abe on 2012/11/20.
//  Copyright (c) 2012年 abe. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

static const int FILE_NUM = 6;
static NSString *fileNames[FILE_NUM] = {
    @"format.wav",
    @"format16-22k-2.wav",
    @"format16-22k-1.wav",
    @"format16-22k-2.aiff",
    @"format16-22k-2.caf",
    @"format.mp4",
};


@interface ViewController ()
{
    AVAudioPlayer *m_audio[FILE_NUM];
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    for ( int i=0; i<FILE_NUM; i++ ) {
        // ボタン生成
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:fileNames[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake( i / 8 * 65 + 2,
                               i % 8 * 50 + 60,
                               0, 0 );
        [btn sizeToFit];
        btn.center = CGPointMake( 160, i * 60 + 30 );
        btn.tag = i;
        [btn addTarget:self
                action:@selector(pushBtn:)
      forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:btn];
        
        // サウンド読み込み
        // ファイル名から拡張子を除いた名前のみ取得
        NSString *name = [fileNames[i] stringByDeletingPathExtension];
        // ファイル名から拡張子だけを取得
        NSString *type = [fileNames[i] pathExtension];
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
        NSURL *url = [NSURL fileURLWithPath:path];
        m_audio[i] = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    }
    
    
    // AudioSession取得
    AVAudioSession *session = [AVAudioSession sharedInstance];
    // カテゴリ設定
    [session setCategory:AVAudioSessionCategoryAmbient error:nil];
    // 設定の反映
    [session setActive:YES error:nil];
    
    // 他アプリでのサウンド再生状態取得
    Class name = NSClassFromString(@"AVAudioSession");
    if ( [name instancesRespondToSelector:@selector(isOtherAudioPlaying)] ) {
        if ( [session isOtherAudioPlaying] ) {
            NSLog(@"他アプリでサウンド再生中です。");
        }else {
            NSLog(@"他アプリでサウンドは再生していません。");
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushBtn:(id)sender
{
    // 再生中のサウンドを一旦全て停止、先頭に戻す
    for ( int i=0; i<FILE_NUM; i++ ) {
        [m_audio[i] stop];
        [m_audio[i] setCurrentTime:0];
    }
    // 該当サウンド再生
    [m_audio[[sender tag]] play];
}

- (void)dealloc
{
    // サウンド解放
    for ( int i=0; i<FILE_NUM; i++ ) {
        [m_audio[i] release];
    }
    
    [super dealloc];
}

@end
