//
//  ViewController.m
//  Dirty Bit
//
//  Created by wyudong on 14-10-9.
//  Copyright (c) 2014年 wyudong. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+DBPad.h"
#import "TheAmazingAudioEngine.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

-(NSUInteger)supportedInterfaceOrientations
{
    return (1 << UIInterfaceOrientationLandscapeLeft) | (1 << UIInterfaceOrientationLandscapeRight);
}

- (id)initWithAudioController:(AEAudioController*)audioController
{
    self.audioController = audioController;
    
    // Check that the engine has successfully started.
    NSError *error = NULL;
    BOOL result = [audioController start:&error];
    if ( !result ) {
        NSLog(@"The Amazing Audio Engine didn't start!");
    }
    else {
        NSLog(@"The Amazing Audio Engine started perfectly!");
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:33/255.0 green:41/255.0 blue:48/255.0 alpha:1.0];
    
    // Get screen width and height (should consider the orientation)
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.height;
    screenHeight = screenRect.size.width;
    
    // Setup pads, record and play buttons
    [self placeDBPads];
    [self placeRecordButton];
    [self placePlayButton];
    
    // Create an instance of the audio controller, set it up and start it running
    self.audioController = [[AEAudioController alloc] initWithAudioDescription:[AEAudioController nonInterleaved16BitStereoAudioDescription] inputEnabled:YES];
    _audioController.preferredBufferDuration = 0.005;
    _audioController.useMeasurementMode = YES;
    [_audioController start:NULL];
}

- (void)placeDBPads
{
    // http://conecode.com/news/2012/05/ios-how-to-create-a-grid-of-uibuttons/
    NSInteger padTag = 0;
    NSInteger leftMargin;
    NSInteger topMargin;
    NSInteger xSpacing;
    NSInteger ySpacing;
    NSInteger xCoordinate;
    NSInteger yCoordinate;
    NSInteger padSize;

    leftMargin = screenWidth * 0.06;
    topMargin = screenHeight * 0.13;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // Place iPhone/iPod specific code here
        xSpacing = kPadSizePhone + 10;
        ySpacing = kPadSizePhone + 10;
        padSize = kPadSizePhone;
    }
    else {
        // Place iPad-specific code here
        xSpacing = kPadSizePad + 20;
        ySpacing = kPadSizePad + 20;
        padSize = kPadSizePad;
    }

    for (int y = 0; y < kPadRows; y++) {
        for (int x = 0; x < kPadColumns; x++) {
            xCoordinate = (x * xSpacing) + leftMargin;
            yCoordinate = (y * ySpacing) + topMargin;

            DBPads[x][y] = [[UIButton alloc] initWithFrame:CGRectMake(xCoordinate, yCoordinate, padSize, padSize)];
            DBPads[x][y].tag = padTag;
            padTag++;
            [DBPads[x][y] addTarget:self action:@selector(DBPadPressed:) forControlEvents:UIControlEventTouchUpInside];
            switch (y) {
                case 0:
                    [DBPads[x][y] setRedColorPad];
                    break;
                case 1:
                    [DBPads[x][y] setYellowColorPad];
                    break;
                case 2:
                    [DBPads[x][y] setGreenColorPad];
                    break;
                case 3:
                    [DBPads[x][y] setBlueColorPad];
                    break;
                default : 
                    break;
            }
            
            [self.view addSubview:DBPads[x][y]];          
        }
    }
}

- (void)placeRecordButton
{
    NSInteger xCoordinate = screenWidth * 0.9;
    NSInteger yCoordinate = screenHeight * 0.13;

    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // Place iPhone/iPod specific code here
        _recordButton.frame = CGRectMake(xCoordinate, yCoordinate, kButtonSizePhone, kButtonSizePhone);
    }
    else {
        // Place iPad-specific code here
        _recordButton.frame = CGRectMake(xCoordinate, yCoordinate, kButtonSizePad, kButtonSizePad);
    }
    [_recordButton setBackgroundImage:[UIImage imageNamed:@"RecordButton.png"] forState:UIControlStateNormal];
    [_recordButton setBackgroundImage:[UIImage imageNamed:@"StopButton.png"] forState:UIControlStateSelected];
    [_recordButton addTarget:self action:@selector(record:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recordButton];
}

- (void)placePlayButton
{
    NSInteger xCoordinate = screenWidth * 0.9;
    NSInteger yCoordinate = screenHeight * 0.26;
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // Place iPhone/iPod specific code here
        _playButton.frame = CGRectMake(xCoordinate, yCoordinate, kButtonSizePhone, kButtonSizePhone);
    }
    else {
        // Place iPad-specific code here
        _playButton.frame = CGRectMake(xCoordinate, yCoordinate, kButtonSizePad, kButtonSizePad);
    }
    [_playButton setBackgroundImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"StopButton.png"] forState:UIControlStateSelected];
    [_playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
}

