//
//  BIRTWebViewController.h
//  Gazetteer
//
//  Created by Maitrik Patel on 7/8/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIRTChartData.h"

@interface BIRTWebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSMutableDictionary *userData;
@property (strong, nonatomic) BIRTChartData *chartData;

@property BOOL refreshView;

@end
