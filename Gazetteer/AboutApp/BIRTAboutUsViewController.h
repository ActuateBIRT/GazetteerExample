//
//  BIRTAboutUsViewController.h
//  Gazetteer
//
//  Created by Maitrik Patel on 8/6/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIRTAboutUsViewController : UIViewController <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *landscapeGlobe;
@property (strong, nonatomic) IBOutlet UIImageView *portraitGlobe;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;

@end
