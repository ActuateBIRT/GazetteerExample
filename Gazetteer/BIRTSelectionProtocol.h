//
//  BIRTSelectionProtocol.h
//  Gazetteer
//
//  Created by macAd on 7/15/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BIRTSelectionProtocol <NSObject>

@required
-(void) setSelectedData : (NSMutableDictionary *) selected;
@required
-(void) setContinentAbbs : (NSMutableDictionary *) values;
@required
-(void) worldData : (NSArray *) worldData;
-(void) updateView;
-(void) setUserName : (NSString *) userName;
-(void) setPassword : (NSString *) password;
@optional
-(void) setDataObjectId : (NSString *) objectId;
@end
