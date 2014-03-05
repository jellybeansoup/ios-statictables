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

#import "JSMPreferenceOption.h"

@implementation JSMPreferenceOption

@synthesize value = _value;

#pragma mark - Instance creation

- (instancetype)initWithLabel:(NSString *)label {
    if( ( self = [super init] ) ) {
        _label = label;
    }
    return self;
}

- (instancetype)initWithLabel:(NSString *)label andValue:(id)value {
    if( ( self = [super init] ) ) {
        _label = label;
        _value = value;
    }
    return self;
}

+ (instancetype)optionWithLabel:(NSString *)label {
    return [[self alloc] initWithLabel:label];
}

+ (instancetype)optionWithLabel:(NSString *)label andValue:(id)value {
    return [[self alloc] initWithLabel:label andValue:value];
}

# pragma mark - Fetching the value

- (id)value {
    // If the value is null, return the label
    if( _value == nil ) {
        return _label;
    }
    // Default to the value
    return _value;
}

@end

