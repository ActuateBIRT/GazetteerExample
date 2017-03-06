//
//  BIRTAboutUsViewController.m
//  Gazetteer
//
//  Created by Maitrik Patel on 8/6/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import "BIRTAboutUsViewController.h"
#import "BIRTExtUrlViewController.h"

@interface BIRTAboutUsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSURL *url;

@end

@implementation BIRTAboutUsViewController

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
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:22/255.0f green:32/255.0f blue:48/255.0f alpha:1.0f];
    // Do any additional setup after loading the view.
    BOOL isLandscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    //NSLog(@"isLandscape %d", isLandscape);
    if (isLandscape) {
        _portraitGlobe.hidden = YES;
        _landscapeGlobe.hidden = NO;
    } else {
        _landscapeGlobe.hidden = YES;
        _portraitGlobe.hidden = NO;

    }
    self.textView.editable = NO;
    self.textView.delegate = self;
    
    self.aboutLabel.font = [UIFont fontWithName:@"Lato-Bold" size:80.0];
    
    
    
    NSAttributedString *attributedString = self.textView.attributedText;
    NSMutableAttributedString *muAttrStr = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    [muAttrStr enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationReverse usingBlock:
     ^(NSDictionary *attributes, NSRange range, BOOL *stop) {
         
         NSMutableDictionary *mutableAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
         UIFont *font =  attributes[@"NSFont"];
         if ([[font fontName] isEqualToString:@"Helvetica-Bold"]) {
             [mutableAttributes setObject:[UIFont fontWithName:@"Lato-Bold" size:14.0f] forKey:@"NSFont"];
         } else if ([[font fontName] isEqualToString:@"Helvetica"]){
             [mutableAttributes setObject:[UIFont fontWithName:@"Lato-Regular" size:14.0f] forKey:@"NSFont"];
         }
         
         [muAttrStr setAttributes:mutableAttributes range:range];
         
     }];
    
    self.textView.attributedText = muAttrStr;
}


-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"isLanscape %d", toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
          toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        _portraitGlobe.hidden = YES;
        _landscapeGlobe.hidden = NO;
    } else {
        _landscapeGlobe.hidden = YES;
        _portraitGlobe.hidden = NO;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    self.url = URL;
    [self performSegueWithIdentifier:@"externalUrl" sender:self];
   
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
    
    BIRTExtUrlViewController *controller = (BIRTExtUrlViewController *)[navController.viewControllers objectAtIndex:0];
    controller.url = self.url;
}


@end
