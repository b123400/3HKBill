//
//  EditableCell.h
//  3HKBill
//
//  Created by Brian on 8/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditableCell : UITableViewCell {
	UITextField *textField;
}
@property(retain,nonatomic) UITextField *textField;

@end
