//
//  BIRTPagerView.h
//  BIRTPagerView
//
//  Created by macAd on 8/01/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MCPAGERVIEW_DID_UPDATE_NOTIFICATION @"BIRTPageViewDidUpdate"

@protocol BIRTPagerViewDelegate;

@interface BIRTPagerView : UIView

- (void)setImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage forKey:(NSString *)key;

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,readonly) NSInteger numberOfPages;
@property (nonatomic,copy) NSString *pattern;
@property (nonatomic,assign) id<BIRTPagerViewDelegate>delegate;

@end

@protocol BIRTPagerViewDelegate <NSObject>

@optional
- (BOOL)pageView:(BIRTPagerView *)pageView shouldUpdateToPage:(NSInteger)newPage;
- (void)pageView:(BIRTPagerView *)pageView didUpdateToPage:(NSInteger)newPage;

@end