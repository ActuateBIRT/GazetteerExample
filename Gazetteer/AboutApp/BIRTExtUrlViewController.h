//
//  BIRTExtUrlViewController.h
//  Gazetteer
//
//  Created by macAd on 8/14/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIRTExtUrlViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURL *url;

@end
