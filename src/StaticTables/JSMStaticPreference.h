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

#import "JSMStaticRow.h"

@class JSMStaticPreference;

NS_ASSUME_NONNULL_BEGIN

// A protocol for data source observers to be notified

@protocol JSMStaticPreferenceObserver <NSObject>

@optional

- (void)preference:(__kindof JSMStaticPreference *)preference didLoadControl:(__kindof UIControl *)control NS_SWIFT_NAME(preference(_:didLoad:));

- (void)preference:(__kindof JSMStaticPreference *)preference willChangeValue:(id)value NS_SWIFT_NAME(preference(_:willChange:));

- (void)preference:(__kindof JSMStaticPreference *)preference didChangeValue:(id)value NS_SWIFT_NAME(preference(_:didChange:));

@end

/**
 * Instances of `JSMStaticPreference` act as a more advanced method of managing settings using
 * `NSUserDefaults` and `UITableView`.
 *
 * The can be added to instances of `JSMStaticSection` as a row, and will automatically configure
 * the resulting `UITableViewCell` to include an appropriate control, which when manipulated will
 * store the new value in `NSUserDefaults` under the provided key.
 *
 * You should not create and use instances of `JSMStaticPreference` directly, but rather, use one
 * of the subclasses (or create your own) which provide different types of preferences.
 */

@interface JSMStaticPreference : JSMStaticRow

///---------------------------------------------
/// @name Creating Preferences
///---------------------------------------------

/**
 * Allocates a new instance of `JSMStaticPreference`, and initialises it with the provided `key`.
 *
 * This method will also automatically use the given `key` to set the created preference's
 * `userDefaultsKey`, which is used for storing the value in the user defaults dictionary.
 *
 * To create a preference that does not store it's data automatically, you can use the
 * `transientPreferenceWithKey:` method, or the `preferenceWithKey:andUserDefaultsKey:` method with
 * a nil value passed to the `userDefaultsKey` parameter.
 *
 * @param key The key to use in identifying the preference within the containing section, and for
 *      storing the value in the user defaults dictionary.
 * @return A new instance of `JSMStaticPreference` with the given `key`.
 */

+ (instancetype)preferenceWithKey:(NSString * _Nullable)key NS_SWIFT_UNAVAILABLE("Use init(key:userDefaultsKey:) instead.");

/**
 * Allocates a new instance of `JSMStaticPreference`, and initialises it with the provided `key`.
 *
 * Preferences created using this method do not store their values in the user defaults dictionary.
 *
 * @param key The key to use in identifying the preference within the containing section.
 * @return A new instance of `JSMStaticPreference` with the given `key`.
 */

+ (instancetype)transientPreferenceWithKey:(id _Nullable)key NS_SWIFT_UNAVAILABLE("Use init(key:userDefaultsKey:) instead.");

/**
 * Allocates a new instance of `JSMStaticPreference`, and initialises it with the provided `key`
 * and `userDefaultsKey`.
 *
 * @param key The key to use in identifying the preference within the containing section.
 * @param userDefaultsKey The key used for storing the value in the user defaults dictionary.
 * @return A new instance of `JSMStaticPreference` with the given `key`.
 */

+ (instancetype)preferenceWithKey:(id _Nullable)key andUserDefaultsKey:(NSString * _Nullable)userDefaultsKey NS_SWIFT_UNAVAILABLE("Use init(key:userDefaultsKey:) instead.");

/**
 * Initialises a new instance of `JSMStaticPreference`, and initialises it with the provided `key`
 * and `userDefaultsKey`.
 *
 * @param key The key to use in identifying the preference within the containing section.
 * @param userDefaultsKey The key used for storing the value in the user defaults dictionary.
 * @return A new instance of `JSMStaticPreference` with the given `key`.
 */

- (instancetype)initWithKey:(id _Nullable)key andUserDefaultsKey:(NSString * _Nullable)userDefaultsKey NS_SWIFT_NAME(init(key:userDefaultsKey:));

///---------------------------------------------
/// @name Storage
///---------------------------------------------

/**
 * The key used to store the preference within `NSUserDefaults`.
 *
 * If no key is provided, the value will not be stored, and will only live as long as the reciever
 * is in memory.
 */

@property (nonatomic, strong, readonly, nullable) NSString *userDefaultsKey;

/**
 * The value of the preference.
 *
 * This will return the `defaultValue` if it is set to nil, or if no value has been provided yet.
 */

@property (nonatomic, copy, nullable) id value;

/**
 * The default value for the preference.
 *
 * This is not stored as part of the user defaults, but will be provided as the `value` if none is available.
 */

@property (nonatomic, copy, nullable) id defaultValue;

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

@property (nonatomic, strong) __kindof UIControl *control;

/**
 * Boolean flag to indicate if the control has been loaded into memory.
 */

@property (nonatomic, readonly, getter=isControlLoaded) BOOL controlLoaded;

/**
 * Creates the `UIControl` for managing the value of the underlying preference.
 */

- (void)loadControl;

/**
 * Method for subclasses that is called after the control has been loaded.
 */

- (void)controlDidLoad;

/**
 * Creates the `UIControl` for managing the value of the underlying preference if it has not yet been loaded.
 */

- (void)loadControlIfNeeded;

/**
 * The `UIControl` created by the reciever if it has been loaded, otherwise `nil`.
 */

@property (nonatomic, strong, readonly, nullable) __kindof UIControl *controlIfLoaded;

/**
 * Boolean flag to indicate if the control should be enabled or not.
 *
 * This is to allow the control to be disabled without needing to load the control itself into memory.
 */

@property (nonatomic, getter=isEnabled) BOOL enabled;

/**
 * Flag which tells the row to configure the cell so that the control is contained in its `contentView`, and
 * so that the control fills the cell.
 *
 * Because the frame of some controls cannot be altered, this property will have no effect on preferences using
 * those controls. As an example, the `JSMStaticBooleanPreference`'s `UISwitch` control does not respond to this
 * property.
 */

@property (nonatomic) BOOL fitControlToCell;

///---------------------------------------------
/// @name Observers
///---------------------------------------------

/**
 * Add an observer of the reciever.
 *
 * @param observer An object implementing the `JSMStaticPreferenceObserver` protocol.
 */

- (void)addObserver:(__weak id <JSMStaticPreferenceObserver>)observer NS_SWIFT_NAME(add(observer:));

/**
 * Remove an observer from the reciever.
 *
 * @param observer An object implementing the `JSMStaticPreferenceObserver` protocol.
 */

- (void)removeObserver:(__weak id <JSMStaticPreferenceObserver>)observer NS_SWIFT_NAME(remove(observer:));

/**
 * Detect whether an object is observing the reciever.
 *
 * @param observer An object implementing the `JSMStaticPreferenceObserver` protocol.
 * @return Flag indicating if the given object is currently observing the receiver.
 */

- (BOOL)hasObserver:(__weak id <JSMStaticPreferenceObserver>)observer NS_SWIFT_NAME(has(observer:));

@end

NS_ASSUME_NONNULL_END
