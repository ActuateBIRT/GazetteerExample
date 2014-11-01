//
//  BIRTPieChartViewController.m
//  Gazetteer
//
//  Created by Maitrik Patel on 7/18/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import "BIRTPieChartViewController.h"
#import "BIRTPieChartView.h"
#import "BIRTPieElement.h"
#import "PieLayer.h"

@interface BIRTPieChartViewController ()
{
    BOOL showPercent;
}

@property (strong, nonatomic) IBOutlet BIRTPieChartView *pieView;
@property BOOL logout;
@property (strong, nonatomic) UIFont *labelFont;
@property (strong, nonatomic) UIColor *labelColor;

@end

@implementation BIRTPieChartViewController
@synthesize pieView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:16.0];
    CGFloat borderWidth = 1.0f;
    self.view.layer.borderWidth = borderWidth;
    [self.view setFrame:CGRectInset(self.view.frame, -borderWidth, -borderWidth)];
    self.refreshView = TRUE;
    
    _titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:15.0];
    _timeLineLabel.font = [UIFont fontWithName:@"Lato-Bold" size:17.0];
    _labelColor = [UIColor colorWithRed:120/255.0f green:129/255.0f blue:144/255.0f alpha:1.0f];
    _labelFont = [UIFont fontWithName:@"Lato-Regular" size:13.0];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.chartData != nil && self.refreshView) {
        self.selectedYear = self.chartData.selectedYear;
        self.timeLine.minimumValue = 1960;
        self.timeLine.maximumValue = 2012;
        self.timeLineLabel.text = self.chartData.selectedYear;
        self.timeLine.value = [self.chartData.selectedYear floatValue];
        [self reloadData];
        self.refreshView = FALSE;
    }
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

