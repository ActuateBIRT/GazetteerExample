//
//  BIRTLoginViewController.h
//  Gazetteer
//
//  Created by macAd on 7/9/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIRTPopupViewController.h"


@interface BIRTLoginViewController : UIViewController <UITextFieldDelegate, BIRTPopupViewControllerDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *appLogo;
@property (strong, nonatomic) IBOutlet UILabel *appTitle;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;
@property (strong, nonatomic) IBOutlet UILabel *loadingTitle;
@property (strong, nonatomic) NSString* authId;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIButton *popoverIcon;

-(IBAction)enter:(id)sender;

@end
