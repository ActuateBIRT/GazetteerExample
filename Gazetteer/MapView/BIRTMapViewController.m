//
//  BIRTMapViewController.m
//  Gazetteer
//
//  Created by macAd on 8/27/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import "BIRTMapViewController.h"

@interface BIRTMapViewController ()

@property BOOL logout;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIButton *detailsBtn;
@property BOOL isShowingLandscape;
@end

@implementation BIRTMapViewController
@synthesize webView;
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
    UIDevice *device = [UIDevice currentDevice];					//Get the device object
    [device beginGeneratingDeviceOrientationNotifications];			//Tell it to start monitoring the accelerometer for orientation
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];	//Get the notification centre for the app
    [nc addObserver:self											//Add yourself as an observer
           selector:@selector(orientationChanged:)
               name:UIDeviceOrientationDidChangeNotification
             object:device];

    // Do any additional setup after loading the view.
    self.webView.delegate = self;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:22/255.0f green:32/255.0f blue:48/255.0f alpha:1.0f];
    [self createNavigationItem:NO];
    
    [self updateDetailsBtn];
    
    [self.view insertSubview:self.detailsBtn atIndex:10];
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.bounces = NO;
    [self loadHTML:@"index.html"];
    
}


- (IBAction)showReport:(id)sender {
    
    [self.detailsBtn removeFromSuperview];
    self.detailsBtn = nil;
    
    [self createNavigationItem:YES];
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@();",@"loadReport"] ];
    
}

- (void)orientationChanged:(NSNotification *)note
{
	UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) &&
        !_isShowingLandscape) {
        //NSLog(@"Change to custom UI for landscape");
        self.detailsBtn.frame = CGRectMake(840, 550, 150, 125);

        _isShowingLandscape = YES;
        
    } else if (UIDeviceOrientationIsPortrait(deviceOrientation) &&
               _isShowingLandscape){
        
        //NSLog(@"Change to custom UI for portrait");
        self.detailsBtn.frame = CGRectMake(610, 820, 150, 125);
        _isShowingLandscape = NO;
        
    }

}


- (IBAction)backToMap:(id)sender {
    
    [self createNavigationItem:NO];
    [self updateDetailsBtn];
    
}


