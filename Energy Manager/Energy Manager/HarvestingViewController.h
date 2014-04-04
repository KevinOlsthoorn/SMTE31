//
//  HarvestingViewController.h
//  Energy Manager
//
//  Created by Kevin Olsthoorn on 24-02-14.
//  Copyright (c) 2014 Olsthoorn Webdevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HarvestingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *EnergyLifetime;
@property (weak, nonatomic) IBOutlet UILabel *PowerPeakLifetime;
@property (weak, nonatomic) IBOutlet UILabel *EnergyToday;
@property (weak, nonatomic) IBOutlet UILabel *PowerPeakToday;

@property (weak, nonatomic) IBOutlet UILabel *Input1Voltage;
@property (weak, nonatomic) IBOutlet UILabel *Input1Current;
@property (weak, nonatomic) IBOutlet UILabel *Input1Power;

@property (weak, nonatomic) IBOutlet UILabel *Input2Voltage;
@property (weak, nonatomic) IBOutlet UILabel *Input2Current;
@property (weak, nonatomic) IBOutlet UILabel *Input2Power;

@property (weak, nonatomic) IBOutlet UILabel *PowerIn;
@property (weak, nonatomic) IBOutlet UILabel *PowerOut;
@property (weak, nonatomic) IBOutlet UILabel *PowerEfficiency;

@property (weak, nonatomic) IBOutlet UILabel *GridVoltage;
@property (weak, nonatomic) IBOutlet UILabel *GridCurrent;
@property (weak, nonatomic) IBOutlet UILabel *GridFrequency;

@end
