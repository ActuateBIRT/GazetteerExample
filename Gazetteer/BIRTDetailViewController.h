//
//  BIRTDetailViewController.h
//  Gazetteer
//
//  Created by Maitrik Patel on 7/1/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIRTSelectionProtocol.h"
#import "BIRTPagerView.h"

@interface BIRTDetailViewController : UIViewController <BIRTSelectionProtocol,UISplitViewControllerDelegate,
                                        UIScrollViewDelegate,BIRTPagerViewDelegate,UIActionSheetDelegate, UIWebViewDelegate> {
	
	BOOL pageControlBeingUsed;
    
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet BIRTPagerView *pagerView;


}
@property (weak, nonatomic) IBOutlet UIWebView *dummyView;

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *seeMore;
@property (strong, nonatomic) NSString* authId;
@property (strong, nonatomic) NSMutableDictionary *userData;
@property (strong, nonatomic) NSMutableDictionary *contAbbs;
@property (strong, nonatomic) NSArray *worldData;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property BOOL realign;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *dataObjectId;

/*-----------------------Scroll view---------------------*/
#pragma mark - Scroll view

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet BIRTPagerView *pagerView;

- (IBAction)changePage;
- (IBAction)buttonPressed:(id)sender;

@end
