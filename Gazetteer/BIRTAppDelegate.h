//
//  BIRTAppDelegate.h
//  Gazetteer
//
//  Created by Maitrik Patel on 7/1/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BIRTDetailViewController;

@interface BIRTAppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow *window;
    BIRTDetailViewController *viewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet BIRTDetailViewController  *viewController;

- (void)switchToLoginView;

@end
