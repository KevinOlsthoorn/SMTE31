//
//  ConsumptionViewController.m
//  Energy Manager
//
//  Created by Kevin Olsthoorn on 24-02-14.
//  Copyright (c) 2014 Olsthoorn Webdevelopment. All rights reserved.
//

#import "ConsumptionViewController.h"

@interface ConsumptionViewController ()

@end

@implementation ConsumptionViewController

NSData *graphData;
NSArray *graphDataDictionary;
NSMutableArray *xAxisDateLabels;

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSError *graphDataError;
    graphData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.energy.xk140.nl/json_data.php?type=cons"]];
    graphDataDictionary = [NSJSONSerialization
                                       JSONObjectWithData:graphData
                                       options:kNilOptions
                                       error:&graphDataError];
    xAxisDateLabels = [[NSMutableArray alloc] init];
    
    // We need a hostview, you can create one in IB (and create an outlet) or just do this:
    CPTGraphHostingView* hostView = [[CPTGraphHostingView alloc] initWithFrame:_hostView.frame];
    [self.view addSubview: hostView];
    
    // Create a CPTGraph object and add to hostView
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTSlateTheme];
    graph.plotAreaFrame.paddingLeft = 60.0;
    graph.plotAreaFrame.paddingBottom = 60.0;
    [graph applyTheme:theme];
    hostView.hostedGraph = graph;
    
    // Get the (default) plotspace from the graph so we can set its x/y ranges
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    plotSpace.allowsUserInteraction = YES;
    
    // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
    CPTScatterPlot* plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    
    // Let's keep it simple and let this class act as datasource (therefore we implemtn <CPTPlotDataSource>)
    plot.dataSource = self;
    
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
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 1.0f;
    // 2 - Get axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) hostView.hostedGraph.axisSet;
    // 3 - Configure x-axis
    CPTAxis *x = axisSet.xAxis;
    CPTAxis *y = axisSet.yAxis;
    y.title = @"Usage (Watt)";
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset = -40.0f;
    y.axisLineStyle = axisLineStyle;
    y.majorGridLineStyle = gridLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.labelTextStyle = axisTextStyle;
    y.labelOffset = 16.0f;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 4.0f;
    y.minorTickLength = 2.0f;
    y.tickDirection = CPTSignPositive;
    NSInteger majorIncrement = 100;
    NSInteger minorIncrement = 50;
    CGFloat yMax = 2000.0f;
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
    
    x.labelingPolicy = CPTAxisLabelingPolicyNone; // This allows us to create custom axis labels for x axis
    NSMutableArray *ticks = [NSMutableArray arrayWithCapacity:1];
    for(unsigned int counter = 0; counter < [xAxisDateLabels count];counter++) {
        // Here the instance variable _axisLabelStrings is a list of custom labels
        [ticks addObject:[NSNumber numberWithInt:counter]];
    }
    NSUInteger labelLocation = 0;
    NSMutableArray* customLabels = [NSMutableArray arrayWithCapacity:[xAxisDateLabels count]];
    @try {
        for (NSNumber *tickLocation in ticks) {
            CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText: [xAxisDateLabels objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
            newLabel.tickLocation = [tickLocation decimalValue];
            newLabel.offset = x.labelOffset + x.majorTickLength;
            newLabel.rotation = M_PI/3.5f;
            [customLabels addObject:newLabel];
        }
    }
    @catch (NSException * e) {
        NSLog(@"An exception occurred while creating date labels for x-axis");
    }
    @finally {
        x.axisLabels =  [NSSet setWithArray:customLabels];
    }
    x.majorTickLocations = [NSSet setWithArray:ticks];
    
    hostView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    //hostView.allowPinchScaling = NO;
    
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
    return graphDataDictionary.count;
}

// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    // This method is actually called twice per point in the plot, one for the X and one for the Y value
    if(fieldEnum == CPTScatterPlotFieldX)
    {
        // Return the x-value of the current point.
        return [NSNumber numberWithInt:index];
    } else {
        // Return the x-value of the current point.
        NSDictionary *graph = [graphDataDictionary objectAtIndex:index];
        return [NSNumber numberWithFloat: [[graph objectForKey:@"consact"] floatValue] * 1000.0f];
    }
}

- (void)parseJson
{
    NSData *jsonData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.energy.xk140.nl/db_information.php?json=meas"]];
    
    NSError *error;
    NSMutableDictionary *energyData = [NSJSONSerialization
                                       JSONObjectWithData:jsonData
                                       options:NSJSONReadingMutableLeaves
                                       error:&error];

    if (error)
    {
        NSLog(@"%@", [error localizedDescription]);
    }
    else
    {
        _ConsumptionUsage.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"consact"], @" Watt"];
        _ConsumptionActual.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"consact"], @" Watt"];
        _ConsumptionLow.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"conslow"], @" kWh"];
        _ConsumptionHigh.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"conshigh"], @" kWh"];
        
        _HarvestingActual.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"harvact"], @" Watt"];
        _HarvestingLow.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"harvlow"], @" kWh"];
        _HarvestingHigh.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"harvhigh"], @" kWh"];
    }
}

@end