-(void) reloadData {
    
    if (self.chartData != nil){
        self.noData.text = @" ";
        BIRTPieElement *elem1;
        BIRTPieElement *elem2;
        BIRTPieElement *elem3;
        if (self.chartData.country != nil) {
            UIColor *color = [UIColor colorWithRed:42/255.0f green:186/255.0f blue:43/255.0f alpha:1.0f];
            _titleLabel.textColor = color;
            self.view.layer.borderColor = color.CGColor;
            _timeLineLabel.textColor = color;
            
            for (NSDictionary *data in self.chartData.worldData) {
                if ([data[@"Country"] isEqualToString:self.chartData.country] && [data[@"Year"] isEqualToString:self.selectedYear])
                {
                    if ([data[@"Pop Aged 0-14"] doubleValue] == 0.0 && [data[@"Pop Aged 15-64"] doubleValue] == 0.0 && [data[@"Pop Aged 65 And Up"] doubleValue] == 0.0) {
                        self.noData.text = @"No data was collected for this country.";
                        //NSLog(@"NO Data Available");
                        return;
                    } else {
                        elem1 = [BIRTPieElement pieElementWithValue:[[data valueForKey:@"Pop Aged 0-14"] floatValue] color:[UIColor colorWithRed:182/255.0f green:216/255.0f blue:143/255.0f alpha:1.0f]];
                        
                        elem1.title = @"0-14 yrs";
                        
                        elem2 = [BIRTPieElement pieElementWithValue:[[data valueForKey:@"Pop Aged 15-64"] floatValue] color:[UIColor colorWithRed:103/255.0f green:188/255.0f blue:44/255.0f alpha:1.0f]];
                        
                        elem2.title = @"15-64 yrs";
                        
                        elem3 = [BIRTPieElement pieElementWithValue:[[data valueForKey:@"Pop Aged 65 And Up"] floatValue] color:[UIColor colorWithRed:212/255.0f green:229/255.0f blue:192/255.0f alpha:1.0f]];
                        
                        elem3.title = @"65+ yrs";
                    }
                }
            }
        } else  if (self.chartData.continent != nil || self.chartData.isWorld){
            if (self.chartData.continent != nil) {
                UIColor *color = [UIColor colorWithRed:255/255.0f green:159/255.0f blue:42/255.0f alpha:1.0f];
                _titleLabel.textColor = color;
                self.view.layer.borderColor = color.CGColor;
                _timeLineLabel.textColor = color;
            } else {
                UIColor *color = [UIColor colorWithRed:49/255.0f green:66/255.0f blue:88/255.0f alpha:1.0f];
                self.view.layer.borderColor = color.CGColor;
                _titleLabel.textColor = color;
                _timeLineLabel.textColor = color;
            }
            NSMutableDictionary *details = [[NSMutableDictionary alloc] init];
            int count = 0;
            for (NSDictionary *data in self.chartData.worldData) {
                if ((self.chartData.isWorld || [data[@"Continent"] isEqualToString:self.chartData.continent])  && [data[@"Year"] isEqualToString:self.selectedYear])
                {
                    NSString *availableVal = [details valueForKey:@"Pop Aged 0-14"];
                    if (availableVal == nil) {
                        [details setObject:data [@"Pop Aged 0-14"] forKey:@"Pop Aged 0-14"];
                    } else {
                        NSString *val = [[NSString alloc]initWithFormat:@"%f", ([availableVal floatValue] +
                                                                                [data [@"Pop Aged 0-14"] floatValue] )];
                        [details setObject:val forKey:@"Pop Aged 0-14"];
                    }
                    
                    availableVal = [details valueForKey:@"Pop Aged 15-64"];
                    if (availableVal == nil) {
                        [details setObject:data [@"Pop Aged 15-64"] forKey:@"Pop Aged 15-64"];
                    } else {
                        NSString *val = [[NSString alloc]initWithFormat:@"%f", ([availableVal floatValue] +
                                                                                [data [@"Pop Aged 15-64"] floatValue] )];
                        [details setObject:val forKey:@"Pop Aged 15-64"];
                    }
                    
                    
                    availableVal = [details valueForKey:@"Pop Aged 65 And Up"];
                    if (availableVal == nil) {
                        [details setObject:data [@"Pop Aged 65 And Up"] forKey:@"Pop Aged 65 And Up"];
                    } else {
                        NSString *val = [[NSString alloc]initWithFormat:@"%f", ([availableVal floatValue] +
                                                                                [data [@"Pop Aged 65 And Up"] floatValue] )];
                        [details setObject:val forKey:@"Pop Aged 65 And Up"];
                    }
                    count++;
                    
                    
                }
            }
            
            if (self.chartData.isWorld) {
                elem1 = [BIRTPieElement pieElementWithValue:[[details valueForKey:@"Pop Aged 0-14" ] floatValue]/count color:[UIColor colorWithRed:78/255.0f green:92/255.0f blue:113/255.0f alpha:1.0f]];
                elem2 = [BIRTPieElement pieElementWithValue:[[details valueForKey:@"Pop Aged 15-64"] floatValue]/count color:[UIColor colorWithRed:48/255.0f green:64/255.0f blue:88/255.0f alpha:1.0f]];
                elem3 = [BIRTPieElement pieElementWithValue:[[details valueForKey:@"Pop Aged 65 And Up"] floatValue]/count  color:[UIColor colorWithRed:113/255.0f green:124/255.0f blue:140/255.0f alpha:1.0f]];
            } else {
                elem1 = [BIRTPieElement pieElementWithValue:[[details valueForKey:@"Pop Aged 0-14" ] floatValue]/count color:[UIColor colorWithRed:232/255.0f green:200/255.0f blue:152/255.0f alpha:1.0f]];
                elem2 = [BIRTPieElement pieElementWithValue:[[details valueForKey:@"Pop Aged 15-64"] floatValue]/count color:[UIColor colorWithRed:255/255.0f green:159/255.0f blue:42/255.0f alpha:1.0f]];
                 elem3 = [BIRTPieElement pieElementWithValue:[[details valueForKey:@"Pop Aged 65 And Up"] floatValue]/count  color:[UIColor colorWithRed:237/255.0f green:222/255.0f blue:197/255.0f alpha:1.0f]];
            }
            
            elem1.title = @"0-14 yrs";
            
            elem2.title = @"15-64 yrs";
            
            elem3.title = @"65+ yrs";
            
        } else if (self.chartData.region != nil){
            UIColor *color = [UIColor colorWithRed:102/255.0f green:170/255.0f blue:249/255.0f alpha:1.0f];
            _titleLabel.textColor = color;
            _timeLineLabel.textColor = color;
            self.view.layer.borderColor = color.CGColor;
            NSMutableDictionary *details = [[NSMutableDictionary alloc] init];
            int count = 0;
            for (NSDictionary *data in self.chartData.worldData) {
                if ([data[@"Region"] isEqualToString:self.chartData.region] && [data[@"Year"] isEqualToString:self.selectedYear])
                {
                    NSString *availableVal = [details valueForKey:@"Pop Aged 0-14"];
                    if (availableVal == nil) {
                        [details setObject:data [@"Pop Aged 0-14"] forKey:@"Pop Aged 0-14"];
                    } else {
                        NSString *val = [[NSString alloc]initWithFormat:@"%f", ([availableVal floatValue] +
                                                                                [data [@"Pop Aged 0-14"] floatValue] )];
                        [details setObject:val forKey:@"Pop Aged 0-14"];
                    }
                    
                    availableVal = [details valueForKey:@"Pop Aged 15-64"];
                    if (availableVal == nil) {
                        [details setObject:data [@"Pop Aged 15-64"] forKey:@"Pop Aged 15-64"];
                    } else {
                        NSString *val = [[NSString alloc]initWithFormat:@"%f", ([availableVal floatValue] +
                                                                                [data [@"Pop Aged 15-64"] floatValue] )];
                        [details setObject:val forKey:@"Pop Aged 15-64"];
                    }
                    
                    
                    availableVal = [details valueForKey:@"Pop Aged 65 And Up"];
                    if (availableVal == nil) {
                        [details setObject:data [@"Pop Aged 65 And Up"] forKey:@"Pop Aged 65 And Up"];
                    } else {
                        NSString *val = [[NSString alloc]initWithFormat:@"%f", ([availableVal floatValue] +
                                                                                [data [@"Pop Aged 65 And Up"] floatValue] )];
                        [details setObject:val forKey:@"Pop Aged 65 And Up"];
                    }
                    count++;
                }
            }
            
            elem1 = [BIRTPieElement pieElementWithValue:[[details valueForKey:@"Pop Aged 0-14" ] floatValue]/count color:[UIColor colorWithRed:179/255.0f green:203/255.0f blue:247/255.0f alpha:1.0f]];
            elem1.title = @"0-14 yrs";
            
            elem2 = [BIRTPieElement pieElementWithValue:[[details valueForKey:@"Pop Aged 15-64"] floatValue]/count color:[UIColor colorWithRed:121/255.0f green:165/255.0f blue:250/255.0f alpha:1.0f]];
            
            elem2.title = @"15-64 yrs";
            
            elem3 = [BIRTPieElement pieElementWithValue:[[details valueForKey:@"Pop Aged 65 And Up"] floatValue]/count  color:[UIColor colorWithRed:211/255.0f green:222/255.0f blue:244/255.0f alpha:1.0f]];
            
            elem3.title = @"65+ yrs";
            
            
            
        }
        else {
            return;
        }
        
        [pieView.layer addValues:@[elem1] animated:NO];
        [pieView.layer addValues:@[elem2] animated:NO];
        [pieView.layer addValues:@[elem3] animated:NO];
        [pieView.layer setFont:_labelFont];
        [pieView.layer setFontColor:_labelColor];
        
        pieView.layer.transformTitleBlock = ^(PieElement* elem, float percent){
            
            return [(BIRTPieElement*)elem title];
            
        };
        
        pieView.layer.showTitles = ShowTitlesAlways;
    }
    

}



