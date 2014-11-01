//
//  BIRTUISlider.m
//  Gazetteer
//
//  Created by macAd on 8/4/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import "BIRTUISlider.h"

@implementation BIRTUISlider
#define SIZE_EXTENSION_Y -30
#define SIZE_EXTENSION_X -30

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, SIZE_EXTENSION_X, SIZE_EXTENSION_Y);
    return CGRectContainsPoint(bounds, point);
}

@end
