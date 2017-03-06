//
//  BIRTMasterViewController.m
//  Gazetteer
//
//  Created by Maitrik Patel on 7/1/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import "BIRTMasterViewController.h"
#import "BIRTDetailViewController.h"
#import "BIRTSplitViewController.h"
#import "BIRTAppDelegate.h"
#import "BIRTMapViewController.h"

@interface BIRTMasterViewController()
@property (strong, nonatomic) NSString *selectedView;
@end

@implementation BIRTMasterViewController


@synthesize arrayOriginal;
@synthesize arForTable;


- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor = [UIColor colorWithRed:22/255.0f green:32/255.0f blue:48/255.0f alpha:1.0f];
    [self.tableView setBackgroundView:bview];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:22/255.0f green:32/255.0f blue:48/255.0f alpha:1.0f];
    
    NSString *fileId;
    @try {
        
        NSString *fileName = [NSString stringWithFormat:@"%@%@",DATA_OBJECT_FOLDER, @"world.data"];
        //NSString *getUrl =[NSString stringWithFormat:[NSString stringWithFormat:@"%@%@",REST_API_URL, @"files?search=%@&authId=%@"],[fileName stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding], self.authId];
        NSString *getUrl =[NSString stringWithFormat:[NSString stringWithFormat:@"%@%@",REST_API_URL, @"files/search?name=%@"],[fileName stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]];
        
        //NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:getUrl]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getUrl]
                                                                  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                              timeoutInterval:60];
        [urlRequest setHTTPMethod:@"GET"];
        [urlRequest setValue:self.authId forHTTPHeaderField:@"authToken"];
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"accept"];
        [urlRequest setValue:@"gazetteer/0.0.1" forHTTPHeaderField:@"User-Agent"];
        
        
        NSError *urlConnectionError;
        NSURLResponse *urlResponse;
        NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&urlConnectionError];
        
        if (urlConnectionError != nil) {
            [self showAlert:[urlConnectionError localizedDescription]];
            NSLog(@"error: %@", urlConnectionError);
            return;
        }
        NSError *error;
        NSDictionary* response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        if (error != nil) {
            [self showAlert:[error localizedDescription]];
            return;
        }
        
        NSArray * responseArr = response[@"itemList"][@"file"];
        if (responseArr == nil || [responseArr count] == 0) {
            [self showAlert:@"Unable to get the file"];
            
        } else {
            
            NSDictionary * dict = [responseArr objectAtIndex:0];
            
            fileId = [dict valueForKey:@"id"];
            
            getUrl =[NSString stringWithFormat:[NSString stringWithFormat:@"%@%@",REST_API_URL, @"dataobjects/%@/Combined"],fileId];
            
            //urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:getUrl]];
            urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getUrl]
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                             timeoutInterval:60];
            [urlRequest setHTTPMethod:@"GET"];
            [urlRequest setValue:self.authId forHTTPHeaderField:@"authToken"];
            [urlRequest setValue:@"application/json" forHTTPHeaderField:@"accept"];
            [urlRequest setValue:@"gazetteer/0.0.1" forHTTPHeaderField:@"User-Agent"];
            
            data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&urlConnectionError];
            
            if (urlConnectionError != nil && [urlConnectionError.userInfo valueForKey:@"NSLocalizedDescription"] != nil) {
                //NSLog(@"errro desc %@", [urlConnectionError localizedDescription]);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[urlConnectionError localizedDescription] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
            if (error != nil) {
                [self showAlert:[error localizedDescription]];
            } else {
                self.regionData = response[@"data"];
                self.arrayOriginal=responseArr;
            }
        }
        
        
        
        if (self.regionData != nil) {
            NSMutableDictionary *continentAbbrs = [[NSMutableDictionary alloc] init];
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            
            self.arForTable=[[NSMutableArray alloc] init];
            
            NSMutableDictionary *world = [[NSMutableDictionary alloc]init];
            [world setValue:@"World" forKey:@"name"];
            [world setValue:@"level" forKey:@"0"];
            [world setValue:@"0" forKey:@"highlighted"];
            [self.arForTable addObject:world];
            
            for (id key in self.regionData) {
                NSString *regionData = [(NSDictionary *)key objectForKey:@"Region"];
                NSString *continentData = [(NSDictionary *)key objectForKey:@"Continent"];
                NSString *countryData = [(NSDictionary *)key objectForKey:@"Country"];
                
                
                NSMutableDictionary *regions;
                NSMutableDictionary *continents;
                NSMutableDictionary *country;
                if (continentData == nil || [continentData length] == 0) {
                    continue;
                }
                
                for (NSMutableDictionary *data in [world valueForKeyPath:@"Childs"]) {
                    if ([[data valueForKey:@"name"] isEqualToString:continentData]) {
                        continents = data;
                    }
                }
                
                if (continents == nil) {
                    continents = [[NSMutableDictionary alloc] initWithObjectsAndKeys:continentData, @"name" ,nil];
                    [continents setValue:@"1"  forKey:@"level"];
                    [continents setValue:@"0" forKey:@"highlighted"];
                    [continents setValue:[key valueForKey:@"Cont Abb"] forKey:@"Cont_Abb"];
                    NSMutableArray *child1 = [world valueForKey:@"Childs"];
                    if ( child1 == nil) {
                        child1 = [[NSMutableArray alloc] init];
                        [world setObject:child1 forKey:@"Childs"];
                    }
                    [child1 addObject:continents];
                    [continentAbbrs setValue:[key valueForKey:@"Cont Abb"] forKey:continentData];
                    
                }
                
                NSMutableArray *child2 = [continents valueForKey:@"Childs"];
                if ( child2 == nil) {
                    child2 = [[NSMutableArray alloc] init];
                    [continents setObject:child2 forKey:@"Childs"];
                } else {
                    for (NSMutableDictionary *data in child2) {
                        if ([[data valueForKey:@"name"] isEqualToString:regionData]){
                            regions = data;
                        }
                        
                    }
                }
                
                if ([regionData isEqualToString:@"Oceania"] || [regionData isEqualToString:@"South America"]) {
                    for (NSMutableDictionary *data in child2) {
                        if ([[data valueForKey:@"name"] isEqualToString:countryData]){
                            country = data;
                        }
                    }
                    if (country == nil) {
                        country = [[NSMutableDictionary alloc] initWithObjectsAndKeys:countryData, @"name" ,nil];
                        [country setValue:@"3" forKey:@"level"];
                        [country setValue:continentData forKey:@"continent"];
                        [country setValue:regionData forKey:@"region"];
                        [country setValue:@"0" forKey:@"highlighted"];
                        [country setValue:[key valueForKey:@"Cont Abb"] forKey:@"Cont_Abb"];
                        [country setValue:[key valueForKey:@"Reg Abb"] forKey:@"Reg_Abb"];
                        [country setValue:[key valueForKey:@"Abbreviation"] forKey:@"Count_Abb"];
                        [child2 addObject:country ];
                    }
                    
                } else {
                    if (regions == nil) {
                        regions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:regionData, @"name" ,nil];
                        [regions setValue:@"2"  forKey:@"level"];
                        [regions setValue:@"0" forKey:@"highlighted"];
                        [regions setValue:continentData forKey:@"continent"];
                        [regions setValue:[key valueForKey:@"Cont Abb"] forKey:@"Cont_Abb"];
                        [regions setValue:[key valueForKey:@"Reg Abb"] forKey:@"Reg_Abb"];
                        [child2 addObject:regions];
                    }
                    
                    NSMutableArray *child3 = [regions valueForKey:@"Childs"];
                    if ( child3 == nil) {
                        child3 = [[NSMutableArray alloc] init];
                        [regions setObject:child3 forKey:@"Childs"];
                    }  else {
                        for (NSMutableDictionary *data in child3) {
                            if ([[data valueForKey:@"name"] isEqualToString:countryData]){
                                country = data;
                            }
                        }
                        
                    }
                    
                    
                    if (country == nil) {
                        country = [[NSMutableDictionary alloc] initWithObjectsAndKeys:countryData, @"name" ,nil];
                        [country setValue:@"3" forKey:@"level"];
                        [country setValue:continentData forKey:@"continent"];
                        [country setValue:regionData forKey:@"region"];
                        [country setValue:@"0" forKey:@"highlighted"];
                        [country setValue:[key valueForKey:@"Cont Abb"] forKey:@"Cont_Abb"];
                        [country setValue:[key valueForKey:@"Reg Abb"] forKey:@"Reg_Abb"];
                        [country setValue:[key valueForKey:@"Abbreviation"] forKey:@"Count_Abb"];
                        [child3 addObject:country ];
                    }
                    
                }
                
                
                
            }
            NSMutableArray *childs = [world valueForKey:@"Childs"];
            [childs sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
            
            for (NSMutableDictionary *child in childs) {
                NSMutableArray *innerChilds = [child valueForKey:@"Childs"];
                [innerChilds sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
            }
            
            if (_delegate) {
                [_delegate setDataObjectId:fileId];
                [_delegate setContinentAbbs:continentAbbrs];
                [_delegate worldData:self.regionData];
                [_delegate setSelectedData:[self.arForTable objectAtIndex:0]];
                [_delegate setUserName:self.userName];
                [_delegate setPassword:self.password];
            }
            self.previousIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO  scrollPosition:UITableViewScrollPositionBottom];
            [[self.tableView delegate] tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        }
        
        UIImageView *listViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 62, 21)];
        listViewImage.image = [UIImage imageNamed:@"list-view-selected"];
        
        UIImageView *dividerImage = [[UIImageView alloc] initWithFrame:CGRectMake(68, 0, 10, 21)];
        dividerImage.image = [UIImage imageNamed:@"separator"];
        
        UIButton *mapViewButton =[[UIButton alloc] init];
        [mapViewButton setBackgroundImage:[UIImage imageNamed:@"map-view-unselected"] forState:UIControlStateNormal];
        [mapViewButton addTarget:self action:@selector(mapView:) forControlEvents:UIControlEventTouchUpInside];
        mapViewButton.frame = CGRectMake(95, 0, 62, 21);
        
        
        self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:[[UIBarButtonItem alloc] initWithCustomView:listViewImage ],[[UIBarButtonItem alloc] initWithCustomView:dividerImage ], [[UIBarButtonItem alloc] initWithCustomView:mapViewButton ],nil];
        
    }
    @catch (NSException *exception) {
        [self showAlert:[exception reason]];
    }
    
}


