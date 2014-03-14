//
//  DetailsViewController.m
//  TableAndJsonTest
//
//  Created by Kevin Olsthoorn on 14-03-14.
//  Copyright (c) 2014 Olsthoorn Webdevelopment. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *pirateName;
@property (weak, nonatomic) IBOutlet UILabel *pirateLife;
@property (weak, nonatomic) IBOutlet UILabel *pirateActiveYears;
@property (weak, nonatomic) IBOutlet UILabel *pirateCountryOfBirth;
@property (weak, nonatomic) IBOutlet UITextView *pirateComments;

@end

@implementation DetailsViewController

-(void) viewDidAppear:(BOOL)animated
{
    self.pirateName.text = self.selectedPirate.name;
    self.pirateLife.text = self.selectedPirate.life;
    self.pirateActiveYears.text = self.selectedPirate.yearsActive;
    self.pirateCountryOfBirth.text = self.selectedPirate.countryOfOrigin;
    self.pirateComments.text = self.selectedPirate.comments;
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
