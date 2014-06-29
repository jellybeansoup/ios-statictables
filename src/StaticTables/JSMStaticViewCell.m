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

@interface JSMStaticViewCell ()

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation JSMStaticViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.accessoryView = nil;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleDefault;

    //self.backgroundColor
    //self.selectedBackgroundColor
}

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
