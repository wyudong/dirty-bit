//
//  ViewController.h
//  Dirty Bit
//
//  Created by wyudong on 14-10-9.
//  Copyright (c) 2014年 wyudong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TheAmazingAudioEngine.h"
#import "AERecorder.h"

#define kPadColumns 8
#define kPadRows 4
#define kPadSizePad 87
#define kPadSizePhone 48
#define kButtonSizePad 48
#define kButtonSizePhone 30

@class AEAudioController;

@interface ViewController : UIViewController {
    UIButton *DBPads[kPadColumns][kPadRows];
    CGFloat screenWidth;
    CGFloat screenHeight;
}

@property (nonatomic, strong) AEAudioController *audioController;
@property (nonatomic, strong) AEAudioFilePlayer *sample;
@property (nonatomic, strong) AEAudioFilePlayer *backgroundMusic1;
@property (nonatomic, strong) AEAudioFilePlayer *backgroundMusic2;
@property (nonatomic, strong) AEAudioFilePlayer *backgroundMusic3;
@property (nonatomic, strong) AERecorder *recorder;
@property (nonatomic, strong) AEAudioFilePlayer *player;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *playButton;

- (id)initWithAudioController:(AEAudioController*)audioController;

@end
