//
//  FlipsideViewController.m
//  3HKBill
//
//  Created by Brian on 8/8/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FlipsideViewController.h"
#import "EditableCell.h"

@implementation FlipsideViewController

@synthesize delegate, myTable, password;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];   
	if (nameCell == nil) {
        nameCell = [[EditableCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"nameCell"];
    }
    [nameCell.textField setPlaceholder:@""];
}


- (IBAction)done {
	EditableCell *cell=[myTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	if(![cell.textField.text isEqualToString:@""]){
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
		NSString *documentsDirectoryPath = [paths objectAtIndex:0];
		NSString *myFilePath = [documentsDirectoryPath stringByAppendingPathComponent:@"password.txt"];	
		NSError *error;
		NSLog(cell.textField.text);
		if(![cell.textField.text writeToFile:myFilePath atomically:NO encoding:NSASCIIStringEncoding error:&error]){
			NSLog([error description]);
		}else{
			NSLog(@"wrote");
			[self.delegate flipsideViewControllerDidFinish:self];
		}
	}else{
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"密碼不能為空" message:@"請輸入你那個3甚麼的密碼" delegate: self cancelButtonTitle: @"確認" otherButtonTitles: nil];
		[someError show];
		[someError release];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }	
    if (indexPath.section == 0) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
		NSString *documentsDirectoryPath = [paths objectAtIndex:0];
		NSString *myFilePath = [documentsDirectoryPath stringByAppendingPathComponent:@"password.txt"];
		if([[NSFileManager defaultManager] fileExistsAtPath:myFilePath]){
			NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
			NSString *docDir = [arrayPaths objectAtIndex:0];
			NSError *error;
			nameCell.textField.text=[NSString stringWithContentsOfFile:[docDir stringByAppendingPathComponent:@"password.txt"] encoding:NSASCIIStringEncoding error:&error];
			//NSLog([error description]);
		}
		nameCell.textField.secureTextEntry=YES;
        return nameCell;
    }
	
    return cell;	
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return @"\n\nPlease Enter thing here";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */
- (void)viewDidAppear:(BOOL)animated{
    [nameCell.textField becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated {
    // いらないかもしれないけど
    [nameCell.textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
