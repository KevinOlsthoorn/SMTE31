//
//  ProfitViewController.m
//  Energy Manager
//
//  Created by Kevin Olsthoorn on 24-02-14.
//  Copyright (c) 2014 Olsthoorn Webdevelopment. All rights reserved.
//

#import "ProfitViewController.h"

@interface ProfitViewController ()

@end

@implementation ProfitViewController

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
    // Initializing the json data variable.
    NSData *jsonData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.energy.xk140.nl/db_information.php?json=conv"]];
    
    // Reading the json data and saving them in an NSMutableDictionary.
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
        float investment = 3250.0f;
        NSString *investmentS = [NSString stringWithFormat:@"%.2f", investment];
        _Investment.text = [NSString stringWithFormat:@"€ %@", investmentS];
        
        float earnings = [[energyData objectForKey:@"energylifetime"] floatValue] * 0.215f;
        _Earnings.text = [NSString stringWithFormat:@"€ %.2f", earnings];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setYear:2013];
        [components setMonth:4];
        [components setDay:13];
        NSDate *purchaseData = [calendar dateFromComponents:components];
        NSDate *now = [NSDate date];
        
        float differenceInSeconds = [now timeIntervalSinceDate:purchaseData];
        float percentageTillReturn = (earnings / investment) * 100.0f;
        float intervalUntilReturn = (differenceInSeconds/percentageTillReturn)*100;
        
        NSDate *returnOffInvestment = [NSDate dateWithTimeInterval:intervalUntilReturn sinceDate:purchaseData];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterLongStyle];
        _ReturnOnInvestment.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:returnOffInvestment]];
        
        float emissionReduction = [[energyData objectForKey:@"energylifetime"] floatValue] * 0.7f;
        _EmissionReduction.text = [NSString stringWithFormat:@"%.2f %@", emissionReduction, @"kg"];
    }
}

@end
