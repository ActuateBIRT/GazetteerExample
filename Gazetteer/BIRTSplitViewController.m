//
//  BIRTSplitViewController.m
//  Gazetteer
//
//  Created by Maitrik Patel on 7/8/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import "BIRTSplitViewController.h"
#import "BIRTWebViewController.h"
#import "BIRTMasterViewController.h"
#import "BIRTDetailViewController.h"

@interface BIRTSplitViewController ()

@end

@implementation BIRTSplitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToView:(UIStoryboardSegue *)segue {
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;	
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
@interface UINavigationController (StatusBarStyle)

@end

@implementation UINavigationController (StatusBarStyle)
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end