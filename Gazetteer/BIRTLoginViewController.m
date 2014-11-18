//
//  BIRTLoginViewController.m
//  Gazetteer
//
//  Created by macAd on 7/9/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import "BIRTLoginViewController.h"
#import "BIRTSplitViewController.h"
#import "BIRTAppDelegate.h"
#import "BIRTDetailViewController.h"
#import "BIRTMasterViewController.h"
#import "BIRTPopupViewController.h"


@interface BIRTLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (nonatomic, strong) UIPopoverController *userDataPopover;

@property UIFont *latoFont;

@end

@implementation BIRTLoginViewController
@synthesize loginButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.latoFont = [UIFont fontWithName:@"Lato-Heavy" size:15.0];
    
    
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    
    _username.textColor = [UIColor colorWithRed:255/255.0f green:256/255.0f blue:255/255.0f alpha:0.6f];
    _username.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.4f];
    _password.textColor = [UIColor colorWithRed:255/255.0f green:256/255.0f blue:255/255.0f alpha:0.6f];
    _password.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.4f];
    
    [_password setValue:[UIColor colorWithRed:255/255.0f green:256/255.0f blue:255/255.0f alpha:0.6f] forKeyPath:@"_placeholderLabel.textColor"];
    [_username setValue:[UIColor colorWithRed:255/255.0f green:256/255.0f blue:255/255.0f alpha:0.6f] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.center = self.view.center;
    [self.view addSubview:indicatorView];
    [self.indicatorView stopAnimating];
    self.username.delegate = self;
    
    loginButton.titleLabel.font = [self.latoFont fontWithSize:25.0];
    self.username.font = [self.latoFont fontWithSize:20.0];
    self.password.font = [self.latoFont fontWithSize:20.0];
    self.loadingTitle.font = [self.latoFont fontWithSize:22.0];
    _appTitle.font = [self.latoFont fontWithSize:35.0];
    
    
    UIColor *greycolor = [UIColor lightGrayColor];
    UIColor *whitecolor = [UIColor whiteColor];
    
    self.username.textColor = whitecolor;
    self.password.textColor = whitecolor;
    
    self.username.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"username" attributes:@{NSForegroundColorAttributeName: greycolor}];
    self.password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"password" attributes:@{NSForegroundColorAttributeName: greycolor}];
    
    self.username.delegate = self;
    self.password.delegate = self;
}


-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"isLanscape %d", toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
          toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
    [self.userDataPopover dismissPopoverAnimated:YES];
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        _appLogo.frame = CGRectMake(338,85,92,92);
        _appTitle.frame = CGRectMake(189,185,390,50);
        _username.frame = CGRectMake(189,245,390,50);
        _password.frame = CGRectMake(189,305,390,50);
        loginButton.frame = CGRectMake(189,365,390,50);
        _loadingTitle.frame = CGRectMake(400,373,200,31);
        _activitySpinner.frame = CGRectMake(445,380,20,20);
        _popoverIcon.frame = CGRectMake(979,724,20,20);
    }
    else{
        _loadingTitle.frame = CGRectMake(268,375,200,31);
        _activitySpinner.frame = CGRectMake(476,380,20,20);
        _popoverIcon.frame = CGRectMake(724,979,20,20);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"logout"] ){
        //NSLog(@"Loggin Out....");
        BIRTAppDelegate *appDelegate = (BIRTAppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.window setRootViewController:self];
        
    } else if ([[segue identifier] isEqualToString:@"loginSucess"] ){
        
        @try {
            BIRTSplitViewController *splitViewController = [segue destinationViewController];
            //NSLog(@"name %@", [splitViewController class]);
            
            UINavigationController *navigationController = [splitViewController.viewControllers objectAtIndex:0];
            
            BIRTMasterViewController *leftViewController = (BIRTMasterViewController *)[navigationController topViewController];
            
            
            UINavigationController *rightNavigationController = [splitViewController.viewControllers objectAtIndex:1];
            
            BIRTDetailViewController *rightViewController = (BIRTDetailViewController *)[rightNavigationController topViewController];
            
            [rightViewController setAuthId:_authId];
            [leftViewController setAuthId:_authId];
            [leftViewController setUserName:self.username.text];
            [leftViewController setPassword:self.password.text];
            
            leftViewController.delegate = rightViewController;
            splitViewController.delegate = rightViewController;
            BIRTAppDelegate *appDelegate = (BIRTAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.window setRootViewController:splitViewController];
            splitViewController.view.opaque = NO;
            UIImageView *imgView = [[UIImageView alloc] initWithImage:
                                    [UIImage imageNamed:@"headerBG"]];
            [imgView setFrame:CGRectMake(0, 0, 1024, 65)];
            [[splitViewController view] insertSubview:imgView atIndex:0];
            [[splitViewController view] setBackgroundColor:[UIColor clearColor]];
                        
        }
        @catch (NSException *exception) {
            //NSLog(@"Unexpected Error happened %@", [exception reason]);
        }
        
        
    }
}

