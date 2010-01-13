//
//  FlipsideViewController.h
//  3HKBill
//
//  Created by Brian on 8/8/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@protocol FlipsideViewControllerDelegate;
#import "EditableCell.h"


@interface FlipsideViewController : UIViewController <UITableViewDataSource>{
	id <FlipsideViewControllerDelegate> delegate;
	EditableCell *nameCell;
	IBOutlet UITableView *myTable;
	NSString *password;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) UITableView *myTable;
@property (nonatomic, retain) NSString *password;

- (IBAction)done;

@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

