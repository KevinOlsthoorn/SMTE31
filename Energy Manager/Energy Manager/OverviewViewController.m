//
//  OverviewViewController.m
//  Energy Manager
//
//  Created by Kevin Olsthoorn on 24-02-14.
//  Copyright (c) 2014 Olsthoorn Webdevelopment. All rights reserved.
//

#import "OverviewViewController.h"

@interface OverviewViewController ()

@end

@implementation OverviewViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)parseJson
{
    // Initializing the json data variables.
    NSData *jsonDataConv = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.energy.xk140.nl/db_information.php?json=conv"]];
    NSData *jsonDataMeas = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.energy.xk140.nl/db_information.php?json=meas"]];
    
    // Reading the json data and saving them in an NSMutableDictionary.
    NSError *errorConv;
    NSMutableDictionary *energyDataConv = [NSJSONSerialization
                                           JSONObjectWithData:jsonDataConv
                                           options:NSJSONReadingMutableContainers
                                           error:&errorConv];
    
    NSError *errorMeas;
    NSMutableDictionary *energyDataMeas = [NSJSONSerialization
                                           JSONObjectWithData:jsonDataMeas
                                           options:NSJSONReadingMutableContainers
                                           error:&errorMeas];
    
    
    if (errorConv || errorMeas)
    {
        if (errorConv)
        {
            NSLog(@"%@", [errorConv localizedDescription]);
        }
        if (errorMeas)
        {
            NSLog(@"%@", [errorMeas localizedDescription]);
        }
    }
    else
    {
        // Setting the value of the json data in the labels.
        _Panel1Power.text = [NSString stringWithFormat:@"%@%@", [energyDataConv objectForKey:@"power1"], @" Watt"];
        _Panel2Power.text = [NSString stringWithFormat:@"%@%@", [energyDataConv objectForKey:@"power2"], @" Watt"];
        _SolarPower.text = [NSString stringWithFormat:@"%@%@", [energyDataConv objectForKey:@"netpower"], @" Watt"];
        
        float netPower = ([[energyDataMeas objectForKey:@"harvact"] floatValue] - [[energyDataMeas objectForKey:@"consact"] floatValue]) * 1000.0f;
        
        NSString *netPowerS = [NSString stringWithFormat:@"%.1f", fabsf(netPower)];
        _NetPower.text = [NSString stringWithFormat:@"%@%@", netPowerS, @" Watt"];
        _HousePower.text = [NSString stringWithFormat:@"%.1f%@", fabsf([[energyDataMeas objectForKey:@"usedEnergy"] floatValue]), @" Watt"];
        
        _NetPowerArrow.text = netPower <= 0 ? @"→" : @"←";
    }
}

@end
