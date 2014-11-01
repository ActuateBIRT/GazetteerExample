//
//  BIRTChartData.h
//  Gazetteer
//
//  Created by macAd on 7/23/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BIRTChartData : NSObject

@property (strong, nonatomic) NSString* authId;
@property (strong, nonatomic) NSArray *worldData;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *continent;
@property (strong, nonatomic) NSString *region;
@property (strong, nonatomic) NSMutableDictionary *userData;
@property bool isWorld;
@property (strong, nonatomic) NSString *selectedYear;
@property (strong, nonatomic) NSString *contAbb;
@property (strong, nonatomic) NSString *regAbb;
@property (strong, nonatomic) NSString *countAbb;
@property (strong, nonatomic) NSMutableDictionary *contAbbs;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *dataObjectId;

@end
