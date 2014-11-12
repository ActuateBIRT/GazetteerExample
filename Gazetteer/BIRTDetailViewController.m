//
//  BIRTDetailViewController.m
//  Gazetteer
//
//  Created by Maitrik Patel on 7/1/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import "BIRTDetailViewController.h"
#import "BIRTWebViewController.h"
#import "BIRTBarChartViewController.h"
#import "BIRTColumnChartViewController.h"
#import "BIRTPieChartViewController.h"
#import "BIRTChartData.h"
#import "BIRTSplitViewController.h"
#import "BIRTAppDelegate.h"
#import "BIRTLoginViewController.h"

@interface BIRTDetailViewController ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (nonatomic, strong) UIActionSheet *actionSheet;
- (void)configureView;
@property BOOL isShowingLandscape;
@end


@implementation BIRTDetailViewController

@synthesize scrollView, pagerView;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

-(void) worldData:(NSArray *)worldData {
    self.worldData = worldData;
}

-(void) setSelectedData:(NSMutableDictionary *)selected {
    self.userData = selected;    
}

-(void) setContinentAbbs:(NSMutableDictionary *)values {
    self.contAbbs = values;
}

-(void) updateView {
    _titleLabel.text = self.userData[@"name"];
    
    
    BIRTChartData *chartData = [[BIRTChartData alloc] init];
    [chartData setWorldData:self.worldData];
    [chartData setSelectedYear:@"2000"];
    [chartData setUserName:self.userName];
    [chartData setPassword:self.password];
    [chartData setDataObjectId:_dataObjectId];
    
    if ([self.userData[@"level"] intValue] == 1) {
        [chartData setContinent:self.userData[@"name"]];
        _titleLabel.textColor = [UIColor colorWithRed:255/255.0f green:159/255.0f blue:42/255.0f alpha:1.0f];
    } else if ([self.userData[@"level"] intValue] == 2) {
        _titleLabel.textColor = [UIColor colorWithRed:102/255.0f green:170/255.0f blue:249/255.0f alpha:1.0f];
        [chartData setRegion:self.userData[@"name"]];
    } else if ([self.userData[@"level"] intValue] == 3){
        _titleLabel.textColor = [UIColor colorWithRed:42/255.0f green:186/255.0f blue:43/255.0f alpha:1.0f];
        [chartData setCountry:self.userData[@"name"]];
    } else {
        _titleLabel.textColor = [UIColor blackColor];
        [chartData setIsWorld:YES];
    }
    
    [chartData setContAbb:self.userData[@"Cont_Abb"]];
    [chartData setRegAbb:self.userData[@"Reg_Abb"]];
    [chartData setCountAbb:self.userData[@"Count_Abb"]];
    [chartData setAuthId:self.authId];
    [chartData setUserData:self.userData];
    [chartData setContAbbs:self.contAbbs];
    for (UIViewController *child in self.childViewControllers) {
        
        if ([child isKindOfClass:[BIRTColumnChartViewController class]]) {
            BIRTColumnChartViewController *chart = (BIRTColumnChartViewController *)child;
            [chart setChartData:chartData];
            [chart setRefreshView:TRUE];
            [chart viewWillAppear:YES];
        }
        
        if ([child isKindOfClass:[BIRTBarChartViewController class]]) {
            BIRTBarChartViewController *chart = (BIRTBarChartViewController *)child;
            [chart setChartData:chartData];
            [chart setRefreshView:TRUE];
            [chart viewWillAppear:YES];
            
        }
        
        if ([child isKindOfClass:[BIRTPieChartViewController class]]) {
            BIRTPieChartViewController *chart = (BIRTPieChartViewController *)child;
            [chart deleteValues];
            [chart setChartData:chartData];
            [chart setRefreshView:TRUE];
            [chart viewDidAppear:YES];            
        }
    }
    
}

