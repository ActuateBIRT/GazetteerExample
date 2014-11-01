//
//  BIRTPopupViewController.h
//  Gazetteer
//
//  Created by macAd on 8/21/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BIRTPopupViewControllerDelegate
-(void)dataChanged:(NSString *)restApiUrl webUrl:(NSString *)webUrl;

@end

@interface BIRTPopupViewController : UIViewController <UITextFieldDelegate>


@property (nonatomic, strong) id<BIRTPopupViewControllerDelegate> delegate;


@property (weak, nonatomic) IBOutlet UITextField *serverUrl;

@property (weak, nonatomic) IBOutlet UITextField *restApiUrl;
- (IBAction)done:(id)sender;
@end
