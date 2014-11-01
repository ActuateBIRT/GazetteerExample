//
//  BIRTPieChartView.m
//  Gazetteer
//
//  Created by Maitrik Patel on 7/23/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import "BIRTPieChartView.h"
#import "MagicPieLayer.h"
#import "BIRTPieElement.h"

@interface BIRTPieChartView()

@property (nonatomic, strong) UILabel *floatLabel;
@end

@implementation BIRTPieChartView

+ (Class)layerClass
{
    return [PieLayer class];
}

- (id)init
{
    self = [super init];
    if(self){
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.layer.maxRadius = 100;
    self.layer.minRadius = 0;
    self.layer.animationDuration = 0.6;
    self.layer.showTitles = ShowTitlesIfEnable;
    if ([self.layer.self respondsToSelector:@selector(setContentsScale:)])
    {
        self.layer.contentsScale = [[UIScreen mainScreen] scale];
    }
   
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)handleTap:(UITapGestureRecognizer*)tap
{
    
    if(tap.state != UIGestureRecognizerStateEnded)
        return;
    
    CGPoint pos = [tap locationInView:tap.view];
    BIRTPieElement*  tappedElem= (BIRTPieElement *)[self.layer pieElemInPoint:pos];
    if(!tappedElem)
        return;
    
    if(tappedElem.centrOffset > 0)
        tappedElem = nil;
        [BIRTPieElement animateChanges:^{
        for(BIRTPieElement* elem in self.layer.values){
            elem.centrOffset = tappedElem==elem? 20 : 0;
        }
    }];
    [self removeLabel];
    
    if (tappedElem.val != 0.0f) {
        _floatLabel = [[UILabel alloc] initWithFrame:CGRectMake(pos.x - 10 , pos.y - 10, 50,20)];
        [_floatLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:15.0]];
        _floatLabel.text = [NSString stringWithFormat:@"%.1f %@",tappedElem.val, @"%"];
        _floatLabel.textColor = [UIColor blackColor];
        _floatLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_floatLabel];
    }

      
}

-(void) removeLabel{
    if (_floatLabel != nil) {
        [_floatLabel removeFromSuperview];
        _floatLabel = nil;
    }
}

@end
