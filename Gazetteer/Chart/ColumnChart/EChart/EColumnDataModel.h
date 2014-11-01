//
//  EColumnDataModel.h
//  EChart
//
//  Created by Efergy China on 13-12-12.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EColumnDataModel : NSObject

@property (strong, nonatomic) NSString *label;
@property (nonatomic) int value;
@property (nonatomic) NSInteger index;
@property (nonatomic, strong) NSString *unit;

- (id)initWithLabel:(NSString *)label
              value:(int)vaule
              index:(NSInteger)index
               unit:(NSString *)unit;

@end
