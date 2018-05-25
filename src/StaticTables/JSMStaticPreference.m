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

@interface JSMStaticPreferenceObserverContainer: NSObject

@property (nonatomic, weak) id<JSMStaticPreferenceObserver> observer;

- (instancetype)initWithObserver:(id<JSMStaticPreferenceObserver>)observer;

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
    return [self initWithKey:key andUserDefaultsKey:key];
}

- (instancetype)initWithKey:(NSString *)key andUserDefaultsKey:(NSString *)userDefaultsKey {
    if( ( self = [super initWithKey:key] ) ) {
        self.userDefaultsKey = userDefaultsKey;
		self.enabled = YES;
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
	[self _valueWillChange];
	// Store the value in the value property
	if( self.userDefaultsKey == nil ) {
		_value = value;
	}
	// Clear NSUserDefaults for a nil value.
    else if( value == nil ) {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:self.userDefaultsKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
    }
	// Store the value in NSUserDefaults
    else {
		[[NSUserDefaults standardUserDefaults] setValue:value forKey:self.userDefaultsKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
    }
    // We've changed the value
	[self _valueDidChange];
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

- (BOOL)usingDefaultValue {
	return _value == nil && ( self.userDefaultsKey == nil || [[NSUserDefaults standardUserDefaults] valueForKey:self.userDefaultsKey] == nil );
}

- (void)setDefaultValue:(id)defaultValue {
	// Don't update if the value doesn't change
	if( defaultValue == self.defaultValue ) {
		return;
	}
	// We'll be changing the value
	if( self.usingDefaultValue ) {
		[self _valueWillChange];
	}

	// Update the stored value
	_defaultValue = defaultValue;

	// We've changed the value
	if( self.usingDefaultValue ) {
		[self _valueDidChange];
	}
}

- (void)_valueWillChange {
	[self willChangeValueForKey:NSStringFromSelector(@selector(value))];

	[self valueWillChange];

	for( JSMStaticPreferenceObserverContainer *ov in self.observers.allValues ) {
		id<JSMStaticPreferenceObserver> observer = ov.observer;
		if( observer == nil || ! [observer respondsToSelector:@selector(preference:willChangeValue:)] ) {
			continue;
		}
		[observer preference:self willChangeValue:self.value];
	}
}

- (void)valueWillChange {
	// Subclass use only
}

- (void)_valueDidChange {
	for( JSMStaticPreferenceObserverContainer *ov in self.observers.allValues ) {
		id<JSMStaticPreferenceObserver> observer = ov.observer;
		if( observer == nil || ! [observer respondsToSelector:@selector(preference:didChangeValue:)] ) {
			continue;
		}
		[observer preference:self didChangeValue:self.value];
	}

	[self valueDidChange];

	[self didChangeValueForKey:NSStringFromSelector(@selector(value))];
}

- (void)valueDidChange {
	// Subclass use only
}

#pragma mark - User interface

@synthesize control = _control;

- (UIControl *)control {
	[self loadControlIfNeeded];

	return _control;
}

- (BOOL)isControlLoaded {
	return _control != nil;
}

- (void)loadControl {
	// Subclass use only
}

- (void)controlDidLoad {
	// Subclass use only
}

- (void)loadControlIfNeeded {
	if( self.isControlLoaded ) {
		return;
	}

	[self loadControl];
	[self controlDidLoad];

	_control.enabled = _enabled;

	for( JSMStaticPreferenceObserverContainer *ov in self.observers.allValues ) {
		id<JSMStaticPreferenceObserver> observer = ov.observer;
		if( observer == nil || ! [observer respondsToSelector:@selector(preference:didLoadControl:)] ) {
			continue;
		}
		[observer preference:self didLoadControl:self.control];
	}
}

- (UIControl *)controlIfLoaded {
	if( !self.isControlLoaded ) {
		return nil;
	}

	return _control;
}

@synthesize enabled = _enabled;

- (BOOL)isEnabled {
	if( self.controlIfLoaded != nil ) {
		return self.controlIfLoaded.isEnabled;
	}

	return _enabled;
}

- (void)setEnabled:(BOOL)enabled {
	_enabled = enabled;

	if( self.controlIfLoaded != nil && self.controlIfLoaded.enabled != enabled ) {
		self.controlIfLoaded.enabled = enabled;

		if( self.currentCell != nil ) {
			[self configureCell:self.currentCell];
		}
	}
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
				self.control.translatesAutoresizingMaskIntoConstraints = YES;
                self.accessoryView = self.control;
            }
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
	self.observers[key] = [[JSMStaticPreferenceObserverContainer alloc] initWithObserver:observer];
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

@implementation JSMStaticPreferenceObserverContainer

- (instancetype)initWithObserver:(id<JSMStaticPreferenceObserver>)observer {
	if( (self = [super init]) ) {
		self.observer = observer;
	}

	return self;
}

@end
