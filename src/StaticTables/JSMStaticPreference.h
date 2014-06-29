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

#import "JSMStaticRow.h"

/**
 * Instances of `JSMStaticPreference` act as a more advanced method of managing settings using
 * `NSUserDefaults` and `UITableView`.
 *
 * The can be added to instances of `JSMStaticSection` as a row, and will automatically configure
 * the resulting `UITableViewCell` to include an appropriate control, which when manipulated will
 * store the new value in `NSUserDefaults` under the provided key.
 *
 * You should not create and use instances of `JSMStaticPreference` directly, but rather, use one
 * of the subclasses which provide different types of preferences.
 */

@interface JSMStaticPreference : JSMStaticRow

///---------------------------------------------
/// @name Creating Preferences
///---------------------------------------------

/**
 * Initialises an allocated `JSMStaticPreference` object with a user defaults `key`.
 *
 * @param key The string used as a key for storing the reciever's value in user defaults.
 * @return Initialised `JSMStaticPreference` object with `key`.
 */

- (instancetype)initWithKey:(NSString *)key;

/**
 * Allocates a new instance of `JSMStaticPreference`, and initialises it with the provided `key`.
 *
 * @param key The string used as a key for storing the reciever's value in user defaults.
 * @return A new instance of `JSMStaticPreference` with the given `key`.
 */

+ (instancetype)preferenceWithKey:(NSString *)key;

///---------------------------------------------
/// @name Storage
///---------------------------------------------

/**
 * The key used to store the preference within `NSUserDefaults`.
 *
 * If no key is provided, the value will not be stored, and will only live as long as the reciever
 * is in memory.
 */

@property (nonatomic, strong) NSString *key;

/**
 * The value of the preference.
 *
 * This will return the `defaultValue` if it is set to nil, or if no value has been provided yet.
 */

@property (nonatomic, strong) id value;

/**
 * The default value for the preference.
 *
 * This is not stored as part of the user defaults, but will be provided as the `value` if none is available.
 */

@property (nonatomic, strong) id defaultValue;

/**
 * Method for subclasses that is called just before the value is changed.
 *
 * This allows subclasses to update their `control` when the value is changed programmatically.
 *
 * Subclasses that implement this method should check the value against their value of the `control` before
 * applying it to ensure the application doesn't get stuck in an update loop.
 */

- (void)valueWillChange;

/**
 * Method for subclasses that is called after the value has been changed.
 *
 * This allows subclasses to update their `control` when the value is changed programmatically.
 *
 * Subclasses that implement this method should check the value against their value of the `control` before
 * applying it to ensure the application doesn't get stuck in an update loop.
 */

- (void)valueDidChange;

///---------------------------------------------
/// @name User Interface
///---------------------------------------------

/**
 * The `UIControl` created by the reciever to manage the value of the underlying preference.
 *
 * This is typically inserted into the resulting `UITableViewCell`, but if you want to show
 * the control elsewhere, this object will take care of all the hard work.
 *
 * The actual control returned will differ depending on the subclass.
 */

@property (nonatomic, strong, readonly) UIControl *control;

@end