- (IBAction)listView:(id)sender {
    //NSLog(@"Do Nothing");
}

- (IBAction)mapView:(id)sender {
    
    [self performSegueWithIdentifier:@"mapView" sender:self];

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"mapView"])
    {
        UINavigationController *controller = [segue destinationViewController];
        BIRTMapViewController *destController = (BIRTMapViewController *) controller.childViewControllers[0];
        BIRTChartData  *chartData = [[BIRTChartData alloc] init];
        [chartData setUserName:self.userName];
        [chartData setPassword:self.password];
        [chartData setWorldData:self.regionData];
        [destController setChartData:chartData];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self performSegueWithIdentifier:@"logout" sender:self];
}


/*-----------------------Insert_Object---------------------*/

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arForTable count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *data = [self.arForTable objectAtIndex:indexPath.row];
    
   [cell setIndentationLevel:[[data valueForKey:@"level"] intValue]];
    cell.textLabel.text = [NSString stringWithFormat:@"    %@", [data valueForKey:@"name"]];
    cell.textLabel.font =  [UIFont fontWithName:@"Lato-Bold" size:18.0];
    
   cell.backgroundColor = [UIColor colorWithRed:22/255.0f green:32/255.0f blue:48/255.0f alpha:1.0f];
    int highlighted = [[data valueForKey:@"highlighted"] intValue];
    switch ([[data valueForKey:@"level"] intValue]) {
            //Continent
        case 1:
            if (highlighted == 1) {
                cell.backgroundColor = [UIColor colorWithRed:255/255.0f green:159/255.0f blue:42/255.0f alpha:1.0f];
                cell.textLabel.textColor = [UIColor blackColor];
            } else {
                cell.textLabel.textColor = [UIColor colorWithRed:255/255.0f green:159/255.0f blue:42/255.0f alpha:1.0f];
                cell.backgroundColor = [UIColor colorWithRed:22/255.0f green:32/255.0f blue:48/255.0f alpha:1.0f];
            }
            break;
            
            //REGION
        case 2:
            if (highlighted == 1) {
                cell.backgroundColor = [UIColor colorWithRed:102/255.0f green:170/255.0f blue:249/255.0f alpha:1.0f];
                cell.textLabel.textColor = [UIColor blackColor];
            } else {
                cell.textLabel.textColor = [UIColor colorWithRed:102/255.0f green:170/255.0f blue:249/255.0f alpha:1.0f];
                cell.backgroundColor = [UIColor colorWithRed:22/255.0f green:32/255.0f blue:48/255.0f alpha:1.0f];
                
            }
            break;
            
            //Country
        case 3 :
            if (highlighted == 1 ) {
                cell.backgroundColor = [UIColor colorWithRed:42/255.0f green:186/255.0f blue:43/255.0f alpha:1.0f];
                cell.textLabel.textColor = [UIColor blackColor];
            } else {
                cell.backgroundColor = [UIColor colorWithRed:22/255.0f green:32/255.0f blue:48/255.0f alpha:1.0f];
                cell.textLabel.textColor = [UIColor colorWithRed:42/255.0f green:186/255.0f blue:43/255.0f alpha:1.0f];
            }
            break;
        default:
            cell.textLabel.textColor = [UIColor whiteColor];
            break;
            
    }
    
    return cell;
}

