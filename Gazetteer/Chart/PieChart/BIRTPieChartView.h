//
//  BIRTPieChartView.h
//  Gazetteer
//
//  Created by Maitrik Patel on 7/23/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PieLayer;

@interface BIRTPieChartView : UIView

@end

@interface BIRTPieChartView (ex)
@property(nonatomic,readonly,retain) PieLayer *layer;
- (void) removeLabel;

@end
