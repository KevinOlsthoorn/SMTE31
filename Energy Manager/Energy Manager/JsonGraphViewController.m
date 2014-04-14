//
//  JsonGraphViewController.m
//  Energy Manager
//
//  Created by Kevin Olsthoorn on 13-04-14.
//
//

#import "JsonGraphViewController.h"

@interface JsonGraphViewController ()

@end

@implementation JsonGraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    // We need a hostview, you can create one in IB (and create an outlet) or just do this:
    _hostView = [[CPTGraphHostingView alloc] initWithFrame:_GraphScrollView.frame];
    [self.view addSubview: _hostView];
    
    // Create a CPTGraph object and add to hostView
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:_GraphScrollView.bounds];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    graph.plotAreaFrame.paddingLeft = 60.0;
    graph.plotAreaFrame.paddingBottom = 90.0;
    [graph applyTheme:theme];
    _hostView.hostedGraph = graph;
    
    // Get the (default) plotspace from the graph so we can set its x/y ranges
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    plotSpace.allowsUserInteraction = YES;
    
    // Create the plot
    _plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    _lineStyle = [_plot.dataLineStyle mutableCopy];
    _lineStyle.lineWidth              = 2.0;
    _lineStyle.lineColor              = [CPTColor colorWithComponentRed:0.87 green:0.32 blue:0.32 alpha:1];
    
    // Put an area color under the plot above
    _areaColor = [CPTColor colorWithComponentRed:0.87 green:0.32 blue:0.32 alpha:0.2];
    _plot.areaBaseValue = CPTDecimalFromDouble(0);
    
    
    
    // Let's keep it simple and let this class act as datasource (therefore we implemtn <CPTPlotDataSource>)
    _plot.dataSource = self;
    //[plotSpace setDelegate:self];
    
    // Finally, add the created plot to the default plot space of the CPTGraph object we created before
    [graph addPlot:_plot toPlotSpace:graph.defaultPlotSpace];
    
    // 1 - Create styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor whiteColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [CPTColor blackColor];
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [CPTColor whiteColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 11.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 2.0f;
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 1.0f;
    // 2 - Get axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    // 3 - Configure x-axis
    _x = axisSet.xAxis;
    _x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0];
    _x.title = @"Time";
    _x.titleOffset = 60.0f;
    _x.titleTextStyle = axisTitleStyle;
    _x.labelTextStyle = axisTextStyle;
    // 4 - Configure y-axis
    _y = axisSet.yAxis;
    _y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0];
    _y.title = @"y-axis";
    _y.titleTextStyle = axisTitleStyle;
    _y.titleOffset = -55.0f;
    _y.axisLineStyle = axisLineStyle;
    _y.majorGridLineStyle = gridLineStyle;
    _y.labelingPolicy = CPTAxisLabelingPolicyNone;
    _y.labelTextStyle = axisTextStyle;
    _y.labelOffset = 31.0f;
    _y.majorTickLineStyle = axisLineStyle;
    _y.majorTickLength = 4.0f;
    _y.minorTickLength = 2.0f;
    _y.tickDirection = CPTSignPositive;
    
    // Setting all the editable graph settings on their default value.
    _yMinValue = 0.0f;
    _majorIncrement = 100;
    _minorIncrement = 10;
    
    [super viewDidLoad];
    
    [self setGraphSettings];
    
    NSInteger majorIncrement = _majorIncrement;
    NSInteger minorIncrement = _minorIncrement;
    
    CPTFill *areaGradientFill = [CPTFill fillWithColor:_areaColor];
    _plot.areaFill      = areaGradientFill;
    _plot.dataLineStyle = _lineStyle;
    
    CGFloat yMax = _yMaxValue; // Determine the maximum y-value.
    CGFloat yMin = _yMinValue; // Determine the minimum y-value.
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    for (NSInteger j = yMin; j <= yMax; j += minorIncrement) {
        NSUInteger mod = j % majorIncrement;
        if (mod == 0) {
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i", j] textStyle:_y.labelTextStyle];
            NSDecimal location = CPTDecimalFromInteger(j);
            label.tickLocation = location;
            label.offset = -_y.majorTickLength - _y.labelOffset;
            if (label) {
                [yLabels addObject:label];
            }
            [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
        } else {
            [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
        }
    }
    _y.axisLabels = yLabels;
    _y.majorTickLocations = yMajorLocations;
    _y.minorTickLocations = yMinorLocations;
    
    _x.labelingPolicy = CPTAxisLabelingPolicyNone; // This allows us to create custom axis labels for x axis
    
    _hostView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [plotSpace scaleToFitPlots:[graph allPlots]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords {
    return _graphDataDictionary.count;
}

- (void)generateXAxisDates
{
    for (unsigned int i = 0; i < _graphDataDictionary.count; i++)
    {
        NSDictionary *graph = [_graphDataDictionary objectAtIndex:i];
        NSNumber *timestamp = [NSNumber numberWithUnsignedInt: [[graph objectForKey:@"timestamp"] intValue]];
        NSTimeInterval _interval = timestamp.doubleValue - (60*60)*2;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *_formatter= [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"hh:mm:ss"];
        [_xAxisDateLabels addObject:[_formatter stringFromDate:date]];
    }
    
    NSMutableArray *ticks = [NSMutableArray arrayWithCapacity:1];
    for(unsigned int counter = 0; counter < [_xAxisDateLabels count]; counter++) {
        // Here the instance variable xAxisDataLabels is a list of custom labels
        [ticks addObject:[NSNumber numberWithInt:counter]];
    }
    NSUInteger labelLocation = 0;
    NSMutableArray* customLabels = [NSMutableArray arrayWithCapacity:[_xAxisDateLabels count]];
    @try {
        for (unsigned int i = 0; i < _xAxisDateLabels.count; i++)
        {
            CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText: [_xAxisDateLabels objectAtIndex:labelLocation++] textStyle:_x.labelTextStyle];
            if (i % 10 == 0) // Making sure only a date is printed 1 out of 10.
            {
                newLabel.tickLocation = [[NSNumber numberWithInt:i] decimalValue];
                newLabel.offset = _x.labelOffset + _x.majorTickLength;
                newLabel.rotation = M_PI/3.5f;
                [customLabels addObject:newLabel];
            }
        }
    }
    @catch (NSException * e) {
        NSLog(@"An exception occurred while creating date labels for x-axis");
    }
    @finally {
        _x.axisLabels =  [NSSet setWithArray:customLabels];
    }
    _x.majorTickLocations = [NSSet setWithArray:ticks];
}

- (void)setGraphSettings
{
    /*** To be implemented in subclass ***/
}
- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    /*** To be implemented in subclass ***/
    return nil;
}

@end
