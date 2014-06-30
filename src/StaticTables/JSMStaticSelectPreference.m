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

#import "JSMStaticSelectPreference.h"
#import "JSMStaticSelectPreferenceViewController.h"

@interface JSMStaticRow (JSMStaticDataSource)

- (void)prepareCell:(UITableViewCell *)cell;

@end

@implementation JSMStaticSelectPreference

#pragma mark - Creating Preferences

- (instancetype)init {
    if( ( self = [super init] ) ) {
        self.style = UITableViewCellStyleValue1;
        self.detailText = [self labelForValue:self.value];
    }
    return self;
}

#pragma mark - Predefined content

- (void)setDetailText:(NSString *)detailText {
    // Do nothing.
}

- (NSString *)detailText {
    return [self labelForValue:self.value];
}

#pragma mark - User Interface

@synthesize viewController = _viewController;

- (UIControl *)control {
    return nil; // No control for this one.
}

- (JSMStaticSelectPreferenceViewController *)viewController {
    if( _viewController == nil ) {
        JSMStaticSelectPreferenceViewController *viewController = [[JSMStaticSelectPreferenceViewController alloc] initWithPreference:self];
        NSLog(@"%@",viewController);
        _viewController = viewController;
    }
    return _viewController;
}

#pragma mark - Updating the value

- (void)setValue:(NSString *)value {
    [super setValue:value];
    [self setNeedsReload];
}

- (id)defaultValue {
    // If we haven't been given a value, use the first option.
    if( super.defaultValue == nil ) {
        return self.options.allKeys.firstObject;
    }
    // Return the value
    return super.defaultValue;
}

- (NSString *)labelForValue:(NSString *)value {
    return [self.options objectForKey:value];
}

- (void)valueDidChange {
    // Ideally, we'd probably tell the table view to refresh here?
}

#pragma mark - Configuring the cell

- (void)prepareCell:(UITableViewCell *)cell {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Send the message to the super
    [super prepareCell:cell];
}

@end
