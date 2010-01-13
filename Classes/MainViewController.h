//
//  MainViewController.h
//  3HKBill
//
//  Created by Brian on 8/8/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UITableViewDataSource> {
	NSMutableArray *datas;
	NSMutableDictionary *receivedData;
	NSMutableDictionary *receivedResponse;
	NSMutableArray *tempArray;
	NSMutableString *currentString;
	IBOutlet UITableView *myTable;
	IBOutlet UIActivityIndicatorView *loading;
}
@property(retain,nonatomic) NSMutableArray *datas;
@property(retain,nonatomic) NSMutableDictionary *receivedData;
@property(retain,nonatomic) NSMutableDictionary *receivedResponse;
@property(retain,nonatomic) NSMutableArray *tempArray;
@property(retain,nonatomic) NSMutableString *currentString;
@property(retain,nonatomic) UITableView *myTable;
@property(retain,nonatomic) UIActivityIndicatorView *loading;

- (IBAction)showInfo;

@end