- (void)DBPadPressed:(UIButton *)button
{
    NSLog(@"Pad %tu", button.tag);
    
    switch (button.tag) {
        case 0:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"Do"withExtension:@"wav"]
                                                  audioController:_audioController
                                                            error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 1:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"Re"withExtension:@"wav"]
                                                  audioController:_audioController
                                                            error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 2:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"Mi"withExtension:@"wav"]
                                                  audioController:_audioController
                                                            error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 3:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"Fa"withExtension:@"wav"]
                                                  audioController:_audioController
                                                            error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 4:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"So"withExtension:@"wav"]
                                                  audioController:_audioController
                                                            error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 5:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"La"withExtension:@"wav"]
                                                  audioController:_audioController
                                                            error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 6:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"Ti"withExtension:@"wav"]
                                                  audioController:_audioController
                                                            error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 7:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"HigherDo"withExtension:@"wav"]
                                                  audioController:_audioController
                                                            error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 8:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"DoubleBassC3"withExtension:@"wav"]
                                                    audioController:_audioController
                                                              error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 9:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"DoubleBassD3"withExtension:@"wav"]
                                                    audioController:_audioController
                                                              error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 10:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"DoubleBassE3"withExtension:@"wav"]
                                                    audioController:_audioController
                                                              error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 11:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"DoubleBassF3"withExtension:@"wav"]
                                                    audioController:_audioController
                                                              error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 12:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"DoubleBassG3"withExtension:@"wav"]
                                                    audioController:_audioController
                                                              error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 13:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"DoubleBassA3"withExtension:@"wav"]
                                                    audioController:_audioController
                                                              error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 14:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"DoubleBassB3"withExtension:@"wav"]
                                                    audioController:_audioController
                                                              error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 15:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"DoubleBassC4"withExtension:@"wav"]
                                                    audioController:_audioController
                                                              error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 16:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"Jump"withExtension:@"wav"]
                                                    audioController:_audioController
                                                              error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 17:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"Stomp"withExtension:@"wav"]
                                                    audioController:_audioController
                                                              error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 18:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"Coin"withExtension:@"wav"]
                                                    audioController:_audioController
                                                              error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 19:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"PowerUp"withExtension:@"wav"]
                                                    audioController:_audioController
                                                              error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 20:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"Bump"withExtension:@"wav"]
                                                    audioController:_audioController
                                                              error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 21:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"MarioDie"withExtension:@"wav"]
                                                    audioController:_audioController
                                                              error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 22:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"Flagpole"withExtension:@"wav"]
                                                    audioController:_audioController
                                                              error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 23:
            self.sample = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"StageClear"withExtension:@"wav"]
                                                    audioController:_audioController
                                                              error:NULL];
            _sample.removeUponFinish = YES;
            [_audioController addChannels:[NSArray arrayWithObject:_sample]];
            break;
        case 24:
            if (_backgroundMusic1) {
                [_audioController removeChannels:@[_backgroundMusic1]];
                self.backgroundMusic1 = nil;
            }
            else {
                self.backgroundMusic1 = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"OdetoJoy" withExtension:@"mp3"]
                                                                 audioController:_audioController
                                                                           error:NULL];
                _backgroundMusic1.removeUponFinish = YES;
                [_audioController addChannels:@[_backgroundMusic1]];
            }
            break;
        case 25:
            if (_backgroundMusic2) {
                [_audioController removeChannels:@[_backgroundMusic2]];
                self.backgroundMusic2 = nil;
            }
            else {
                self.backgroundMusic2 = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"DoReMi" withExtension:@"mp3"]
                                                                  audioController:_audioController
                                                                            error:NULL];
                _backgroundMusic2.removeUponFinish = YES;
                [_audioController addChannels:@[_backgroundMusic2]];
            }
            break;
        case 26:
            if (_backgroundMusic3) {
                [_audioController removeChannels:@[_backgroundMusic3]];
                self.backgroundMusic3 = nil;
            }
            else {
                self.backgroundMusic3 = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"SuperMarioBrosFull" withExtension:@"mp3"]
                                                                  audioController:_audioController
                                                                            error:NULL];
                _backgroundMusic3.removeUponFinish = YES;
                [_audioController addChannels:@[_backgroundMusic3]];
            }
            break;
        default :
            break;
    }
}

- (void)record:(id)sender
{
    if (_recorder) {
        [_recorder finishRecording];
        [_audioController removeOutputReceiver:_recorder];
        [_audioController removeInputReceiver:_recorder];
        self.recorder = nil;
        _recordButton.selected = NO;
        
    }
    else {
        if (_playButton.selected) {
            [_audioController removeChannels:@[_player]];
            self.player = nil;
            _playButton.selected = NO;
        }
        self.recorder = [[AERecorder alloc] initWithAudioController:_audioController];
        NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording.wav"];
        NSError *error = nil;
        if (![_recorder beginRecordingToFileAtPath:path fileType:kAudioFileWAVEType error:&error]) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:[NSString stringWithFormat:@"Couldn't start recording: %@", [error localizedDescription]]
                                       delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil] show];
            self.recorder = nil;
            return;
        }
        
        _recordButton.selected = YES;
        
        [_audioController addOutputReceiver:_recorder];
        [_audioController addInputReceiver:_recorder];
    }
}

- (void)play:(id)sender
{
    if (_player) {
        [_audioController removeChannels:@[_player]];
        self.player = nil;
        _playButton.selected = NO;
    }
    else {
        if (_recordButton.selected) {
            [_recorder finishRecording];
            [_audioController removeOutputReceiver:_recorder];
            [_audioController removeInputReceiver:_recorder];
            self.recorder = nil;
            _recordButton.selected = NO;
        }
        NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording.wav"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) return;
        
        NSError *error = nil;
        self.player = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath:path]
                                                audioController:_audioController
                                                          error:&error];
        
        if (!_player) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:[NSString stringWithFormat:@"Couldn't start playback: %@", [error localizedDescription]]
                                       delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil] show];
            return;
        }
        
        _player.removeUponFinish = YES;
        [_audioController addChannels:@[_player]];
        
        _playButton.selected = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
