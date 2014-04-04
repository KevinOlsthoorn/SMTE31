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
	// Do any additional setup after loading the view.
    
    [self parseJson];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}

@end
