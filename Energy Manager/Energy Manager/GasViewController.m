//
//  GasViewController.m
//  Energy Manager
//
//  Created by Kevin Olsthoorn on 24-02-14.
//  Copyright (c) 2014 Olsthoorn Webdevelopment. All rights reserved.
//

#import "GasViewController.h"

@interface GasViewController ()

@end

@implementation GasViewController

CPTGraphHostingView* hostView;
NSData *graphData;
NSArray *graphDataDictionary;
NSMutableArray *xAxisDateLabels;
CPTScatterPlot* plot;
CPTXYAxis *x;

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
    hostView = [[CPTGraphHostingView alloc] initWithFrame:_hostView.frame];
    [self.view addSubview: hostView];
    
    // Create a CPTGraph object and add to hostView
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    graph.plotAreaFrame.paddingLeft = 60.0;
    graph.plotAreaFrame.paddingBottom = 90.0;
    [graph applyTheme:theme];
    hostView.hostedGraph = graph;
    
    // Get the (default) plotspace from the graph so we can set its x/y ranges
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    plotSpace.allowsUserInteraction = YES;
    
    // Create the plot
    plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    CPTMutableLineStyle *lineStyle = [plot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 2.0;
    lineStyle.lineColor              = [CPTColor colorWithComponentRed:0.87 green:0.32 blue:0.32 alpha:1];
    plot.dataLineStyle = lineStyle;
    
    // Put an area color under the plot above
    CPTColor *areaColor       = [CPTColor colorWithComponentRed:0.87 green:0.32 blue:0.32 alpha:0.2];
    CPTFill *areaGradientFill = [CPTFill fillWithColor:areaColor];
    plot.areaFill      = areaGradientFill;
    plot.areaBaseValue = CPTDecimalFromDouble(0);
    
    // Let's keep it simple and let this class act as datasource (therefore we implemtn <CPTPlotDataSource>)
    plot.dataSource = self;
    //[plotSpace setDelegate:self];
    
    // Finally, add the created plot to the default plot space of the CPTGraph object we created before
    [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
    
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
    gridLineStyle.lineColor = [CPTColor colorWithComponentRed:80 green:80 blue:80 alpha:0.1];
    gridLineStyle.lineWidth = 1.0f;
    // 2 - Get axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) hostView.hostedGraph.axisSet;
    // 3 - Configure x-axis
    x = axisSet.xAxis;
    x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0];
    x.title = @"Time";
    x.titleOffset = 60.0f;
    x.titleTextStyle = axisTitleStyle;
    x.labelTextStyle = axisTextStyle;
    // 4 - Configure y-axis
    CPTXYAxis *y = axisSet.yAxis;
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0];
    y.title = @"Gas consumption (dm3)";
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset = -50.0f;
    y.axisLineStyle = axisLineStyle;
    y.majorGridLineStyle = gridLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.labelTextStyle = axisTextStyle;
    y.labelOffset = 26.0f;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 4.0f;
    y.minorTickLength = 2.0f;
    y.tickDirection = CPTSignPositive;
    NSInteger majorIncrement = 100;
    NSInteger minorIncrement = 50;
    
    [super viewDidLoad];
    
    CGFloat yMax = ([[graphDataDictionary valueForKeyPath:@"@max.consgas.floatValue"] floatValue] - [[[graphDataDictionary objectAtIndex:0] objectForKey:@"consgas"] floatValue])*1000.0f; // Determine the maximum y-value.
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    for (NSInteger j = minorIncrement; j <= yMax; j += minorIncrement) {
        NSUInteger mod = j % majorIncrement;
        if (mod == 0) {
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i", j] textStyle:y.labelTextStyle];
            NSDecimal location = CPTDecimalFromInteger(j);
            label.tickLocation = location;
            label.offset = -y.majorTickLength - y.labelOffset;
            if (label) {
                [yLabels addObject:label];
            }
            [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
        } else {
            [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
        }
    }
    y.axisLabels = yLabels;
    y.majorTickLocations = yMajorLocations;
    y.minorTickLocations = yMinorLocations;
    
    x.labelingPolicy = CPTAxisLabelingPolicyNone; // This allows us to create custom axis labels for x axis
    
    hostView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    //hostView.allowPinchScaling = NO;
    
    [plotSpace scaleToFitPlots:[graph allPlots]];

    //NSURL *url = [NSURL URLWithString:@"http://www.energy.xk140.nl/stockOptionsHarvSmall.php?year=2014&month=04&day=05"];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //[_WebView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords {
    return graphDataDictionary.count;
}

// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    // This method is actually called twice per point in the plot, one for the X and one for the Y value
    if (fieldEnum == CPTScatterPlotFieldX)
    {
        // Return the x-value of the current point.
        return [NSNumber numberWithInt:index];
    } else {
        // Return the y-value of the current point.
        NSDictionary *graph = [graphDataDictionary objectAtIndex:index];
        NSNumber *consgas = [NSNumber numberWithFloat: ([[graph objectForKey:@"consgas"] floatValue] - [[[graphDataDictionary objectAtIndex:0] objectForKey:@"consgas"] floatValue])*1000.0f];
        return consgas;
    }
}

