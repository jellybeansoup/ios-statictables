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

#import "JSMStaticPreference.h"

@interface JSMStaticPreference ()

@end

@interface JSMStaticRow (JSMStaticDataSource)

- (void)prepareCell:(UITableViewCell *)cell;

@end

@implementation JSMStaticPreference

@dynamic key;

#pragma mark - Creating Preferences

+ (instancetype)preferenceWithKey:(NSString *)key {
    return [self rowWithKey:key];
}

#pragma mark - Updating the value

@synthesize value = _value;

- (void)setValue:(id)value {
    // Don't update if the value doesn't change
    if( value == self.value ) {
        return;
    }
    // We'll be changing the value
    [self valueWillChange];
    // Store the value in NSUserDefaults
    if( self.key != nil ) {
        [[NSUserDefaults standardUserDefaults] setValue:value forKey:self.key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    // Or if we have to, in the value property
    else {
        _value = value;
    }
    // We've changed the value
    [self valueDidChange];
}

- (id)value {
    id value = nil;
    // Fetch the value from NSUserDefaults
    if( self.key != nil ) {
        value = [[NSUserDefaults standardUserDefaults] valueForKey:self.key];
    }
    // Or if we have to, from the value property
    else {
        value = _value;
    }
    // If it's nil, provide the default
    if( value == nil ) {
        value = self.defaultValue;
    }
    // Return the value
    return value;
}

- (void)valueWillChange {
}

- (void)valueDidChange {
}

#pragma mark - Configuring the cell

- (void)prepareCell:(UITableViewCell *)cell {
    // We do our little bit of configuration here
    if( self.control != nil ) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = self.control;
    }
    // Send the message to the super
    [super prepareCell:cell];
}

@end
