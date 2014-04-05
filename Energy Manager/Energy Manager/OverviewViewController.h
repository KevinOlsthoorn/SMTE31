//
//  OverviewViewController.h
//  Energy Manager
//
//  Created by Kevin Olsthoorn on 24-02-14.
//  Copyright (c) 2014 Olsthoorn Webdevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonViewController.h"

@interface OverviewViewController : JsonViewController

@property (weak, nonatomic) IBOutlet UILabel *Panel1Power;
@property (weak, nonatomic) IBOutlet UILabel *Panel2Power;
@property (weak, nonatomic) IBOutlet UILabel *SolarPower;
@property (weak, nonatomic) IBOutlet UILabel *NetPower;
@property (weak, nonatomic) IBOutlet UILabel *HousePower;

@property (weak, nonatomic) IBOutlet UILabel *NetPowerArrow;

@end
