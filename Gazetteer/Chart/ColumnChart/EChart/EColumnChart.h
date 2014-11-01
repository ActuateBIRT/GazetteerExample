//
//  EColumnChart.h
//  EChart
//
//  Created by Efergy China on 11/12/13.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EColumn.h"
#import "EColumnDataModel.h"
@class EColumnChart;

@protocol EColumnChartDataSource <NSObject>

/** How many Columns are there in total.*/
- (NSInteger) numberOfColumnsInEColumnChart:(EColumnChart *) eColumnChart;

/** How many Columns should be presented on the screen each time*/
- (NSInteger) numberOfColumnsPresentedEveryTime:(EColumnChart *) eColumnChart;

/** The hightest vaule among the whole chart*/
- (EColumnDataModel *)     highestValueEColumnChart:(EColumnChart *) eColumnChart;

/** Value for each column*/
- (EColumnDataModel *)     eColumnChart:(EColumnChart *) eColumnChart
                        valueForIndex:(NSInteger)index;




@optional
/** Allow you to customize the color of every coloum as you wish.*/
- (UIColor *) colorForEColumn:(EColumn *)eColumn;
@optional
- (UIFont *) fontForLabel;

@optional
-(UIColor *) colorForLabel;



/** New protocals coming soon, will allow you to customize column*/



@end


@protocol EColumnChartDelegate <NSObject>

/** When finger single taped the column*/
- (void)        eColumnChart:(EColumnChart *) eColumnChart
             didSelectColumn:(EColumn *) eColumn;

/** When finger enter specific column, this is dif from tap*/
- (void)        eColumnChart:(EColumnChart *) eColumnChart
        fingerDidEnterColumn:(EColumn *) eColumn;

/** When finger leaves certain column, will
 tell you which column you are leaving*/
- (void)        eColumnChart:(EColumnChart *) eColumnChart
        fingerDidLeaveColumn:(EColumn *) eColumn;

/** When finger leaves wherever in the chart,
 will trigger both if finger is leaving from a column */
- (void) fingerDidLeaveEColumnChart:(EColumnChart *)eColumnChart;

@end



@interface EColumnChart : UIView <EColumnDelegate>
@property (nonatomic, readonly) NSInteger leftMostIndex;
@property (nonatomic, readonly) NSInteger rightMostIndex;

@property (nonatomic, strong) UIColor *minColumnColor;
@property (nonatomic, strong) UIColor *maxColumnColor;
@property (nonatomic, strong) UIColor *normalColumnColor;

@property (nonatomic)  int rowCount;
@property (nonatomic) int valueGap;

@property (nonatomic) BOOL showHighAndLowColumnWithColor;

/** If this switch in on, all horizontal labels will show in Integer. */
@property (nonatomic) BOOL showHorizontalLabelsWithInteger;

/** IMPORTANT: 
    This should be setted before datasoucre has been set.*/
@property (nonatomic) BOOL columnsIndexStartFromLeft;



/** Pull out the columns hidden in the left*/
- (void)moveLeft;

/** Pull out the columns hidden in the right*/
- (void)moveRight;

- (void)initData;

/** Call to redraw the whole chart*/
- (void)reloadData;

@property (weak, nonatomic) id <EColumnChartDataSource> dataSource;
@property (weak, nonatomic) id <EColumnChartDelegate> delegate;
@end
