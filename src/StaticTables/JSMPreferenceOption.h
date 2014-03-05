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

#import <Foundation/Foundation.h>

/**
 * A class for creating options to be used with JSMPreference objects.
 */

@interface JSMPreferenceOption : NSObject

/**
 * The label for this option.
 */

@property (strong, nonatomic, readonly) NSString *label;

/**
 * The value for this option.
 */

@property (nonatomic) id value;

/**
 * Create an option with the given label. The label will act as the value when selected.
 *
 * @param label A string to be used as the label when displaying the option.
 * @return The instance of the option created using the given label.
 */

+ (instancetype)optionWithLabel:(NSString *)label;

/**
 * Create an option with the given label and value.
 *
 * @param label A string to be used as the label when displaying the option.
 * @param value An object to be provided as the value of the option.
 * @return The instance of the option created using the given parameters.
 */

+ (instancetype)optionWithLabel:(NSString *)label andValue:(id)value;

@end