- (IBAction)enter:(id)sender {
    [self login];
    
}

-(void) loadData {
    [self performSegueWithIdentifier:@"loginSucess" sender:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [self login];
    return YES;
}

-(void) login {
    [self.view setUserInteractionEnabled:NO];
    [self.view endEditing:YES];
    NSString *yourName = self.username.text;
    NSString *password = self.password.text;
    
    NSString *post =[NSString stringWithFormat:@"username=%@&password=%@",yourName,password ];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REST_API_URL,  @"login"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error != nil && [error.userInfo valueForKey:@"NSLocalizedDescription"] != nil) {
        //NSLog(@"errro desc %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        NSDictionary *loginResponse = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableLeaves error:nil];
        _authId = [loginResponse objectForKey:@"AuthId"];
        NSDictionary *errorResp = (NSDictionary *)[loginResponse objectForKey:@"error"];
        //NSLog(@"errorResp -- %lu", (unsigned long)errorResp.count);
        
        if (errorResp == nil || errorResp.count  == 0) {
            //NSLog(@"button clicked and loading");
            loginButton.titleLabel.hidden = true ;
            _loadingTitle.hidden = false ; 
            [self.indicatorView startAnimating];
            [self performSelectorOnMainThread:@selector(loadData) withObject:self waitUntilDone:NO];
        } else {
            NSString *errorMsg = [errorResp objectForKey:@"message"];
            NSString *errorDesc = [errorResp objectForKey:@"description"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:errorMsg message:errorDesc delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }
}

- (IBAction)showUserDataEntryForm:(id)sender {
    BIRTPopupViewController *popViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"popupView"];

    popViewController.delegate = self;
    
    self.userDataPopover = [[UIPopoverController alloc] initWithContentViewController:popViewController];
    
    self.userDataPopover.popoverContentSize = CGSizeMake(500.0, 170.00);
    
    [self.userDataPopover presentPopoverFromRect:[(UIButton *)sender frame]
                                          inView:self.view
                        permittedArrowDirections:UIPopoverArrowDirectionDown
                                        animated:YES];
}


#pragma mark - TestViewController Delegate method implementation

-(void)dataChanged:(NSString *)restApiUrl webUrl:(NSString *)webUrl{
    //NSLog(@"restApiUrl is %@ and webUrl is %@", restApiUrl, webUrl);
    [self.userDataPopover dismissPopoverAnimated:YES];
    
    if (restApiUrl != nil && [restApiUrl length] > 0) {
        REST_API_URL = restApiUrl;
    }
    if (webUrl != nil && [webUrl length] > 0) {
        IHUB_SERVER_URL = webUrl;
    }
}


-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.view setUserInteractionEnabled:YES];
    [self.view endEditing:NO];
}


@end

