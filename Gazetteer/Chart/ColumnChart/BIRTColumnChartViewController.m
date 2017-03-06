//
//  BIRTColumnChartViewController.m
//  Gazetteer
//
//  Created by Maitrik Patel on 7/18/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import "BIRTColumnChartViewController.h"
#import "EColumnDataModel.h"
#import "EColumnChartLabel.h"
#import "EFloatBox.h"
#import "EColor.h"
#import "EColumnChart.h"
#include <stdlib.h>

@interface BIRTColumnChartViewController ()

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) EFloatBox *eFloatBox;

@property (nonatomic, strong) EColumn *eColumnSelected;
@property (nonatomic, strong) UIColor *tempColor;
@property (weak, nonatomic) IBOutlet UILabel *noData;
@property (weak, nonatomic) IBOutlet UILabel *timeLineLabel;

@property  (nonatomic, strong) NSDictionary *worldGDPData;
@property  (nonatomic, strong) NSDictionary *continentGDPData;
@property  (nonatomic, strong) NSDictionary *regionGDPData;


@property (nonatomic, strong) UILabel *floatLabel;
@property NSNumberFormatter *formatter;
@property BOOL logout;


@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic, strong) UIFont *labelFont;

@end

@implementation BIRTColumnChartViewController
@synthesize tempColor = _tempColor;
@synthesize eFloatBox = _eFloatBox;
@synthesize eColumnChart = _eColumnChart;
@synthesize data = _data;
@synthesize eColumnSelected = _eColumnSelected;
@synthesize valueLabel = _valueLabel;
@synthesize floatLabel = _floatLabel;



#pragma -mark- ViewController Life Circle


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
    CGFloat borderWidth = 1.0f;
    self.view.layer.borderWidth = borderWidth;
    [self.view setFrame:CGRectInset(self.view.frame, -borderWidth, -borderWidth)];
    _valueLabel.backgroundColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:15.0];
    _timeLineLabel.font = [UIFont fontWithName:@"Lato-Bold" size:17.0];
    self.refreshView = TRUE;
    _labelColor = [UIColor colorWithRed:120/255.0f green:129/255.0f blue:144/255.0f alpha:1.0f];
    _labelFont = [UIFont fontWithName:@"Lato-Regular" size:11.0];
}


