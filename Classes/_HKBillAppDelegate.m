//
//  _HKBillAppDelegate.m
//  3HKBill
//
//  Created by Brian on 8/8/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "_HKBillAppDelegate.h"
#import "MainViewController.h"

@implementation _HKBillAppDelegate


@synthesize window;
@synthesize mainViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
