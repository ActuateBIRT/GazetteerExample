//
//  EColumnDataModel.m
//  EChart
//
//  Created by Efergy China on 13-12-12.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import "EColumnDataModel.h"

@implementation EColumnDataModel
@synthesize label = _label;
@synthesize value = _value;
@synthesize index = _index;
@synthesize unit  = _unit;

- (id)init
{
    self = [super init];
    if (self)
    {
        _label = @"Empty";
        _value = 0;
    }
    return self;
}

- (id)initWithLabel:(NSString *)label
              value:(int)vaule
              index:(NSInteger)index
               unit:(NSString *)unit
{
    self = [self init];
    if (self)
    {
        if (nil == label)
        {
            _label = @"";
        }
        else
        {
           _label = label;
        }
        
        if (nil == unit)
        {
            _unit = @"";
        }
        else
        {
           _unit = unit; 
        }
        _value = vaule;
        _index = index;
        
    }
    return self;
}


@end
