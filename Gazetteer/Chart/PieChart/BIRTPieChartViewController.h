//
//  BIRTPieChartViewController.h
//  Gazetteer
//
//  Created by Maitrik Patel on 7/18/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BIRTChartData.h"
@interface BIRTPieChartViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) BIRTChartData *chartData;
@property (strong, nonatomic) NSString *selectedYear;
@property (weak, nonatomic) IBOutlet UISlider *timeLine;
@property (weak, nonatomic) IBOutlet UILabel *timeLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *noData;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property BOOL refreshView;
-(void) deleteValues;
@end
