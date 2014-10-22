//
//  UIButton+DBPad.m
//  Dirty Bit
//
//  Created by wyudong on 14-10-9.
//  Copyright (c) 2014年 wyudong. All rights reserved.
//

#import "UIButton+DBPad.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIButton (DBPad)

- (void)setRedColorPad {
    [self setBackgroundImage:[UIImage imageNamed:@"RedPad.png"] forState:UIControlStateNormal];
}

- (void)setYellowColorPad {
    [self setBackgroundImage:[UIImage imageNamed:@"YellowPad.png"] forState:UIControlStateNormal];
}

- (void)setGreenColorPad {
    [self setBackgroundImage:[UIImage imageNamed:@"GreenPad.png"] forState:UIControlStateNormal];
}

- (void)setBlueColorPad {
    [self setBackgroundImage:[UIImage imageNamed:@"BluePad.png"] forState:UIControlStateNormal];
}

@end
