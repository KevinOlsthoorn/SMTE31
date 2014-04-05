//
//  MainViewController.m
//  Energy Manager
//
//  Created by Kevin Olsthoorn on 24-02-14.
//  Copyright (c) 2014 Olsthoorn Webdevelopment. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

CLLocationManager *locationManager;
CLLocation *panelLocation;

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
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    panelLocation = [[CLLocation alloc] initWithLatitude:51.45637 longitude:5.63576];
    [self initGPS];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initGPS
{
    // Initializing the locationManager.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}


// The locationManager's delegate which gets called if the position is updated.
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    float distance = [newLocation distanceFromLocation:panelLocation];
    NSString *distanceUnit = @"m";
    // Checking if the distance is 1000 meters or more. If it is, convert the distance to km.
    if (distance >= 1000)
    {
        distance /= 1000;
        distanceUnit = @"km";
    }
    _DistanceLabel.text = [NSString stringWithFormat:@"You are %.1f%@ away from the solar panels!", distance, distanceUnit];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Energy Manager was unable to use your location." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
}

@end