-(void) deleteValues {
    NSArray *values = pieView.layer.values;
    
    [pieView.layer deleteValues:values animated:NO];
    [pieView removeLabel];
    
}

- (IBAction)changePercentValuesPressed:(id)sender
{
    showPercent = !showPercent;
    if(showPercent){
        pieView.layer.transformTitleBlock = ^(PieElement* elem, float percent){
            return [NSString stringWithFormat:@"%ld%%", (long)percent];
        };
    } else {
        pieView.layer.transformTitleBlock = ^(PieElement* elem, float percent){
            return [(BIRTPieElement*)elem title];
        };
    }
}

- (UIColor*)randomColor
{
    CGFloat hue = ( arc4random() % 128 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.2;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.3;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (IBAction)backPressed:(id)sender
{
}

- (IBAction)randomValuesPressed:(id)sender
{
    [PieElement animateChanges:^{
        for(PieElement* elem in pieView.layer.values){
            elem.val = (5+arc4random()%8);
        }
    }];
}

- (IBAction)randomColorPressed:(id)sender
{
    [PieElement animateChanges:^{
        for(PieElement* elem in pieView.layer.values){
            elem.color = [self randomColor];
        }
    }];
}

- (IBAction)sliderChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    float val = roundf(slider.value);
    //NSLog(@"@%f",val);
    self.timeLineLabel.text = [NSString stringWithFormat:@"%i" , (int)val ];
    if (val != [self.chartData.selectedYear floatValue]) {
        self.selectedYear = [NSString stringWithFormat:@"%i" , (int)val ];
        [self deleteValues];
        [self reloadData];
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.logout) {
        [self performSegueWithIdentifier:@"logout" sender:self];
        self.logout = FALSE;
    }
}

@end