- (void)viewWillAppear:(BOOL)animated
{
    if (self.refreshView) {
        self.selectedYear = self.chartData.selectedYear;
       
        if (self.chartData != nil) {
            self.timeLineLabel.text = self.chartData.selectedYear;
        }
        self.timeLine.minimumValue = 1960;
        self.timeLine.maximumValue = 2012;
        self.timeLineLabel.text = self.chartData.selectedYear;
        self.timeLine.value = [self.chartData.selectedYear floatValue];
        
        self.formatter = [[NSNumberFormatter alloc] init];
        [self.formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [self.formatter setMaximumFractionDigits:0];
        NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
        [self.formatter setGroupingSeparator:groupingSeparator];
        [self.formatter setGroupingSize:3];
        [self.formatter setAlwaysShowsDecimalSeparator:NO];
        [self.formatter setUsesGroupingSeparator:YES];
        [self reloadData];
        self.refreshView = FALSE;
    }
    
    
}


-(void)viewWillDisappear:(BOOL)animated {
    self.formatter = nil;
}

-(void) reloadData {
    if (self.chartData != nil) {
        _valueLabel.text = @" ";
        NSMutableArray *temp = [NSMutableArray array];
        int valueGap = 7500;
        int noOfRows = 6;
        
        int i=0;
        if (self.worldGDPData == nil) {
            self.worldGDPData = [self getGDPData:@"world data"];
            //NSLog(@"World GDP data: %@",self.worldGDPData);
        }
        
        if (!self.chartData.isWorld) {
            for (NSDictionary *data in self.worldGDPData) {
                if ([data[@"Year"] isEqualToString:self.selectedYear]) {
                    [temp addObject:[[EColumnDataModel alloc] initWithLabel:@"WORLD" value:[ data[@"World GDP Per Cap"] intValue] index:i++ unit:@"$"]];
                    
                    
                }
            }

            
        }
       
       
        if (self.chartData.isWorld){
            UIColor *color = [UIColor colorWithRed:49/255.0f green:66/255.0f blue:88/255.0f alpha:1.0f];
            self.view.layer.borderColor = color.CGColor;
            _titleLabel.textColor = color;
            _timeLineLabel.textColor = color;
            
            if (self.continentGDPData == nil) {
                self.continentGDPData = [self getGDPData:@"continent data"];
            }
            
            for (NSDictionary *data in self.continentGDPData) {
                if ([data[@"Year"] isEqualToString:self.selectedYear]) {
                    [temp addObject:[[EColumnDataModel alloc] initWithLabel:self.chartData.contAbbs[data[@"Continent"]] value:[data[@"Cont GDP Per Cap"] intValue] index:i++ unit:@"$"]];
                }
            }
            
        } else {
            
            
            if (self.chartData.continent != nil) {
                UIColor *color = [UIColor colorWithRed:255/255.0f green:159/255.0f blue:42/255.0f alpha:1.0f];
                _titleLabel.textColor = color;
                _timeLineLabel.textColor = color;
                self.view.layer.borderColor = color.CGColor;
                
                if (self.continentGDPData == nil) {
                    self.continentGDPData = [self getGDPData:@"continent data"];
                }
                
                [self addGDPToTemp:temp valueForIndex:i++ type:@"Continent" value:self.chartData.continent];
            } else if (self.chartData.region != nil) {
                UIColor *color =[UIColor colorWithRed:102/255.0f green:170/255.0f blue:249/255.0f alpha:1.0f];
                _titleLabel.textColor = color;
                _timeLineLabel.textColor = color;
                self.view.layer.borderColor = color.CGColor;
                
                
                if (self.regionGDPData == nil) {
                    self.regionGDPData = [self getGDPData:@"regional data"];
                }
                
                NSString *continent;
                for (NSDictionary *data in self.chartData.worldData) {
                    if ([self.chartData.region isEqualToString:data[@"Region"]]) {
                        continent = data[@"Continent"];
                        break;
                    }
                }
                
                [self addGDPToTemp:temp valueForIndex:i++ type:@"Continent"  value:continent];
                [self addGDPToTemp:temp valueForIndex:i++ type:@"Region"  value:self.chartData.region ];
            } else if (self.chartData.country != nil) {
                UIColor *color = [UIColor colorWithRed:42/255.0f green:186/255.0f blue:43/255.0f alpha:1.0f];
                _titleLabel.textColor = color;
                _timeLineLabel.textColor = color;
                self.view.layer.borderColor = color.CGColor;
                
                NSString *continent;
                NSString *region;
                for (NSDictionary *data in self.chartData.worldData) {
                    if ([self.chartData.country isEqualToString:data[@"Country"]]) {
                        continent = data[@"Continent"];
                        region = data[@"Region"];
                        break;
                    }
                }
                
                [self addGDPToTemp:temp valueForIndex:i++ type:@"Continent" value:continent];
                if (![region isEqualToString:@"Oceania"] && ![region isEqualToString:@"South America"]) {
                    [self addGDPToTemp:temp valueForIndex:i++ type:@"Region" value:region];
                }
                
                for (NSDictionary *data in self.chartData.worldData) {
                    if ([self.chartData.country isEqualToString:data[@"Country"]] &&
                        [data[@"Year"] isEqualToString:self.selectedYear] ) {
                        if (data[@"GDP Per Capita"] != nil && [data[@"GDP Per Capita"] length] > 0) {
                            [temp addObject:[[EColumnDataModel alloc] initWithLabel:self.chartData.countAbb value:[data[@"GDP Per Capita"] intValue] index:i++ unit:@"$"]];
                        } else {
                            [temp addObject:[[EColumnDataModel alloc] initWithLabel:self.chartData.countAbb value:0 index:i++ unit:@"$"]];
                        }
                        break;
                    }
                }
            }
        }
        
        
        
        for (UIView *view in [self.view subviews]) {
            if ([view isKindOfClass:[EColumnChart class] ]) {
                [view removeFromSuperview];
            }
        }
        
        if ([temp count] > 0 ) {
            _data = [NSArray arrayWithArray:temp];
            
            
            _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(75, 100, 275, 220)];
            
            [_eColumnChart setColumnsIndexStartFromLeft:YES];
            [_eColumnChart setShowHighAndLowColumnWithColor:NO];
            [_eColumnChart setRowCount:noOfRows];
            [_eColumnChart setValueGap:valueGap];
            [_eColumnChart setDelegate:self];
            [_eColumnChart setDataSource:self];
            
            [self.view addSubview:_eColumnChart];
            self.noData.text=@" ";
            
        } else {
            NSString *endText = nil;
            if(self.chartData.country != nil) {
                endText = @"country.";
            } else if(self.chartData.region != nil) {
                endText = @"region.";
            } else if(self.chartData.continent != nil) {
                endText = @"continent.";
            }
            //NSLog(@"NO Data Available");
            if (endText != nil) {
                self.noData.text = [@"No data was collected for this " stringByAppendingString:endText];
            }
            
        }
    }
    
    
}

