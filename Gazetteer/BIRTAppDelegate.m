//
//  BIRTAppDelegate.m
//  Gazetteer
//
//  Created by Maitrik Patel on 7/1/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import "BIRTAppDelegate.h"
#import "BIRTDetailViewController.h"

@implementation BIRTAppDelegate

@synthesize window;
@synthesize viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch
    //UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    ////NSLog(@"Lets see whats an output : %@", splitViewController.class);
    //UINavigationController *navigationsController = [splitViewController.viewControllers lastObject];
    //splitViewController.delegate = (id)navigationsController.topViewController;
    
    // Add the view controller's view to the window and display.
    application.applicationSupportsShakeToEdit = YES;
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSFontAttributeName: [UIFont fontWithName:@"Lato-Bold" size:18.0]}];
    
  
    return YES;
}

- (void)switchToLoginView
{
    [self.window reloadInputViews];
    [self.window makeKeyAndVisible];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc {
    //    [viewController release];
    //    [window release];
    //    [super dealloc];
}


@end

//Make Status Bar details white

@interface UINavigationController (StatusBarStyle)

@end

@implementation UINavigationController (StatusBarStyle)
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end

