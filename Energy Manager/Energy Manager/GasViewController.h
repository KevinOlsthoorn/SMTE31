//
//  GasViewController.h
//  Energy Manager
//
//  Created by Kevin Olsthoorn on 24-02-14.
//  Copyright (c) 2014 Olsthoorn Webdevelopment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "JsonGraphViewController.h"

@interface GasViewController : JsonGraphViewController

@property (weak, nonatomic) IBOutlet UILabel *GasUsage;
@property (weak, nonatomic) IBOutlet UIWebView *WebView;

@property (weak, nonatomic) IBOutlet UIScrollView *GraphScrollView;

@end
