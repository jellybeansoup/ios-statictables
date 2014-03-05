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

#import "JSMPreference.h"
#import "JSMPreferenceViewController.h"

@implementation JSMPreference

# pragma mark - Instance creation

- (instancetype)initWithKey:(NSString *)key {
    if( ( self = [super init] ) ) {
        _key = key;
    }
    return self;
}

- (instancetype)initWithKey:(NSString *)key andOptions:(NSArray *)options {
    if( ( self = [self initWithKey:key] ) ) {
        _options = options;
    }
    return self;
}

- (instancetype)initWithKey:(NSString *)key options:(NSArray *)options andDefault:(NSUInteger)defaultIndex {
    if( ( self = [self initWithKey:key] ) ) {
        _options = options;
        _defaultIndex = defaultIndex;
    }
    return self;
}

- (instancetype)initWithKey:(NSString *)key andDefaultValue:(id)value {
    if( ( self = [self initWithKey:key] ) ) {
        self.value = value;
    }
    return self;
}

+ (instancetype)preferenceWithKey:(NSString *)key {
    return [[self alloc] initWithKey:key];
}

+ (instancetype)preference:(NSString *)key withOptions:(NSArray *)options {
    return [[self alloc] initWithKey:key andOptions:options];
}

+ (instancetype)preference:(NSString *)key withOptions:(NSArray *)options andDefault:(NSUInteger)defaultIndex {
    return [[self alloc] initWithKey:key options:options andDefault:defaultIndex];
}

+ (instancetype)preference:(NSString *)key withDefaultValue:(id)value {
    return [[self alloc] initWithKey:key andDefaultValue:value];
}

# pragma mark - Preference value

- (id)value {
    // Fetch the value
    id value = [NSUserDefaults.standardUserDefaults valueForKey:_key];
    // If it's nil, provide the default
    if( value == nil ) {
        value = [(JSMPreferenceOption *)[_options objectAtIndex:_defaultIndex?_defaultIndex:0] value];
    }
    // Return the value
    return value;
}

- (void)setValue:(id)value {
    [NSUserDefaults.standardUserDefaults setValue:value forKey:_key];
}

# pragma mark - Adding options

- (void)addOptionWithLabel:(NSString *)option {
    // Create the options if need be
    if( _options == nil ) {
        _options = @[];
    }
    // Add this one
    NSMutableArray *mutableOptions = _options.mutableCopy;
    [mutableOptions addObject:[JSMPreferenceOption optionWithLabel:option]];
    _options = mutableOptions.copy;
}

- (void)addOptionWithLabel:(NSString *)option andValue:(id)value {
    // Create the options if need be
    if( _options == nil ) {
        _options = @[];
    }
    // Add this one
    NSMutableArray *mutableOptions = _options.mutableCopy;
    [mutableOptions addObject:[JSMPreferenceOption optionWithLabel:option andValue:value]];
    _options = mutableOptions.copy;
}

# pragma mark - Getting options

- (JSMPreferenceOption *)selectedOption {
    return [self optionForValue:self.value];
}

- (JSMPreferenceOption *)optionForValue:(id)value {
    // Find the correct option by comparing values
    for( JSMPreferenceOption *option in _options ) {
        if( [option.value isEqual:value] ) {
            return option;
        }
    }
    // Default to nil
    return nil;
}

- (JSMPreferenceOption *)optionForIndex:(NSUInteger)index {
	return (JSMPreferenceOption *)[_options objectAtIndex:index];
}

@end
