//
//  BIRTPopupViewController.m
//  Gazetteer
//
//  Created by macAd on 8/21/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import "BIRTPopupViewController.h"

@interface BIRTPopupViewController ()

@property (nonatomic, strong) NSArray *arrAgeRanges;

@end

@implementation BIRTPopupViewController

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
    self.restApiUrl.text = REST_API_URL;
    self.serverUrl.text = IHUB_SERVER_URL;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction method implementation

- (IBAction)done:(id)sender {
    [self.delegate dataChanged:self.restApiUrl.text webUrl:self.serverUrl.text];
}


#pragma mark - UITextField Delegate method implementation

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.restApiUrl resignFirstResponder];
    [self.serverUrl resignFirstResponder];
    return YES;
}


@end
