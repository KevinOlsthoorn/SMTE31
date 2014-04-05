//
//  MainViewController.h
//  Energy Manager
//
//  Created by Kevin Olsthoorn on 24-02-14.
//  Copyright (c) 2014 Olsthoorn Webdevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MainViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *DistanceLabel;

@end
