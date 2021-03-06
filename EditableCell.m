//
//  EditableCell.m
//  3HKBill
//
//  Created by Brian on 8/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EditableCell.h"


@implementation EditableCell
@synthesize textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
        textField = [[UITextField alloc] initWithFrame:CGRectZero];
        textField.font = [UIFont systemFontOfSize:20.0];
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        // TextFieldの右側にＸボタンを表示
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
		textField.keyboardType= UIKeyboardTypeNumberPad;
        // テキストフィールドをテーブルビューセルに追加
        [self addSubview:textField];
    }
    return self;
}

- (void)layoutSubviews {
    // CGRectInset : 中央を固定し、オフセットでdx,dyを指定する
    // この場合もとのサイズよりも小さくなる
    textField.frame = CGRectInset(self.contentView.bounds, 20, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
