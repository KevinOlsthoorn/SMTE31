//
//  HarvestingViewController.m
//  Energy Manager
//
//  Created by Kevin Olsthoorn on 24-02-14.
//  Copyright (c) 2014 Olsthoorn Webdevelopment. All rights reserved.
//

#import "HarvestingViewController.h"

@interface HarvestingViewController ()

@end

@implementation HarvestingViewController

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
        NSNumber *dailyenergy = [NSNumber numberWithFloat: [[graph objectForKey:@"dailyenergy"] floatValue]];
        return dailyenergy;
    }
}

- (void)setGraphSettings
{
    super.y.title = @"Total energy (Wh)";
    super.yMaxValue = [[super.graphDataDictionary valueForKeyPath:@"@max.dailyenergy.floatValue"] floatValue];
    super.lineStyle.lineColor = [CPTColor colorWithComponentRed:0.44 green:0.56 blue:0.71 alpha:1];
    super.areaColor = [CPTColor colorWithComponentRed:0.44 green:0.56 blue:0.71 alpha:0.2];
}

- (void)parseJson
{
    NSData *jsonData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.energy.xk140.nl/db_information.php?json=conv"]];
    
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
        _EnergyLifetime.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"energylifetime"], @" kWh"];
        _PowerPeakLifetime.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"powerpeak"], @" W"];
        _EnergyToday.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"dailyenergy"], @" Wh"];
        _PowerPeakToday.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"dailypowerpeak"], @" W"];
        
        _Input1Voltage.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"voltage1"], @" V"];
        _Input1Current.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"current1"], @" A"];
        _Input1Power.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"power1"], @" W"];
        
        _Input2Voltage.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"voltage2"], @" V"];
        _Input2Current.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"current2"], @" A"];
        _Input2Power.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"power2"], @" W"];
        
        _PowerIn.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"power"], @" W"];
        _PowerOut.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"netpower"], @" W"];
        _PowerEfficiency.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"efficiency"], @" %"];
        
        _GridVoltage.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"netvoltage"], @" W"];
        _GridCurrent.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"netcurrent"], @" A"];
        _GridFrequency.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"netfrequency"], @" Hz"];
    }
    // Reloading the json information into the plot.
    NSError *graphDataError;
    super.graphData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.energy.xk140.nl/json_data.php?type=harv"]];
    super.graphDataDictionary = [NSJSONSerialization
                           JSONObjectWithData:super.graphData
                           options:kNilOptions
                           error:&graphDataError];
    super.xAxisDateLabels = [[NSMutableArray alloc] init];
    
    [self generateXAxisDates];
    
    [super.plot reloadData];
}

@end
