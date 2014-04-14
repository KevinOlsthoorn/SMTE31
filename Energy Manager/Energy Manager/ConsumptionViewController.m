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
    if(fieldEnum == CPTScatterPlotFieldX)
    {
        // Return the x-value of the current point.
        return [NSNumber numberWithInt:index];
    } else {
        // Return the y-value of the current point.
        NSDictionary *graph = [super.graphDataDictionary objectAtIndex:index];
        return [NSNumber numberWithFloat: ([[graph objectForKey:@"consact"] floatValue] - [[graph objectForKey:@"harvact"] floatValue]) * 1000.0f];
    }
}

- (void)setGraphSettings
{
    super.y.title = @"Energy (Watt)";
    super.yMaxValue = [[super.graphDataDictionary valueForKeyPath:@"@max.consact.floatValue"] floatValue] * 1000.0f;
    super.yMinValue = [[super.graphDataDictionary valueForKeyPath:@"@max.harvact.floatValue"] floatValue] * -1000.0f;
    super.lineStyle.lineColor = [CPTColor greenColor];
    super.areaColor = [CPTColor colorWithComponentRed:0.3 green:1.0 blue:0.3 alpha:0.2];
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
        // Reloading the json information into the labels.
        _ConsumptionUsage.text = [NSString stringWithFormat:@"%.3f%@", fabsf([[energyData objectForKey:@"usedEnergy"] floatValue]), @" Watt"];
        _ConsumptionActual.text = [NSString stringWithFormat:@"%.3f%@", [[energyData objectForKey:@"consact"] floatValue] * 1000.0f, @" Watt"];
        _ConsumptionLow.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"conslow"], @" kWh"];
        _ConsumptionHigh.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"conshigh"], @" kWh"];
        
        _HarvestingActual.text = [NSString stringWithFormat:@"%.3f%@", [[energyData objectForKey:@"harvact"] floatValue] * 1000.0f, @" Watt"];
        _HarvestingLow.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"harvlow"], @" kWh"];
        _HarvestingHigh.text = [NSString stringWithFormat:@"%@%@", [energyData objectForKey:@"harvhigh"], @" kWh"];
        
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
