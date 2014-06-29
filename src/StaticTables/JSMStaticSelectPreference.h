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

@class JSMStaticSelectPreferenceViewController;

/**
 * Instances of `JSMStaticSelectPreference` act as an interface for a preference with multiple
 * options, similar to that provided by a typical dropdown/select box form element.
 *
 * No control is provided. Instead, an instance of `JSMStaticSelectPreferenceViewController` is
 * provided and should be displayed within the view heirachy (or pushed into the navigation
 * controller). Selection of an option within the view controller will automatically update the
 * reciever's `value`.
 *
 * **Please note:** The label for the current `value` of the preference is displayed in the
 * `UITableViewCell`'s `detailTextLabel`, and any text provided will be overridden.
 */

@interface JSMStaticSelectPreference : JSMStaticPreference

///---------------------------------------------
/// @name Storage
///---------------------------------------------

/**
 * The value of the preference.
 *
 * This will return the `defaultValue` if it is set to nil, or if no value has been provided yet.
 *
 * The value provided should match a key within the provided `options` dictionary.
 */

@property (nonatomic, strong) NSString *value;

/**
 * The default value for the preference.
 *
 * This is not stored as part of the user defaults, but will be provided as the `value` if none is available.
 *
 * The value provided should match a key within the provided `options` dictionary.
 */

@property (nonatomic, strong) NSString *defaultValue;

/**
 * A collection of options for the preference.
 *
 * Keys within this dictionary are used as storage values for the option, while the values are used as labels.
 * So, for a dictionary like `@{ @"option1": @"Option 1", @"option2": @"Option 2" }`, the possible values for
 * the preference are either `option1` or `option2`, and the other strings will be displayed to the user to
 * represent their key.
 */

@property (nonatomic, strong) NSDictionary *options;

///---------------------------------------------
/// @name User Interface
///---------------------------------------------

/**
 * A preconfigured instance of `JSMStaticSelectPreferenceViewController` that will update the preference
 * value when an option is selected.
 */

@property (nonatomic, strong, readonly) JSMStaticSelectPreferenceViewController *viewController;

@end
