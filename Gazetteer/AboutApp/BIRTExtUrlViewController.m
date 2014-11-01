//
//  BIRTExtUrlViewController.m
//  Gazetteer
//
//  Created by macAd on 8/14/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import "BIRTExtUrlViewController.h"

@interface BIRTExtUrlViewController ()


@end

@implementation BIRTExtUrlViewController

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
    
    self.webView.delegate = self;
    NSURLRequest *req = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:req];
    // Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
   [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(IBAction)closeView:(id)sender {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