/*-----------------Expandable & Collapsable UITableView-----------------*/

#pragma mark - Expanable & Collapsable UITableView

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
	[super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(BOOL) canBecomeFirstResponder {
    return YES;
}

-(BOOL) resignFirstResponder {
    return  YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *d=[self.arForTable objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    int highlighted = [[d valueForKey:@"highlighted"] intValue];
    
    
    switch ([[d valueForKey:@"level"] intValue]) {
            //Continent
        case 1:
            if (highlighted == 1) {
                cell.textLabel.textColor = [UIColor colorWithRed:255/255.0f green:159/255.0f blue:42/255.0f alpha:1.0f];
                cell.backgroundColor = [UIColor colorWithRed:22/255.0f green:32/255.0f blue:48/255.0f alpha:1.0f];;
            } else {
                cell.backgroundColor = [UIColor colorWithRed:255/255.0f green:159/255.0f blue:42/255.0f alpha:1.0f];
                cell.textLabel.textColor = [UIColor blackColor];
            }
            break;
            
        //REGION
        case 2:
            if (highlighted == 1) {
                cell.textLabel.textColor = [UIColor colorWithRed:102/255.0f green:170/255.0f blue:249/255.0f alpha:1.0f];
                cell.backgroundColor = [UIColor colorWithRed:22/255.0f green:32/255.0f blue:48/255.0f alpha:1.0f];;
            } else {
                cell.backgroundColor = [UIColor colorWithRed:102/255.0f green:170/255.0f blue:249/255.0f alpha:1.0f];
                cell.textLabel.textColor = [UIColor blackColor];

            }
            break;
            
        //Country
        case 3 :
            if (highlighted == 1 && indexPath.row != self.previousIndexPath.row) {
                cell.backgroundColor = [UIColor colorWithRed:114/255.0f green:125/255.0f blue:140/255.0f alpha:1.0f];;
                cell.textLabel.textColor = [UIColor blackColor];
            } else {
                cell.backgroundColor = [UIColor colorWithRed:42/255.0f green:186/255.0f blue:43/255.0f alpha:1.0f];
                cell.textLabel.textColor = [UIColor blackColor];
            }
            break;
        default:
            
            break;
            
    }
    
    if (indexPath.row != self.previousIndexPath.row &&
        self.previousIndexPath.row < [self.arForTable count]) {
        NSMutableDictionary *previous=[self.arForTable objectAtIndex:self.previousIndexPath.row];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.previousIndexPath];
        if ([[previous valueForKey:@"highlighted"] intValue] == 1 &&
            [[previous valueForKey:@"level"] intValue] == 3) {
                cell.backgroundColor = [UIColor colorWithRed:22/255.0f green:32/255.0f blue:48/255.0f alpha:1.0f];;
                [previous setValue:@"0" forKey:@"highlighted"];
                cell.textLabel.textColor = [UIColor colorWithRed:42/255.0f green:186/255.0f blue:43/255.0f alpha:1.0f];
        }
    }
    
    
    if (highlighted == 1 ) {
        if ([[d valueForKey:@"level"] intValue] != 3 || indexPath.row != self.previousIndexPath.row) {
            //NSLog(@"didSelectRowAtIndexPath Setting to 0 for %@", d[@"name"]);
            [d setValue:@"0" forKey:@"highlighted"];
        }
    } else {
         [d setValue:@"1" forKey:@"highlighted"];
    }
    
    
    
    
    if([d valueForKey:@"Childs"]) {
        NSArray *ar=[d valueForKey:@"Childs"];
        BOOL isAlreadyInserted=NO;
        for(NSDictionary *dInner in ar ){
            NSInteger index=[self.arForTable indexOfObjectIdenticalTo:dInner];
            isAlreadyInserted=(index>0 && index!=NSIntegerMax);
            if(isAlreadyInserted) break;
        }
        if(isAlreadyInserted) {
            [self miniMizeThisRows:ar];
        } else {
            NSUInteger count=indexPath.row+1;
            NSMutableArray *arCells=[NSMutableArray array];	
            for(NSMutableDictionary *dInner in ar ) {
                [dInner setValue:@"0" forKey:@"highlighted"];
                [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [self.arForTable insertObject:dInner atIndex:count++];
            }
            [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
    
    
    if([d[@"level"] intValue] == 1 || [d[@"level"] intValue] == 2 ) {
        for (NSMutableDictionary *data in self.arForTable) {
            if ([data[@"highlighted"] intValue] == 1 &&  ([data[@"level"] intValue] == 1 || [data[@"level"] intValue] == 2 ) &&
                ![data[@"name"] isEqualToString:d[@"name"]] && [d[@"level"] isEqualToString:data[@"level"]]) {
                [self miniMizeThisRows:data[@"Childs"]];
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:[ NSIndexPath indexPathForRow:[self.arForTable indexOfObject:data] inSection:0]];
                 cell.backgroundColor = [UIColor colorWithRed:22/255.0f green:32/255.0f blue:48/255.0f alpha:1.0f];;
                if([data[@"level"] intValue] == 1) {
                   cell.textLabel.textColor = [UIColor colorWithRed:255/255.0f green:159/255.0f blue:42/255.0f alpha:1.0f];
                } else {
                    cell.textLabel.textColor = [UIColor colorWithRed:102/255.0f green:170/255.0f blue:249/255.0f alpha:1.0f];
                }
                [data setValue:@"0" forKey:@"highlighted"];
                break;
            }
        }
    }
    
    if (indexPath.row == self.previousIndexPath.row) {
        return;
    }

    self.previousIndexPath = indexPath;
      
    
    if (_delegate) {
        [_delegate setSelectedData:d];
        [_delegate setUserName:self.userName];
        [_delegate setPassword:self.password];
        @try {
            [_delegate updateView];
        }
        @catch (NSException *exception) {
            //NSLog(@"Update View failed");
        }
        
        
    }
}

-(void)miniMizeThisRows:(NSArray*)ar{
    for(NSDictionary *dInner in ar ) {
        NSUInteger indexToRemove=[self.arForTable indexOfObjectIdenticalTo:dInner];
        NSArray *arInner=[dInner valueForKey:@"Childs"];
        if(arInner && [arInner count]>0){
            [self miniMizeThisRows:arInner];
        }
        if([self.arForTable indexOfObjectIdenticalTo:dInner]!=NSNotFound) {
            [self.arForTable removeObjectIdenticalTo:dInner];
            [self.tableView deleteRowsAtIndexPaths:
             [NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexToRemove inSection:0]]
                                  withRowAnimation:UITableViewRowAnimationRight];
            
            
        }
        NSMutableArray *arCells=[NSMutableArray array];
        if ([dInner [@"level"] intValue] == 1){
            [dInner setValue:@"0" forKey:@"highlighted"];
            [arCells addObject:[NSIndexPath indexPathForRow:indexToRemove inSection:0]];
            [self.arForTable insertObject:dInner atIndex:indexToRemove];
        }
        
        if ([arCells count] > 0) {
            [self.tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
        }

    
    }
}


-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  BIRTAppDelegate *appDelegate = (BIRTAppDelegate *)[[UIApplication sharedApplication]delegate];
    BIRTSplitViewController *splitViewController = (BIRTSplitViewController *)[appDelegate.window rootViewController];
    splitViewController.view.backgroundColor = [UIColor clearColor];
    for (UIView *subView in splitViewController.view.subviews) {
        subView.backgroundColor = [UIColor clearColor];
    }
}

-(void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake)
    {
        //NSLog(@"Shake Event");
        [self resetTableView];
        
    }
}

-(void) resetTableView {
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO  scrollPosition:UITableViewScrollPositionBottom];
    [[self.tableView delegate] tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

-(void) showAlert : (NSString *)error {
    //NSLog(@"Master View errro desc %@", error);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [alert show];
}



@end