-(void) addGDPToTemp : (NSMutableArray *)temp valueForIndex:(NSInteger)i type: (NSString *)regionType value: (NSString *)regionValue{
    if ([regionType isEqualToString:@"Region"]) {
        for (NSDictionary *data in self.regionGDPData) {
            if ([regionValue isEqualToString:data[@"Region"]] &&
                [data[@"Year"] isEqualToString:self.selectedYear] ) {
                if (data[@"Reg GDP Per Capita"] != nil && [data[@"Reg GDP Per Capita"] length] > 0) {
                    [temp addObject:[[EColumnDataModel alloc] initWithLabel:self.chartData.regAbb value:[data[@" Per Capita"] intValue] index:i++ unit:@"$" ]];
                } else {
                    [temp addObject:[[EColumnDataModel alloc] initWithLabel:self.chartData.regAbb value:0 index:i unit:@"$"]];
                }
                break;
            }
        }
    } else if ([regionType isEqualToString:@"Continent"]) {
        for (NSDictionary *data in self.continentGDPData) {
            if ([regionValue isEqualToString:data[@"Continent"]] &&
                [data[@"Year"] isEqualToString:self.selectedYear]) {
                if (data[@"Cont GDP Per Cap"] != nil && [data[@"Cont GDP Per Cap"] length] > 0) {
                    [temp addObject:[[EColumnDataModel alloc] initWithLabel:self.chartData.contAbb value:[data[@"Cont GDP Per Cap"] intValue] index:i unit:@"$"]];
                } else {
                    [temp addObject:[[EColumnDataModel alloc] initWithLabel:self.chartData.contAbb value:0 index:i++ unit:@"$"]];
                }
                break;
            }
        }
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSDictionary *) getGDPData : (NSString *) endPoint{
    
    NSDictionary* response;
    //NSString *getUrl =[NSString stringWithFormat:[NSString stringWithFormat:@"%@%@",REST_API_URL, @"dataobjects/%@/%@?authId=%@"],self.chartData.dataObjectId,
    NSString *getUrl =[NSString stringWithFormat:[NSString stringWithFormat:@"%@%@",REST_API_URL, @"dataobjects/%@/%@"],self.chartData.dataObjectId,
             [endPoint stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getUrl]
                                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                   timeoutInterval:60];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:self.chartData.authId forHTTPHeaderField:@"authToken"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [urlRequest setValue:@"gazetteer/0.0.1" forHTTPHeaderField:@"User-Agent"];
    
    NSError *urlConnectionError;
    NSURLResponse *urlResponse;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&urlConnectionError];
    
    if (urlConnectionError != nil) {
        if ([urlConnectionError code] == -1009 && [urlConnectionError code] != NSURLErrorCancelled) {
            self.logout = TRUE;
            [self showAlert:[urlConnectionError localizedDescription]];
            @throw [NSException exceptionWithName:@"ERROR" reason:[urlConnectionError localizedDescription] userInfo:nil];
        }
        
    }
    
    NSError *error;
    
    //response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (error != nil) {
        self.logout = FALSE;
        [self showAlert:[error localizedDescription]];
        @throw [NSException exceptionWithName:@"ERROR" reason:[error localizedDescription] userInfo:nil];
    }
    //NSLog(@"data: %@",response[@"data"]);
    return response[@"data"];	
}

#pragma -mark- Actions

