//
//  EasterEggViewController.m
//  Kevin's App
//
//  Created by Kevin Olsthoorn on 20-02-14.
//  Copyright (c) 2014 Kevin Olsthoorn. All rights reserved.
//

#import "EasterEggViewController.h"

@interface EasterEggViewController ()

@end

@implementation EasterEggViewController

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
- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
