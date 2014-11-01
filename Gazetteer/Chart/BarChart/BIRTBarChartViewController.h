//
//  BIRTBarChartViewController.h
//  Gazetteer
//
//  Created by Maitrik Patel on 7/18/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIRTChartData.h"

@interface BIRTBarChartViewController : UIViewController <UIAlertViewDelegate, UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *BarChartWebView;
@property (strong, nonatomic) BIRTChartData *chartData;

@property BOOL refreshView;
@end
