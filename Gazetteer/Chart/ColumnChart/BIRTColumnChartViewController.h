//
//  BIRTColumnChartViewController.h
//  Gazetteer
//
//  Created by Maitrik Patel on 7/18/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EColumnChart.h"
#import "BIRTChartData.h"


@interface BIRTColumnChartViewController : UIViewController <EColumnChartDelegate, EColumnChartDataSource, UIAlertViewDelegate>

@property (strong, nonatomic) EColumnChart *eColumnChart;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) BIRTChartData *chartData;
@property (strong, nonatomic) NSString *selectedYear;
@property (strong, nonatomic) IBOutlet UISlider *timeLine;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property BOOL refreshView;

-(void) reloadData;


@end
