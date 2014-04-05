//
//  ProfitViewController.h
//  Energy Manager
//
//  Created by Kevin Olsthoorn on 24-02-14.
//  Copyright (c) 2014 Olsthoorn Webdevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonViewController.h"

@interface ProfitViewController : JsonViewController

@property (weak, nonatomic) IBOutlet UILabel *Investment;
@property (weak, nonatomic) IBOutlet UILabel *Earnings;
@property (weak, nonatomic) IBOutlet UILabel *ReturnOnInvestment;

@property (weak, nonatomic) IBOutlet UILabel *EmissionReduction;

@end
