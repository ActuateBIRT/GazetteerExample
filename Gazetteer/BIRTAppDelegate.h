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

@implementation NSNull (JSON)

-(NSUInteger) length { return 0; }

-(NSInteger) integerValue { return 0; }

-(NSString*) stringValue { return nil; }

-(NSNumber*) numberValue { return nil; }

-(float) floatValue { return 0; }

-(double) doubleValue { return 0; }

-(BOOL) boolValue { return NO; }

-(int) intValue { return 0; }

-(long) longValue { return 0; }

-(long long) longLongValue { return 0; }

-(unsigned long long) unsignedLongLongValue {
    return 0;
}

@end
