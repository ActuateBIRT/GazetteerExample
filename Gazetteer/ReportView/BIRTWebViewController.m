//
//  BIRTWebViewController.m
//  Gazetteer
//
//  Created by Maitrik Patel on 7/8/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import "BIRTWebViewController.h"
#import "BIRTLoginViewController.h"

@interface BIRTWebViewController ()

@property BOOL logout;
@property (nonatomic, strong) UIActionSheet *actionSheet;

@property BOOL isShowingLandscape;

@end

@implementation BIRTWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self canBecomeFirstResponder];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
    if(self.actionSheet != nil) {
        [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        self.actionSheet = nil;
    }
    
}

-(BOOL) canBecomeFirstResponder {
    return YES;
}

-(BOOL) resignFirstResponder {
    return  YES;
}

-(void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [self performSegueWithIdentifier:@"goBack" sender:self];
    }
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
    
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.bounces = NO;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:22/255.0f green:32/255.0f blue:48/255.0f alpha:1.0f];
    if (self.chartData != nil) {
        
        self.webView.delegate = self;
        [self loadHTML:@"jsapi.html"];
    }
    
    
}



-(void)webViewDidFinishLoad:(UIWebView *)webView {
    //NSLog(@"URL is loading %d", UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]));
    NSString *fileName ;
    
    BOOL islandscape =  UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithDictionary:self.userData];
    [data removeObjectForKey:@"Childs"];
    NSString *name = [self.userData valueForKey:@"name"];
    NSString *level = [data valueForKey:@"level"];
    [data removeObjectForKey:@"level"];
    [data removeObjectForKey:@"name"];
    
    
    NSMutableDictionary *jsData = [[NSMutableDictionary alloc] initWithDictionary:data];
    jsData[@"iportalUrl"] =  [NSString stringWithFormat:@"%@%@", IHUB_SERVER_URL , @"iportal/"];
    
    if (islandscape) {
        _isShowingLandscape = YES;
    }
    if ([level intValue] == 3) {
        [jsData setObject:name forKey:@"country"];
        if (islandscape)
        {
            fileName = @"Country Report.rptdesign";
        } else {
            fileName = @"Country Report Portrait.rptdesign";
        }
        
    } else if ([level intValue] == 2) {
        [jsData setObject:name forKey:@"region"];
        if (islandscape)
        {
            fileName = @"Regional Report.rptdesign";
        } else {
            fileName = @"Regional Report Portrait.rptdesign";
        }
    } else if ([level intValue] == 1) {
        [jsData setObject:name forKey:@"continent"];
        if (islandscape)
        {
            fileName = @"Continent Report.rptdesign";
        } else {
            fileName = @"Continent Report Portrait.rptdesign";
        }
    }  else {
        if (islandscape)
        {
            fileName = @"World Report.rptdesign";
        } else {
            fileName = @"World Report Portrait.rptdesign";
        }
    }
    
    
    NSString *file = [NSString stringWithFormat:@"%@%@",REPORT_FOLDER, fileName];
    
    jsData[@"report"] = file;
    if (islandscape) {
        jsData[@"width"] = [NSString stringWithFormat:@"%f", 1024.0];
        jsData[@"height"] =[NSString stringWithFormat:@"%f", 768.0];
    } else {
        jsData[@"width"] = [NSString stringWithFormat:@"%f", 768.0];
        jsData[@"height"] =[NSString stringWithFormat:@"%f", 960.0];
    }
    
    NSError *jsonError;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsData options:0 error:&jsonError];
    
    if (jsonError != nil)
    {
        //call error callback function here
        //NSLog(@"Error creating JSON from the response  : %@",[jsonError localizedDescription]);
        return;
    }
    
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@(%@);",@"init",jsonStr] ];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


- (void)orientationChanged:(NSNotification *)note
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) &&
        !_isShowingLandscape) {
        _isShowingLandscape = YES;
        [self loadHTML:@"jsapi.html"];
        
    } else if (UIDeviceOrientationIsPortrait(deviceOrientation) &&
               _isShowingLandscape){
        _isShowingLandscape = NO;
        [self loadHTML:@"jsapi.html"];
    }
    
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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //NSLog(@"Index = %ld - Title = %@", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"information" sender:self];
    } else if (buttonIndex == 1) {
        [self performSegueWithIdentifier:@"source" sender:self];
    } else  if (buttonIndex == 2){
        [self performSegueWithIdentifier:@"logout" sender:self];
    }
}

-(void) showAlert : (NSString *)error {
    //NSLog(@"Master View errro desc %@", error);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //NSLog(@"Report View failed ERROR CODE %li", (long)[error code]);
    if([error code] == NSURLErrorCancelled) {
        return;
    }
    if (error != nil) {
        if ([error code] == -1009) {
            self.logout = TRUE;
        }
        [self.view setUserInteractionEnabled:NO];
        [self showAlert:[error localizedDescription]];
    }
    
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.view setUserInteractionEnabled:YES];}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.logout) {
        [self performSegueWithIdentifier:@"logout" sender:self];
        self.logout = FALSE;
    }
    
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
            
            finalContent = [finalContent stringByReplacingOccurrencesOfString:@"{uName}" withString:[NSString stringWithFormat:@"%s%@%s", "'", self.chartData.userName, "'"]];
            if (self.chartData.password == nil) {
                finalContent = [finalContent stringByReplacingOccurrencesOfString:@"{pwd}" withString:self.chartData.password];
            } else {
                finalContent = [finalContent stringByReplacingOccurrencesOfString:@"{pwd}" withString:[NSString stringWithFormat:@"%s%@%s", "'", self.chartData.password, "'"]];
            }
            
       		[self.webView loadHTMLString:finalContent baseURL:url];
		}
    }
}

@end
