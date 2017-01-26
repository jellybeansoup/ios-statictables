//
// Copyright © 2017 Daniel Farrelly
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

@property (nonatomic, strong) NSMutableDictionary *observers;

@end

@interface JSMStaticRow (JSMStaticDataSource)

- (void)prepareCell:(UITableViewCell *)cell;

- (void)performDefaultConfiguration:(UITableViewCell *)cell;

- (void)performCustomConfiguration:(UITableViewCell *)cell;

@end

@implementation JSMStaticPreference

#pragma mark - Creating Preferences

+ (instancetype)preferenceWithKey:(NSString *)key {
    return [self preferenceWithKey:key andUserDefaultsKey:key];
}

+ (instancetype)transientPreferenceWithKey:(NSString *)key {
    return [self preferenceWithKey:key andUserDefaultsKey:nil];
}

+ (instancetype)preferenceWithKey:(NSString *)key andUserDefaultsKey:(NSString *)userDefaultsKey {
    return [[self alloc] initWithKey:key andUserDefaultsKey:userDefaultsKey];
}

- (instancetype)initWithKey:(NSString *)key {
    return [self initWithKey:key andUserDefaultsKey:nil];
}

- (instancetype)initWithKey:(NSString *)key andUserDefaultsKey:(NSString *)userDefaultsKey {
    if( ( self = [super initWithKey:key] ) ) {
        self.userDefaultsKey = userDefaultsKey;
    }
    
    return self;
}

- (void)dealloc {
    [self.control removeFromSuperview];
}

#pragma mark - Storage

- (void)setUserDefaultsKey:(NSString *)userDefaultsKey {
    _userDefaultsKey = userDefaultsKey;
}

@synthesize value = _value;

- (void)setValue:(id)value {
    // Don't update if the value doesn't change
    if( value == self.value ) {
        return;
    }
    // We'll be changing the value
    [self willChangeValueForKey:NSStringFromSelector(@selector(value))];
    [self valueWillChange];
    for( NSValue *ov in self.observers.allValues ) {
        id <JSMStaticPreferenceObserver>observer = ov.nonretainedObjectValue;
        if( observer == nil || ! [observer respondsToSelector:@selector(preference:willChangeValue:)] ) {
            continue;
        }
        [observer preference:self willChangeValue:self.value];
    }
    // Store the value in NSUserDefaults
    if( self.userDefaultsKey != nil ) {
        [[NSUserDefaults standardUserDefaults] setValue:value forKey:self.userDefaultsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    // Or if we have to, in the value property
    else {
        _value = value;
    }
    // We've changed the value
    for( NSValue *ov in self.observers.allValues ) {
        id <JSMStaticPreferenceObserver>observer = ov.nonretainedObjectValue;
        if( observer == nil || ! [observer respondsToSelector:@selector(preference:didChangeValue:)] ) {
            continue;
        }
        [observer preference:self didChangeValue:self.value];
    }
    [self valueDidChange];
    [self didChangeValueForKey:NSStringFromSelector(@selector(value))];
}

- (id)value {
    id value = nil;
    // Fetch the value from NSUserDefaults
    if( self.userDefaultsKey != nil ) {
        value = [[NSUserDefaults standardUserDefaults] valueForKey:self.userDefaultsKey];
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
	[self performDefaultConfiguration:cell];

    if( self.control != nil ) {
        if( self.selectionStyle != UITableViewCellSelectionStyleNone ) {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if( ! self.fitControlToCell ) {
            if( ! [self.accessoryView isEqual:self.control] ) {
                self.accessoryView = self.control;
            }
        }
        else if( self.fitControlToCell ) {
            self.control.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.control.frame = CGRectMake( cell.separatorInset.left, 0, cell.contentView.frame.size.width - ( cell.separatorInset.left + cell.separatorInset.right ), cell.contentView.frame.size.height );
            if( ! [self.control.superview isEqual:cell.contentView] ) {
                [cell.contentView addSubview:self.control];
            }
        }
    }

	[self performCustomConfiguration:cell];
}

#pragma mark - Observers

- (void)addObserver:(id <JSMStaticPreferenceObserver>)observer {
    // Observer is nil
    if( observer == nil ) {
        return;
    }

    // Observer is already observing
    if( [self hasObserver:observer] ) {
        return;
    }

    // Add the observers array
    if( self.observers == nil ) {
        self.observers = [NSMutableDictionary dictionary];
    }

    // Add the value
    NSString *key = [NSString stringWithFormat:@"%@",@(observer.hash)];
	self.observers[key] = [NSValue valueWithNonretainedObject:observer];
}

- (void)removeObserver:(id <JSMStaticPreferenceObserver>)observer {
    // Observer is nil
    if( observer == nil ) {
        return;
    }

    // Observer isn't observing
    if( ! [self hasObserver:observer] ) {
        return;
    }

    // Add the value
    NSString *key = [NSString stringWithFormat:@"%@",@(observer.hash)];
    [self.observers removeObjectForKey:key];
}

- (BOOL)hasObserver:(id <JSMStaticPreferenceObserver>)observer {
    NSString *key = [NSString stringWithFormat:@"%@",@(observer.hash)];
    return ( self.observers != nil && self.observers[key] != nil );
}

@end
