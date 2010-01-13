//
//  MainViewController.m
//  3HKBill
//
//  Created by Brian on 8/8/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "CustomURLConnection.h"
#import "Reachability.h"

@implementation MainViewController
@synthesize datas,receivedData, receivedResponse,tempArray,currentString,myTable,loading;

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	if([elementName isEqualToString:@"tr"]){
		[tempArray addObject:[[NSMutableArray alloc] init]];
	}
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	[currentString appendString:string];
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if([elementName isEqualToString:@"td"]){
		[[tempArray objectAtIndex:[tempArray count]-1] addObject:currentString];
	}
	[currentString release];
	currentString=[[NSMutableString alloc] init];
}
- (void)parserDidEndDocument:(NSXMLParser *)parser{
	[datas release];
	datas=[[NSMutableArray alloc]init];
	for(NSArray *this in tempArray){
		if(![[this objectAtIndex:0] isEqualToString:@""]&&![[this objectAtIndex:1] isEqualToString:@""]){
			[datas addObject:this];
		}
	}
	NSLog([datas description]);
	[myTable reloadData];
	[loading stopAnimating];
}
-(void)breakHtml:(NSString*)input{
	if([input rangeOfString:@"Incorrect password."].location==NSNotFound){
		NSRange range=[input rangeOfString:@"<table class=\"VF-0-3-0\">"];
		if(range.location==NSNotFound){
			UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"有點東西搞錯了" message:@"請重新試多一次\n再失敗的話就是這個程式的錯了" delegate: self cancelButtonTitle: @"確認" otherButtonTitles: nil];
			[someError show];
			[someError release];
		}
		//NSString *subString=[input substringFromIndex:range.location+range.length];
		NSString *subString=[input substringFromIndex:range.location];
		range=[subString rangeOfString:@"</table>"];
		if(range.location==NSNotFound){
			UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"有點東西搞錯了" message:@"請重新試多一次\n再失敗的話就是這個程式的錯了" delegate: self cancelButtonTitle: @"確認" otherButtonTitles: nil];
			[someError show];
			[someError release];
		}
		//subString=[subString substringToIndex:range.location];
		subString=[subString substringToIndex:range.location+range.length];
		NSLog(subString);
		NSXMLParser *parser=[[NSXMLParser alloc] initWithData:[subString dataUsingEncoding:NSUTF8StringEncoding]];
		[parser setDelegate:self];
		[parser parse];
	}else{
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"密碼不對" message:@"請重新輸入密碼" delegate: self cancelButtonTitle: @"確認" otherButtonTitles: nil];
		[someError show];
		[someError release];
		FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
		controller.delegate = self;
		
		controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
		[self presentModalViewController:controller animated:YES];
		[controller release];
		
	}
}

- (void)startAsyncLoad:(NSURL*)url tag:(NSString*)tag {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	if([tag isEqualToString:@"second"]){
		NSArray * availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://mobile.three.com.hk"]];
		NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:availableCookies];
		[request setAllHTTPHeaderFields:headers];
		///////////
		NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
		NSString *docDir = [arrayPaths objectAtIndex:0];
		NSError *error;
		NSString *myPassword=[NSString stringWithContentsOfFile:[docDir stringByAppendingPathComponent:@"password.txt"] encoding:NSASCIIStringEncoding error:&error];
		///////////
		NSMutableString *myRequestString = [[NSMutableString alloc] init];
		[myRequestString appendString: @"&vform=s0&_P_PASSWORD="];
		[myRequestString appendString:myPassword];
		[myRequestString appendString:@"&submit=Submit&actionName=ProcessHandsetLoginAction&USING_BACK_SERVLET=false"];
		NSData *myRequestData = [ NSData dataWithBytes: [ myRequestString UTF8String ] length: [ myRequestString length ] ];
		[ request setHTTPMethod: @"POST" ];
		[ request setHTTPBody: myRequestData ];
	}
	[request setValue:@"Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3" forHTTPHeaderField:@"User-Agent"];
	CustomURLConnection *connection = [[CustomURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES tag:tag];
	if (connection) {
		[receivedData setObject:[[NSMutableData data] retain] forKey:connection.tag];
		//[receivedResponse setObject:[NSHTTPURLResponse alloc] forKey:connection.tag];
	}
}

