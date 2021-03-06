//
//  CustomURLConnection.m
//  YO!
//
//  Created by Brian on 8/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CustomURLConnection.h"


@implementation CustomURLConnection

@synthesize tag;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately tag:(NSString*)tag {
	self = [super initWithRequest:request delegate:delegate startImmediately:startImmediately];
	
	if (self) {
		self.tag = tag;
	}
	return self;
}

- (void)dealloc {
	[tag release];
	[super dealloc];
}

@end