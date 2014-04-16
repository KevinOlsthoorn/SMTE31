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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        NSDictionary *graph = [super.graphDataDictionary objectAtIndex:index];
        return [NSNumber numberWithFloat: ([[graph objectForKey:@"consgas"] floatValue] - [[[super.graphDataDictionary objectAtIndex:0] objectForKey:@"consgas"] floatValue])*1000.0f];
    }
}

- (void)setGraphSettings
{
    super.y.title = @"Gas today (dm3)";
    super.yMaxValue = ([[super.graphDataDictionary valueForKeyPath:@"@max.consgas.floatValue"] floatValue] - [[[super.graphDataDictionary objectAtIndex:0] objectForKey:@"consgas"] floatValue])*1000.0f;
    if (super.yMaxValue != 0)
    {
        unsigned short increment = super.yMaxValue / 30; // Making sure we'll only see 30 y-points in our graph.
        if (increment >= 10) increment = (increment/10)*10; // Making sure the value is a round number.
        super.majorIncrement = increment;
        super.minorIncrement = increment;
    }
    else
    {
        super.majorIncrement = 2;
        super.minorIncrement = 1;
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
        // Setting the value of the json data in the labels.
        _GasUsage.text = [NSString stringWithFormat:@"%@ m3", [energyData objectForKey:@"consgas"]];
    }
    
    // Reloading the json information into the plot.
    NSError *graphDataError;
    super.graphData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.energy.xk140.nl/json_data.php?type=cons"]];
    super.graphDataDictionary = [NSJSONSerialization
                           JSONObjectWithData:super.graphData
                           options:kNilOptions
                           error:&graphDataError];
    super.xAxisDateLabels = [[NSMutableArray alloc] init];
    
    [super generateXAxisDates];
    
    [super.plot reloadData];
}

@end