-(void) updateDetailsBtn {
    self.detailsBtn =[[UIButton alloc] init];
    [self.detailsBtn addTarget:self action:@selector(showReport:) forControlEvents:UIControlEventTouchUpInside];
    
    BOOL islandscape =  UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    if (islandscape) {
        self.detailsBtn.frame = CGRectMake(840, 550, 150, 125);
        _isShowingLandscape = YES;
    } else {
        self.detailsBtn.frame = CGRectMake(610, 820, 150, 125);
    }
    
    [self.detailsBtn setImageEdgeInsets:UIEdgeInsetsMake(-15, 20, 5, 5.0)];
    [self.detailsBtn setImage: [UIImage imageNamed:@"details-larger"] forState:UIControlStateNormal];
    [self.detailsBtn setTitleEdgeInsets:UIEdgeInsetsMake(100, -110, 0, 0)];
    [self.detailsBtn setTitle:@"DETAILS" forState:UIControlStateNormal];
    [self.detailsBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    
    
    
    [self.view insertSubview:self.detailsBtn atIndex:10];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@();",@"goBack"] ];

}


-(void) createNavigationItem: (BOOL)back {
    if (back) {
        UIButton *backButton =[[UIButton alloc] init];
        [backButton  setTitle:@"Back" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backToMap:) forControlEvents:UIControlEventTouchUpInside];
        backButton.frame = CGRectMake(0, 0, 50, 15);
        backButton.titleLabel.font = [UIFont systemFontOfSize:15];
        backButton.tintColor = [UIColor whiteColor];
        
        self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:[[UIBarButtonItem alloc] initWithCustomView:backButton ],nil];
    } else {
        UIButton *listViewHighButton =[[UIButton alloc] init];
        [listViewHighButton setBackgroundImage:[UIImage imageNamed:@"list-view-unselected"] forState:UIControlStateNormal];
        [listViewHighButton addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
        listViewHighButton.frame = CGRectMake(0, 0, 50, 21);
        
        UIImageView *dividerImage = [[UIImageView alloc] initWithFrame:CGRectMake(68, 0, 10, 21)];
        dividerImage.image = [UIImage imageNamed:@"separator"];
        
        UIImageView *mapViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(95, 0, 62, 21)];
        mapViewImage.image = [UIImage imageNamed:@"map-view-selected"];
        
        
        
        self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:[[UIBarButtonItem alloc] initWithCustomView:listViewHighButton ],[[UIBarButtonItem alloc] initWithCustomView:dividerImage ], [[UIBarButtonItem alloc] initWithCustomView:mapViewImage ],nil];
    }
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

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (IBAction)mapView:(id)sender {
    //NSLog(@"Do Nothing");
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

- (IBAction)logout:(id)sender {
    [self performSegueWithIdentifier:@"logout" sender:self];
}

- (IBAction)information:(id)sender {
    [self performSegueWithIdentifier:@"information" sender:self];
}


- (void) loadHTML:(NSString*) pageName
{
    NSRange range = [pageName rangeOfString:@"."];
    if (range.length > 0)
    {
		
    	NSString *fileExt = [pageName substringFromIndex:range.location+1];
        NSString *fileName = [pageName substringToIndex:range.location];
        
        
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:fileExt inDirectory:@""]];
        
		if (url != nil)
		{
            NSError *error;
            NSString *pageContent = [NSString stringWithContentsOfURL:url
                                                             encoding:NSASCIIStringEncoding
                                                                error:&error];
            
            NSString *finalContent = [pageContent stringByReplacingOccurrencesOfString:@"jsapiUrl" withString:[NSString stringWithFormat:@"%@%@", IHUB_SERVER_URL, @"iportal/jsapi"]];
            
            finalContent = [finalContent stringByReplacingOccurrencesOfString:@"{iportalUrl}" withString:[NSString stringWithFormat:@"%@%@", IHUB_SERVER_URL, @"iportal"]];
            
            finalContent = [finalContent stringByReplacingOccurrencesOfString:@"{uName}" withString:[NSString stringWithFormat:@"%s%@%s", "'", self.chartData.userName, "'"]];
            if (self.chartData.password == nil) {
                finalContent = [finalContent stringByReplacingOccurrencesOfString:@"{pwd}" withString:self.chartData.password];
            } else {
                finalContent = [finalContent stringByReplacingOccurrencesOfString:@"{pwd}" withString:[NSString stringWithFormat:@"%s%@%s", "'", self.chartData.password, "'"]];
            }
            finalContent = [finalContent stringByReplacingOccurrencesOfString:@"{reportFolder}" withString:[NSString stringWithFormat:@"%s%@%s", "'", REPORT_FOLDER, "'"]];
            
            
       		[self.webView loadHTMLString:finalContent baseURL:url];
            
		}
    }
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //NSLog(@"Error %li", (long)[error code]);
    if([error code] == NSURLErrorCancelled) {
        return;
    }
    
    if (error != nil) {
        if ([error code] == -1009) {
            self.logout = TRUE;
        }
        [self showAlert:[error localizedDescription]];
    }
}

-(void) webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSError *jsonError;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.chartData.worldData options:0 error:&jsonError];
    
    if (jsonError != nil)
    {
        //call error callback function here
        //NSLog(@"Error creating JSON from the response  : %@",[jsonError localizedDescription]);
        return;
    }
    
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@(%@);",@"init",jsonStr] ];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.view setUserInteractionEnabled:YES];
}


-(void) showAlert : (NSString *)error {
    //NSLog(@"Master View errro desc %@", error);
    [self.view setUserInteractionEnabled:NO];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [alert show];
}


@end