- (NSMutableData*)dataForConnection:(CustomURLConnection*)connection {
	NSMutableData *data = [receivedData objectForKey:connection.tag];
	return data;
}
- (NSString*)tagForConnection:(CustomURLConnection*)connection {
	NSString *tag = connection.tag;
	return tag;
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSMutableData *dataForConnection = [self dataForConnection:(CustomURLConnection*)connection];
	[dataForConnection setLength:0];
	if([[self tagForConnection:(CustomURLConnection*)connection] isEqualToString:@"first"]){
		NSHTTPURLResponse *responsea=response;
		NSArray * all = [NSHTTPCookie cookiesWithResponseHeaderFields:[responsea allHeaderFields] forURL:[NSURL URLWithString:@"http://mobile.three.com.hk"]];
		NSLog(@"How many Cookies: %d", all.count);
		// Store the cookies:
		// NSHTTPCookieStorage is a Singleton.
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:all forURL:[NSURL URLWithString:@"http://mobile.three.com.hk"] mainDocumentURL:nil];
		NSString *sessionToPass=@"aa";
		// Now we can print all of the cookies we have:
		for (NSHTTPCookie *cookie in all){
			NSLog(@"Name: %@ : Value: %@, Expires: %@", cookie.name, cookie.value, cookie.expiresDate);
			if([cookie.name isEqualToString:@"SDFSESSNID"]){
				sessionToPass=cookie.value;
			}
		}
		[self startAsyncLoad:[NSURL URLWithString:[@"http://mobile.three.com.hk/3care/cs;SDFSESSNID=" stringByAppendingString:sessionToPass]] tag:@"second"];
	//NSHTTPURLResponse *responseForConnection=[self responseForConnection:(CustomURLConnection*)connection];
	//responseForConnection = [response copy];
	}

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSMutableData *dataForConnection = [self dataForConnection:(CustomURLConnection*)connection];
	[dataForConnection appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSMutableData *dataForConnection = [self dataForConnection:(CustomURLConnection*)connection];
	if([[self tagForConnection:(CustomURLConnection*)connection] isEqualToString:@"first"]){
		NSString *s=[[NSString alloc] initWithData:dataForConnection encoding:NSUTF8StringEncoding];
		NSLog(s);
		[s release];
	}else{
		NSString *s=[[NSString alloc] initWithData:dataForConnection encoding:NSUTF8StringEncoding];
		//NSString *mything=@"<table class=\"VF-0-3-0\"><tr><td class=\"bgPAD VF-5-3-0\" valign=\"top\">Account:</td><td class=\"bgPAD alignRight VF-5-3-0\" valign=\"top\">29935267</td></tr><tr><td class=\"bgPAD VF-5-3-0\" valign=\"top\">Cycle Start:</td><td class=\"bgPAD alignRight VF-5-3-0\" valign=\"top\">26 Jul</td></tr><tr><td class=\"bgPAD VF-5-3-0\" valign=\"top\">Call Cutoff Date:</td><td class=\"bgPAD alignRight VF-5-3-0\" valign=\"top\">19:24 08Aug2009</td></tr><tr><td class=\"bgPAD bgLIGHTLightBlue bgPAD blue VF-5-3-0\" valign=\"top\">Data:</td><td class=\"bgPAD bgLIGHTLightBlue bgPAD alignRight VF-5-3-0\" valign=\"top\">160455kB</td></tr><tr><td class=\"bgPAD bgDARKLightBlue bgPAD blue VF-5-3-0\" valign=\"top\">Video Call:</td><td class=\"bgPAD bgDARKLightBlue bgPAD alignRight VF-5-3-0\" valign=\"top\">0min</td></tr><tr><td class=\"bgPAD bgLIGHTLightBlue bgPAD blue VF-5-3-0\" valign=\"top\">Basic Voice Call:</td><td class=\"bgPAD bgLIGHTLightBlue bgPAD alignRight VF-5-3-0\" valign=\"top\">125min</td></tr><tr><td class=\"bgPAD bgDARKLightBlue bgPAD blue VF-5-3-0\" valign=\"top\">Intra-3 Voice Call:</td><td class=\"bgPAD bgDARKLightBlue bgPAD alignRight VF-5-3-0\" valign=\"top\">59min</td></tr><tr><td class=\"bgPAD bgLIGHTLightBlue bgPAD blue VF-5-3-0\" valign=\"top\">Total Voice Call:</td><td class=\"bgPAD bgLIGHTLightBlue bgPAD alignRight VF-5-3-0\" valign=\"top\">184min</td></tr><tr><td class=\"bgPAD bgDARKLightBlue bgPAD blue VF-5-3-0\" valign=\"top\">Multimedia Content (M):</td><td class=\"bgPAD bgDARKLightBlue bgPAD alignRight VF-5-3-0\" valign=\"top\">0</td></tr><tr><td class=\"bgPAD bgDARKLightBlue bgPAD blue VF-5-3-0\" valign=\"top\"><a class=\"VE-a\" href=\"/3care/cs?actionName=authorized.CheckUnbillBreakdownAction&amp;infotype=m\">Detailed Usage Record</a></td><td class=\"bgPAD bgDARKLightBlue bgPAD alignRight VF-5-3-0\" valign=\"top\"></td></tr><tr><td class=\"bgPAD bgLIGHTLightBlue bgPAD blue VF-5-3-0\" valign=\"top\">Text Content (T)</td><td class=\"bgPAD bgLIGHTLightBlue bgPAD alignRight VF-5-3-0\" valign=\"top\">0</td></tr><tr><td class=\"bgPAD bgLIGHTLightBlue bgPAD blue VF-5-3-0\" valign=\"top\"><a class=\"VE-a\" href=\"/3care/cs?actionName=authorized.CheckUnbillBreakdownAction&amp;infotype=t\">Detailed Usage Record</a></td><td class=\"bgPAD bgLIGHTLightBlue bgPAD alignRight VF-5-3-0\" valign=\"top\"></td></tr><tr><td class=\"bgPAD bgLIGHTLightBlue bgPAD blue VF-5-3-0\" valign=\"top\">Intra-operator SMS:</td><td class=\"bgPAD bgLIGHTLightBlue bgPAD alignRight VF-5-3-0\" valign=\"top\">18 unit</td></tr><tr><td class=\"bgPAD bgLIGHTLightBlue bgPAD blue VF-5-3-0\" valign=\"top\">Inter-operator SMS:</td><td class=\"bgPAD bgLIGHTLightBlue bgPAD alignRight VF-5-3-0\" valign=\"top\">1 unit</td></tr><tr><td class=\"bgPAD bgLIGHTLightBlue bgPAD blue VF-5-3-0\" valign=\"top\">International SMS:</td><td class=\"bgPAD bgLIGHTLightBlue bgPAD alignRight VF-5-3-0\" valign=\"top\">0 unit</td></tr></table>";
		NSLog(s);
		[self breakHtml:s];
		[s release];
	}
	[connection release];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
	return self;
}

