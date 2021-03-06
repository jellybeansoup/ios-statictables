//
// Copyright © 2019 Daniel Farrelly
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// *	Redistributions of source code must retain the above copyright notice, this list
//		of conditions and the following disclaimer.
// *	Redistributions in binary form must reproduce the above copyright notice, this
//		list of conditions and the following disclaimer in the documentation and/or
//		other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "JSMStaticTextPreference.h"

@interface JSMStaticTextPreference ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;

@end

@interface JSMStaticRow ()

- (void)performDefaultConfiguration:(UITableViewCell *)cell;

- (void)performCustomConfiguration:(UITableViewCell *)cell;

@end

@implementation JSMStaticTextPreference

@dynamic value;
@dynamic defaultValue;

#pragma mark - User Interface

- (void)loadControl {
	UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake( 0, 0, 180, 44 )];
	textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	textField.placeholder = self.text;
	textField.text = self.value;
	[textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
	[textField addTarget:self action:@selector(updatePreferenceValue:) forControlEvents:UIControlEventEditingDidEnd];

	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:textField action:@selector(becomeFirstResponder)];
	gestureRecognizer.numberOfTapsRequired = 1;
	gestureRecognizer.numberOfTouchesRequired = 1;
	_gestureRecognizer = gestureRecognizer;

	super.control = (UIControl *)textField;
}

- (UITextField *)textField {
    return (UITextField *)self.control;
}

#pragma mark - Configuring the cell

- (void)prepareCell:(UITableViewCell *)cell {
	[self performDefaultConfiguration:cell];

    if( self.control != nil ) {
		[cell addGestureRecognizer:self.gestureRecognizer];

		if( self.selectionStyle != UITableViewCellSelectionStyleNone ) {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if( ! self.fitControlToCell ) {
			if( ! [self.control.superview isEqual:cell.contentView] ) {
				[cell.contentView addSubview:self.control];
			}

			self.control.translatesAutoresizingMaskIntoConstraints = NO;
			[cell.contentView addConstraints:@[
											  [NSLayoutConstraint constraintWithItem:self.control attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTopMargin multiplier:1 constant:0],
											  [NSLayoutConstraint constraintWithItem:self.control attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottomMargin multiplier:1 constant:0],
											  [NSLayoutConstraint constraintWithItem:self.control attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationLessThanOrEqual toItem:cell.textLabel attribute:NSLayoutAttributeRightMargin multiplier:1 constant:30],
											  [NSLayoutConstraint constraintWithItem:self.control attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeRightMargin multiplier:1 constant:0]
											  ]];
        }
        else if( self.fitControlToCell ) {
			if( ! [self.control.superview isEqual:cell.contentView] ) {
				[cell.contentView addSubview:self.control];
			}

			self.control.translatesAutoresizingMaskIntoConstraints = NO;
			[cell.contentView addConstraints:@[
											  [NSLayoutConstraint constraintWithItem:self.control attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTopMargin multiplier:1 constant:0],
											  [NSLayoutConstraint constraintWithItem:self.control attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottomMargin multiplier:1 constant:0],
											  [NSLayoutConstraint constraintWithItem:self.control attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeftMargin multiplier:1 constant:0],
											  [NSLayoutConstraint constraintWithItem:self.control attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeRightMargin multiplier:1 constant:0]
											  ]];
        }
    }

	[self performCustomConfiguration:cell];
}

#pragma mark - Updating the value

- (void)valueDidChange {
    if( self.isControlLoaded && ! [self.textField.text isEqual:self.value] ) {
        self.textField.text = self.value;
    }
}

#pragma mark - Event Handling

// We use a timer to try and update the value only once the user has finished typing.
- (void)textFieldChanged:(UITextField *)textField {
    if( self.timer != nil && self.timer.isValid ) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)timerFired:(NSTimer *)timer {
    self.value = self.textField.text;
}

- (void)updatePreferenceValue:(UITextField *)textField {
    self.value = textField.text;
}

@end
