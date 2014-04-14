//
//  JsonGraphViewController.h
//  Energy Manager
//
//  Created by Kevin Olsthoorn on 13-04-14.
//
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "JsonViewController.h"

@interface JsonGraphViewController : JsonViewController <CPTPlotDataSource>

@property CPTGraphHostingView* hostView;
@property NSData *graphData;
@property NSArray *graphDataDictionary;
@property NSMutableArray *xAxisDateLabels;
@property CPTScatterPlot* plot;
@property CPTXYAxis *x;
@property CPTXYAxis *y;
@property CPTMutableLineStyle *lineStyle;
@property CPTColor *areaColor;

@property CGFloat yMaxValue;
@property CGFloat yMinValue;
@property NSInteger majorIncrement;
@property NSInteger minorIncrement;

@property (weak, nonatomic) IBOutlet UIScrollView *GraphScrollView;

- (void)setGraphSettings;
- (void)generateXAxisDates;
- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index;

@end