- (BOOL)isDataSourceAvailable {  
	
    static BOOL checkNetwork = YES;  
	static BOOL _isDataSourceAvailable = NO;  
    if (checkNetwork) { // Since checking the reachability of a host can be expensive, cache the result and perform the reachability check once.  
        checkNetwork = NO;  
        Boolean success;  
        const char *host_name = "google.com"; //pretty reliable :)  
        SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);  
        SCNetworkReachabilityFlags flags;  
        success = SCNetworkReachabilityGetFlags(reachability, &flags);  
        _isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);  
        CFRelease(reachability);  
    }  
    return _isDataSourceAvailable;  
}

 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//datas=[[NSArray alloc] initWithObjects:[NSArray arrayWithObjects:@"Data", @"Video Call", @"Basic Voice Call", @"Intra-3 Voive Call", @"Total Voice Call", @"Multimedia Content(M)", @"Text Content", @"Intra-operator SMS", @"Inter-operator SMS", @"International SMS", nil], [NSArray arrayWithObjects:@"Account", @"Cycle Start", @"Call Cutoff Date",nil], nil];
	datas=[[NSMutableArray alloc] init];
	receivedData=[[NSMutableDictionary alloc]init];
	tempArray=[[NSMutableArray alloc] init];
	currentString=[[NSMutableString alloc] init];
	[super viewDidLoad];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text=[[datas objectAtIndex:indexPath.row] objectAtIndex:0];
	cell.detailTextLabel.text=[[datas objectAtIndex:indexPath.row] objectAtIndex:1];
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [datas count];
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

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidAppear:(BOOL)animated{
	if([[Reachability sharedReachability] internetConnectionStatus] == ReachableViaCarrierDataNetwork) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
		NSString *documentsDirectoryPath = [paths objectAtIndex:0];
		NSString *myFilePath = [documentsDirectoryPath stringByAppendingPathComponent:@"password.txt"];
		NSLog(myFilePath);
		if([[NSFileManager defaultManager] fileExistsAtPath:myFilePath]){
			[loading startAnimating];
			[self startAsyncLoad:[NSURL URLWithString:@"http://mobile.three.com.hk/3care/cs?actionName=authorized.CheckUnbillAction"] tag:@"first"];
		}else{
			UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"未有密碼" message:@"請輸入你那個3甚麼的密碼" delegate: self cancelButtonTitle: @"確認" otherButtonTitles: nil];
			[someError show];
			[someError release];
			FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
			controller.delegate = self;
			
			controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
			[self presentModalViewController:controller animated:YES];
			[controller release];
		}
	}else if([[Reachability sharedReachability] internetConnectionStatus] == ReachableViaWiFiNetwork) {
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"厄網絡耶..." message:@"不能用wifi啊" delegate: self cancelButtonTitle: @"確認" otherButtonTitles: nil];
		[someError show];
		[someError release];
	}else{
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"厄網絡耶..." message:@"沒有網絡連接耶" delegate: self cancelButtonTitle: @"確認" otherButtonTitles: nil];
		[someError show];
		[someError release];
	}
	//[super viewDidAppear:animated];
}
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
