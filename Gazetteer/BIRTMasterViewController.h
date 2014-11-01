//
//  BIRTMasterViewController.h
//  Gazetteer
//
//  Created by Maitrik Patel on 7/1/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIRTSelectionProtocol.h"

@class BIRTDetailViewController;

@interface BIRTMasterViewController : UITableViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSArray *arrayOriginal;
@property (strong, nonatomic) NSMutableArray *arForTable;
@property (strong, nonatomic) NSArray * regionData;
@property (strong, nonatomic) NSString* authId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;
@property (nonatomic, assign) id<BIRTSelectionProtocol> delegate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (strong, nonatomic) NSIndexPath *previousIndexPath;
-(void) resetTableView;

@end
