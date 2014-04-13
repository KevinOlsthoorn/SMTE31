//
//  ConsumptionViewController.h
//  Energy Manager
//
//  Created by Kevin Olsthoorn on 24-02-14.
//  Copyright (c) 2014 Olsthoorn Webdevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "JsonGraphViewController.h"

@interface ConsumptionViewController : JsonGraphViewController

@property (weak, nonatomic) IBOutlet UILabel *ConsumptionUsage;
@property (weak, nonatomic) IBOutlet UILabel *ConsumptionActual;
@property (weak, nonatomic) IBOutlet UILabel *ConsumptionLow;
@property (weak, nonatomic) IBOutlet UILabel *ConsumptionHigh;

@property (weak, nonatomic) IBOutlet UILabel *HarvestingActual;
@property (weak, nonatomic) IBOutlet UILabel *HarvestingLow;
@property (weak, nonatomic) IBOutlet UILabel *HarvestingHigh;

@property (weak, nonatomic) IBOutlet UIScrollView *GraphScrollView;

@end
