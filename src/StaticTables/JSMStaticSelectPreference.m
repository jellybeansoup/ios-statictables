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

#import "JSMStaticSelectPreference.h"
#import "JSMStaticSelectPreferenceViewController.h"

NSString *const JSMStaticSelectOptionValue = @"JSMStaticSelectOptionValue";

NSString *const JSMStaticSelectOptionLabel = @"JSMStaticSelectOptionLabel";

NSString *const JSMStaticSelectOptionImage = @"JSMStaticSelectOptionImage";

@implementation JSMStaticSelectPreference

@dynamic value;
@dynamic defaultValue;

#pragma mark - Creating Preferences

- (instancetype)initWithKey:(id)key andUserDefaultsKey:(NSString *)userDefaultsKey {
    if( ( self = [super initWithKey:key andUserDefaultsKey:userDefaultsKey] ) ) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.style = UITableViewCellStyleValue1;
        self.detailText = [self labelForValue:self.value];
        _options = @[];
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

- (JSMStaticSelectPreferenceViewController *)viewController {
    if( _viewController == nil ) {
        JSMStaticSelectPreferenceViewController *viewController = [[JSMStaticSelectPreferenceViewController alloc] initWithPreference:self];
        _viewController = viewController;
    }
    return _viewController;
}

- (void)clearViewController {
    if( _viewController == nil ) {
        return;
    }
    _viewController = nil;
}

- (BOOL)fitControlToCell {
    return NO;
}

#pragma mark - Updating the value

- (void)setValue:(NSString *)value {
    [super setValue:value];
    [self setNeedsReload];
}

- (id)defaultValue {
    // If we haven't been given a value, use the first valid option.
    if( super.defaultValue == nil ) {
        return [[self.options filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSDictionary *option, NSDictionary *bindings) {
            return ( [option isKindOfClass:[NSDictionary class]] && option[JSMStaticSelectOptionValue] != nil );
        }]] firstObject][JSMStaticSelectOptionValue];
    }
    // Return the value
    return super.defaultValue;
}

- (NSString *)labelForValue:(NSString *)value {
    NSDictionary *option = [[self.options filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSDictionary *_option, NSDictionary *bindings) {
        return ( [_option isKindOfClass:[NSDictionary class]] && [_option[JSMStaticSelectOptionValue] isEqual:value] );
    }]] firstObject];
    return option[JSMStaticSelectOptionLabel] ?: option[JSMStaticSelectOptionValue];
}

- (void)valueDidChange {
    // Ideally, we'd probably tell the table view to refresh here?
}

@end
