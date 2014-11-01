//
//  BIRTSourceDataViewController.h
//  Gazetteer
//
//  Created by macAd on 8/20/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIRTSourceDataViewController : UIViewController <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *landScapeImage;
@property (strong, nonatomic) IBOutlet UIImageView *portraitImage;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;

@end
