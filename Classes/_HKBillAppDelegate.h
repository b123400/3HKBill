//
//  _HKBillAppDelegate.h
//  3HKBill
//
//  Created by Brian on 8/8/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@class MainViewController;

@interface _HKBillAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;

@end

