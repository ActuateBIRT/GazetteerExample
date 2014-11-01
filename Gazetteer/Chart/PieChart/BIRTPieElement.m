//
//  BIRTPieElement.m
//  Gazetteer
//
//  Created by Maitrik Patel on 7/23/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import "BIRTPieElement.h"

@implementation BIRTPieElement

- (id)copyWithZone:(NSZone *)zone
{
    BIRTPieElement *copyElem = [super copyWithZone:zone];
    copyElem.title = self.title;
    
    return copyElem;
}

@end
