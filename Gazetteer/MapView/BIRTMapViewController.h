//
//  BIRTMapViewController.h
//  Gazetteer
//
//  Created by macAd on 8/27/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIRTChartData.h"

@interface BIRTMapViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) BIRTChartData *chartData;

@end