- (void)parseJson
{
    NSData *jsonData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.energy.xk140.nl/db_information.php?json=meas"]];
    
    NSError *error;
    NSMutableDictionary *energyData = [NSJSONSerialization
                                       JSONObjectWithData:jsonData
                                       options:NSJSONReadingMutableContainers
                                       error:&error];
    
    if (error)
    {
        NSLog(@"%@", [error localizedDescription]);
    }
    else
    {
        _GasUsage.text = [NSString stringWithFormat:@"%@ m3", [energyData objectForKey:@"consgas"]];
    }
    
    // Reloading the json information into the plot.
    NSError *graphDataError;
    graphData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.energy.xk140.nl/json_data.php?type=cons"]];
    graphDataDictionary = [NSJSONSerialization
                           JSONObjectWithData:graphData
                           options:kNilOptions
                           error:&graphDataError];
    xAxisDateLabels = [[NSMutableArray alloc] init];
    
    [self generateXAxisDates];
    
    [plot reloadData];
}

- (void)generateXAxisDates
{
    for (unsigned int i = 0; i < graphDataDictionary.count; i++)
    {
        NSDictionary *graph = [graphDataDictionary objectAtIndex:i];
        NSNumber *timestamp = [NSNumber numberWithUnsignedInt: [[graph objectForKey:@"timestamp"] intValue]];
        NSTimeInterval _interval = timestamp.doubleValue - (60*60)*2;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *_formatter= [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"hh:mm:ss"];
        [xAxisDateLabels addObject:[_formatter stringFromDate:date]];
    }
    
    NSMutableArray *ticks = [NSMutableArray arrayWithCapacity:1];
    for(unsigned int counter = 0; counter < [xAxisDateLabels count]; counter++) {
        // Here the instance variable xAxisDataLabels is a list of custom labels
        [ticks addObject:[NSNumber numberWithInt:counter]];
    }
    NSUInteger labelLocation = 0;
    NSMutableArray* customLabels = [NSMutableArray arrayWithCapacity:[xAxisDateLabels count]];
    @try {
        for (unsigned int i = 0; i < xAxisDateLabels.count; i++)
        {
            CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText: [xAxisDateLabels objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
            if (i % 10 == 0) // Making sure only a date is printed 1 out of 10.
            {
                newLabel.tickLocation = [[NSNumber numberWithInt:i] decimalValue];
                newLabel.offset = x.labelOffset + x.majorTickLength;
                newLabel.rotation = M_PI/3.5f;
                [customLabels addObject:newLabel];
            }
        }
    }
    @catch (NSException * e) {
        NSLog(@"An exception occurred while creating date labels for x-axis");
    }
    @finally {
        x.axisLabels =  [NSSet setWithArray:customLabels];
    }
    x.majorTickLocations = [NSSet setWithArray:ticks];
}



@end