- (void)viewDidLoad
{
    @try {
        
        [super viewDidLoad];
        
        
        UIDevice *device = [UIDevice currentDevice];					//Get the device object
        [device beginGeneratingDeviceOrientationNotifications];			//Tell it to start monitoring the accelerometer for orientation
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];	//Get the notification centre for the app
        [nc addObserver:self											//Add yourself as an observer
               selector:@selector(orientationChanged:)
                   name:UIDeviceOrientationDidChangeNotification
                 object:device];
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:22/255.0f green:32/255.0f blue:48/255.0f alpha:1.0f];
        
        [_seeMore setImageEdgeInsets:UIEdgeInsetsMake(-15, 20, 5, 5.0)];
        [_seeMore setImage: [UIImage imageNamed:@"details"] forState:UIControlStateNormal];
        [_seeMore setTitleEdgeInsets:UIEdgeInsetsMake(45, -25, 0, 0)];
        [_seeMore setTitle:@"DETAILS" forState:UIControlStateNormal];
        [_seeMore setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
        

        // Do any additional setup after loading the view, typically from a nib.
        [self configureView];
        pageControlBeingUsed = NO;
        
        _titleLabel.text = self.userData[@"name"];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        
        
        _seeMore.layer.borderWidth = 0.5f;
        _seeMore.layer.cornerRadius = 5;
        self.scrollView.contentSize = CGSizeMake(1350, 530);
        self.scrollView.pagingEnabled = YES;
        scrollView.delaysContentTouches = NO;
        
        
        // Pager
        [pagerView setImage:[UIImage imageNamed:@"unselected_smaller"]
           highlightedImage:[UIImage imageNamed:@"selected_smaller"]
                     forKey:@"a"];
        [pagerView setImage:[UIImage imageNamed:@"unselected_smaller"]
           highlightedImage:[UIImage imageNamed:@"selected_smaller"]
                     forKey:@"b"];
        [pagerView setImage:[UIImage imageNamed:@"unselected_smaller"]
           highlightedImage:[UIImage imageNamed:@"selected_smaller"]
                     forKey:@"c"];
        
        [pagerView setPattern:@"abcabc"];
        
        
        pagerView.delegate = self;
        scrollView.delegate = self;
        
        BOOL isLandscape = UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
        //NSLog(@"isLandscape %d", isLandscape);
        _titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:40.0];
        
        if ([self.userData[@"level"] intValue] == 1) {
            _titleLabel.textColor = [UIColor colorWithRed:255/255.0f green:159/255.0f blue:42/255.0f alpha:1.0f];
        } else if ([self.userData[@"level"] intValue] == 2) {
            _titleLabel.textColor = [UIColor colorWithRed:102/255.0f green:170/255.0f blue:249/255.0f alpha:1.0f];
        } else if ([self.userData[@"level"] intValue] == 3){
            _titleLabel.textColor = [UIColor colorWithRed:42/255.0f green:186/255.0f blue:43/255.0f alpha:1.0f];
        } else {
            _titleLabel.textColor = [UIColor colorWithRed:49/255.0f green:66/255.0f blue:88/255.0f alpha:1.0f];
        }
       
        if (isLandscape) {
           
            pagerView.frame = CGRectMake(285, 650, pagerView.frame.size.width, pagerView.frame.size.height);
            scrollView.frame = CGRectMake(125,125,scrollView.frame.size.width, scrollView.frame.size.height);
            _titleLabel.frame = CGRectMake(20,0,504,125);
            _titleLabel.textAlignment = NSTextAlignmentLeft;
            _isShowingLandscape = YES;
        } else {
            
            pagerView.frame = CGRectMake(158, 800, pagerView.frame.size.width, pagerView.frame.size.height);
            scrollView.frame = CGRectMake(0,275,scrollView.frame.size.width, scrollView.frame.size.height);
            _titleLabel.frame = CGRectMake(24,150,400,125);
            _titleLabel.textAlignment = NSTextAlignmentLeft;
            _isShowingLandscape = NO;
        }

    }
    @catch (NSException *exception) {
        //NSLog(@"Exception reason : %@", [exception reason]);
    }
    
    
}

- (void)viewDidUnload
{

    [super viewDidUnload];
    // Release any retained subviews of the main view.
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.scrollView = nil;
	self.pageControl = nil;
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if(self.actionSheet != nil) {
        [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        self.actionSheet = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*-----------------------Table View open all time---------------------*/

#pragma mark - Open TableView all time


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //[self realign:toInterfaceOrientation];
}

- (void)orientationChanged:(NSNotification *)note
{
	//NSLog(@"Orientation  has changed: %ld", [[note object] orientation]);
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) &&
        !_isShowingLandscape) {
        //NSLog(@"Change to custom UI for landscape");
        pagerView.frame = CGRectMake(285, 650, pagerView.frame.size.width, pagerView.frame.size.height);
        scrollView.frame = CGRectMake(125,125,scrollView.frame.size.width, scrollView.frame.size.height);
        _titleLabel.frame = CGRectMake(20,0,504,125);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _isShowingLandscape = YES;
        
        
    } else if (UIDeviceOrientationIsPortrait(deviceOrientation) &&
               _isShowingLandscape){
        
        //NSLog(@"Change to custom UI for portrait");
        pagerView.frame = CGRectMake(158, 800, pagerView.frame.size.width, pagerView.frame.size.height);
        scrollView.frame = CGRectMake(0,275,scrollView.frame.size.width, scrollView.frame.size.height);
        _titleLabel.frame = CGRectMake(24,150,400,125);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _isShowingLandscape = NO;
        
    }

}

