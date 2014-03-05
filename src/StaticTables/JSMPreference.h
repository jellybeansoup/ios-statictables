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
#import "JSMPreferenceOption.h"

/**
 * JSMPreference class
 *
 * Instances of JSMPreference are used to represent preferences for an application.
 */

@interface JSMPreference : NSObject <UITextInputTraits>

/**
 * Key to use when storing the value in the NSUserDefaults' standardUserDefaults store.
 */

@property (strong, nonatomic, readonly) NSString *key;

/**
 * Array of JSMPreferenceOption objects.
 */

@property (strong, nonatomic, readonly) NSArray *options;

/**
 * Index for the default option.
 */

@property (nonatomic) NSUInteger defaultIndex;

/**
 * The current value of the preference.
 */

@property (nonatomic) id value;


/**
 * Create a preference with the given key.
 *
 * @param key A string used to reference and fetch the preference.
 * @return The instance of the preference created.
 */

+ (instancetype)preferenceWithKey:(NSString *)key;

/**
 * Create a preference with the given key and options.
 * The first option present in the array will be used as the default value.
 *
 * @param key A string used to reference and fetch the preference.
 * @param options An array of JSMPreferenceOption objects to use as options for the preference.
 * @return The instance of the preference created.
 */

+ (instancetype)preference:(NSString *)key withOptions:(NSArray *)options;

/**
 * Create a preference with the given key, options and default value.
 *
 * @param key A string used to reference and fetch the preference.
 * @param options An array of JSMPreferenceOption objects to use as options for the preference.
 * @param defaultIndex The index of the default value in the given options array.
 * @return The instance of the preference created.
 */

+ (instancetype)preference:(NSString *)key withOptions:(NSArray *)options andDefault:(NSUInteger)defaultIndex;

/**
 * Create a preference with the given key and default value.
 *
 * @param key A string used to reference and fetch the preference.
 * @param value The default value of the preference.
 * @return The instance of the preference created.
 */

+ (instancetype)preference:(NSString *)key withDefaultValue:(id)value;

- (void)addOptionWithLabel:(NSString *)option;

- (void)addOptionWithLabel:(NSString *)option andValue:(id)value;

- (JSMPreferenceOption *)selectedOption;

- (JSMPreferenceOption *)optionForValue:(id)value;

- (JSMPreferenceOption *)optionForIndex:(NSUInteger)index;

@property (nonatomic) NSString *placeholder;
@property (nonatomic) UITextAutocapitalizationType autocapitalizationType;
@property (nonatomic) UITextAutocorrectionType autocorrectionType;
@property (nonatomic) UITextSpellCheckingType spellCheckingType;
@property (nonatomic) BOOL enablesReturnKeyAutomatically;
@property (nonatomic) UIKeyboardAppearance keyboardAppearance;
@property (nonatomic) UIKeyboardType keyboardType;
@property (nonatomic) UIReturnKeyType returnKeyType;
@property (nonatomic, getter=isSecureTextEntry) BOOL secureTextEntry;

@end
