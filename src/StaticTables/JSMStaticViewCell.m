//
// Copyright © 2014 Daniel Farrelly
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

#import "JSMStaticViewCell.h"
#import "JSMBooleanPreference.h"

@interface JSMStaticViewCell ()

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation JSMStaticViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)prepareForReuse {
    self.accessoryView = nil;
}

# pragma mark - Switch

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor {
    // Create a view
    UIView *selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = selectedBackgroundColor;
    selectedBackgroundView.layer.masksToBounds = YES;
    self.selectedBackgroundView = selectedBackgroundView;
    // Store the value
    _selectedBackgroundColor = selectedBackgroundColor;
}

# pragma mark - Text field

- (void)displayTextFieldWithValue:(NSString *)value {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake( 0, 0, 180, 44 )];
    textField.delegate = self;
    textField.text = value;
    textField.textColor = [UIColor darkTextColor];
    textField.backgroundColor = [UIColor clearColor];
    textField.placeholder = _preference.placeholder;
    textField.autocapitalizationType = _preference.autocapitalizationType ? _preference.autocapitalizationType : UITextAutocapitalizationTypeSentences;
    textField.autocorrectionType = _preference.autocapitalizationType ? _preference.autocapitalizationType : UITextAutocorrectionTypeDefault;
    textField.spellCheckingType = _preference.spellCheckingType ? _preference.spellCheckingType : UITextSpellCheckingTypeDefault;
    textField.enablesReturnKeyAutomatically = _preference.enablesReturnKeyAutomatically;
    textField.keyboardAppearance = _preference.keyboardAppearance ? _preference.keyboardAppearance : UIKeyboardAppearanceDefault;
    textField.keyboardType = _preference.keyboardType ? _preference.keyboardType : UIKeyboardTypeDefault;
    textField.returnKeyType = _preference.returnKeyType ? _preference.returnKeyType : UIReturnKeyDefault;
    textField.secureTextEntry = _preference.isSecureTextEntry;
    [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    self.accessoryView = textField;
    if( textField.placeholder ) {
        CGFloat alpha;
        [[UIColor darkTextColor] getWhite:nil alpha:&alpha];
        UIColor *placeholderColor = [[UIColor darkTextColor] colorWithAlphaComponent:( alpha/2 )];
        [textField setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    }
}

- (void)textFieldChanged:(UITextField *)sender {
    [(JSMBooleanPreference *)_preference setValue:sender.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Deselect the textfield
    [textField resignFirstResponder];
    // Don't do anything else
    return NO;
}

# pragma mark - Switch

- (void)displaySwitchWithValue:(BOOL)value {
    [self displaySwitchWithValue:value target:self action:@selector(switchChanged:)];
}

- (void)displaySwitchWithValue:(BOOL)value target:(id)target action:(SEL)action {
    UISwitch *control = [[UISwitch alloc] init];
    control.on = value;
    [control addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    self.accessoryView = control;
}

- (void)switchChanged:(UISwitch *)sender {
    [(JSMBooleanPreference *)_preference setBoolValue:sender.on];
}

# pragma mark - Activity indicator

- (void)startActivityIndicator {
    // Indicator is already running
    if( _activityIndicator != nil ) {
        return;
    }
    CGFloat y = ( self.frame.size.height - _activityIndicator.frame.size.width ) / 2;
    // Build the activity view
    _activityIndicator = [UIActivityIndicatorView new];
    [_activityIndicator setBackgroundColor:[UIColor clearColor]];
    [_activityIndicator startAnimating];
    if( self.accessoryType == UITableViewCellAccessoryNone ) {
        _activityIndicator.frame = CGRectMake( 20, y, _activityIndicator.frame.size.width, _activityIndicator.frame.size.height );
        UIView *superview = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, 30, self.frame.size.height )];
        [superview addSubview:_activityIndicator];
        self.accessoryView = superview;
    }
    else {
        CGFloat x = ( self.contentView.frame.size.width ) - 10;
        _activityIndicator.frame = CGRectMake( x, y+1, _activityIndicator.frame.size.width, _activityIndicator.frame.size.height );
        _activityIndicator.autoresizingMask = ( UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin );
        [self.contentView addSubview:_activityIndicator];
    }
}

- (void)stopActivityIndicator {
    // Indicator isn't running
    if( _activityIndicator == nil ) {
        return;
    }
    // Animate it out
    if( self.accessoryType == UITableViewCellAccessoryNone ) {
        self.accessoryView = nil;
        _activityIndicator = nil;
    }
    else {
        [_activityIndicator stopAnimating];
        [_activityIndicator removeFromSuperview];
        _activityIndicator = nil;
    }
}

@end