- (IBAction)sliderChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    float val = roundf(slider.value);
    //NSLog(@"@%f",val);
    self.timeLineLabel.text = [NSString stringWithFormat:@"%i" , (int)val ];
    if (val != [self.selectedYear floatValue]) {
        self.selectedYear = [NSString stringWithFormat:@"%i" , (int)val ];
        [self reloadData];
    }
}

#pragma -mark- EColumnChartDataSource

- (NSInteger)numberOfColumnsInEColumnChart:(EColumnChart *)eColumnChart
{
    return [_data count];
}

- (NSInteger)numberOfColumnsPresentedEveryTime:(EColumnChart *)eColumnChart
{
    return [_data count];
}

- (EColumnDataModel *)highestValueEColumnChart:(EColumnChart *)eColumnChart
{
    EColumnDataModel *maxDataModel = nil;
    float maxValue = -FLT_MIN;
    for (EColumnDataModel *dataModel in _data)
    {
        if (dataModel.value > maxValue)
        {
            maxValue = dataModel.value;
            maxDataModel = dataModel;
        }
    }
    return maxDataModel;
}

- (EColumnDataModel *)eColumnChart:(EColumnChart *)eColumnChart valueForIndex:(NSInteger)index
{
    if (index >= [_data count] || index < 0) return nil;
    return [_data objectAtIndex:index];
}

-(UIFont *) fontForLabel {
    return _labelFont;
}

-(UIColor *) colorForLabel {
    return _labelColor;
}

#pragma -mark- EColumnChartDelegate
- (void)eColumnChart:(EColumnChart *)eColumnChart
     didSelectColumn:(EColumn *)eColumn
{
    //NSLog(@"Index: %ld  Value: %i", (long)eColumn.eColumnDataModel.index, eColumn.eColumnDataModel.value);
    
    if (_eColumnSelected)
    {
        _eColumnSelected.barColor = _tempColor;
    }
    _eColumnSelected = eColumn;
    _tempColor = eColumn.barColor;
    eColumn.barColor = [UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1.0f];
    NSNumber *val = [[NSNumber alloc] initWithInt:eColumn.eColumnDataModel.value];
    if (_floatLabel != nil) {
        [_floatLabel removeFromSuperview];
        _floatLabel = nil;
    }
    
    CGFloat eFloatBoxY = eColumn.frame.origin.y + (eColumn.frame.size.height * (1-eColumn.grade) - 	25);
    
    if (eFloatBoxY < 0 ) {
        eFloatBoxY = eColumn.frame.origin.y + eColumn.frame.size.height * .0001 - 25;
    }
    
    if (val != 0) {
        _floatLabel = [[UILabel alloc] initWithFrame:CGRectMake(eColumn.frame.origin.x , eFloatBoxY, 50,20)];
        [_floatLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        _floatLabel.text = [self.formatter stringFromNumber:val ];
        _floatLabel.textColor = [UIColor blackColor];
        _floatLabel.backgroundColor = [UIColor clearColor];
        [eColumnChart addSubview:_floatLabel];
    }
}

- (void)eColumnChart:(EColumnChart *)eColumnChart
fingerDidEnterColumn:(EColumn *)eColumn
{
    /**The EFloatBox here, is just to show an example of
     taking adventage of the event handling system of the Echart.
     You can do even better effects here, according to your needs.*/
    //NSLog(@"Finger did enter %ld", (long)eColumn.eColumnDataModel.index);
    
}

- (void)eColumnChart:(EColumnChart *)eColumnChart
fingerDidLeaveColumn:(EColumn *)eColumn
{
    //NSLog(@"Finger did leave %ld", (long)eColumn.eColumnDataModel.index);
    
}

- (void)fingerDidLeaveEColumnChart:(EColumnChart *)eColumnChart
{
    if (_eFloatBox)
    {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            _eFloatBox.alpha = 0.0;
            _eFloatBox.frame = CGRectMake(_eFloatBox.frame.origin.x, _eFloatBox.frame.origin.y + _eFloatBox.frame.size.height, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
        } completion:^(BOOL finished) {
            [_eFloatBox removeFromSuperview];
            _eFloatBox = nil;
        }];
        
    }
    
}

-(void) showAlert : (NSString *)error {
    //NSLog(@"Master View errro desc %@", error);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [alert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.logout) {
        [self performSegueWithIdentifier:@"logout" sender:self];
        self.logout = FALSE;
    }
   
}
@end