- (BOOL) splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
}

/*-----------------------Insert_Object---------------------*/

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if (self.worldData != nil) {
        @try {
            BIRTChartData *chartData = [[BIRTChartData alloc] init];
            [chartData setWorldData:self.worldData];
            [chartData setSelectedYear:@"2000"];
            [chartData setUserName:self.userName];
            [chartData setPassword:self.password];
            [chartData setDataObjectId:_dataObjectId];
            
            if ([segue.identifier isEqualToString:@"showReport"]){
                UINavigationController *navigationController =  [segue destinationViewController];
                BIRTWebViewController *viewController = (BIRTWebViewController *)[navigationController topViewController];
                [viewController setUserData:self.userData];
                [viewController setChartData:chartData];
                //NSLog(@"Preparing for segue: %@", segue.identifier);
            }
            
            
            if ([self.userData[@"level"] intValue] == 1) {
                [chartData setContinent:self.userData[@"name"]];
            } else if ([self.userData[@"level"] intValue] == 2) {
                [chartData setRegion:self.userData[@"name"]];
            } else if ([self.userData[@"level"] intValue] == 3){
                [chartData setCountry:self.userData[@"name"]];
            } else {
                [chartData setIsWorld:YES];
            }
            [chartData setContAbb:self.userData[@"Cont_Abb"]];
            [chartData setRegAbb:self.userData[@"Reg_Abb"]];
            [chartData setCountAbb:self.userData[@"Count_Abb"]];
            [chartData setAuthId:self.authId];
            [chartData setUserData:self.userData];
            [chartData setContAbbs:self.contAbbs];
            
            if ([segue.identifier isEqualToString:@"columnChart"]) {
                BIRTColumnChartViewController *chart = [segue destinationViewController];
                [chart setChartData:chartData];
            }
            
            
            if ([segue.identifier isEqualToString:@"barChart"]) {
                BIRTBarChartViewController *chart = [segue destinationViewController];
                [chart setChartData:chartData];
            }
            
            if ([segue.identifier isEqualToString:@"pieChart"]) {
                BIRTBarChartViewController *chart = [segue destinationViewController];
                [chart setChartData:chartData];
            }
        }
        @catch (NSException *exception) {
            //NSLog(@"Siege failed");
        }
    }
    
}

/*-----------------------Scroll view---------------------*/

#pragma mark - Scroll view

- (IBAction)changePage {
	// Update the scroll view to the appropriate page
	CGRect frame;
	frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
	frame.origin.y = 0;
	frame.size = self.scrollView.frame.size;
	[self.scrollView scrollRectToVisible:frame animated:YES];

}

- (IBAction)buttonPressed:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Button pressed"
													message:[NSString stringWithFormat:@"You pressed the button on page %ld.", (long)[sender tag]]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
}


- (void)updatePager
{
    pagerView.page = floorf(scrollView.contentOffset.x / scrollView.frame.size.width);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePager];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self updatePager];
    }
}

- (void)pageView:(BIRTPagerView *)pageView didUpdateToPage:(NSInteger)newPage
{
    CGRect frame;
	frame.origin.x = self.scrollView.frame.size.width * pagerView.page;
	frame.origin.y = 0;
	frame.size = self.scrollView.frame.size;
	[self.scrollView scrollRectToVisible:frame animated:YES];
}

- (IBAction)logout:(id)sender {
    [self performSegueWithIdentifier:@"logout" sender:self];
}

- (IBAction)information:(id)sender {
    [self performSegueWithIdentifier:@"information" sender:self];
}

- (IBAction)showMenu:(id)sender {
    if(self.actionSheet != nil) {
        [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@""
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"About the App", @"Source Data", @"Log Out", nil];
    [self.actionSheet setBackgroundColor:[UIColor whiteColor]];
    [self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [self.actionSheet showFromBarButtonItem:(UIBarButtonItem *) sender animated:YES];
    
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:17.0];
            button.titleLabel.textColor = [UIColor blackColor];
        }
    }
}

-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    //NSLog(@"Index = %ld - Title = %@", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"information" sender:self];
    } else if (buttonIndex == 1) {
        [self performSegueWithIdentifier:@"source" sender:self];
    } else  if (buttonIndex == 2) {
       [self performSegueWithIdentifier:@"logout" sender:self];
    }
}

@end

