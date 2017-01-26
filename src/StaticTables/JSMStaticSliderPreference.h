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

NS_ASSUME_NONNULL_BEGIN

/**
 * Instances of `JSMStaticSliderPreference` act as an interface for a preference
 * with a bounded numeric value, such as a volume setting.
 *
 * The provided control is a slider that can be manipulated or inserted into a view, but
 * the intended behaviour is to add instances as rows in a `JSMStaticSection` for display as
 * a table view cell.
 */

@interface JSMStaticSliderPreference : JSMStaticPreference

///---------------------------------------------
/// @name Storage
///---------------------------------------------

/**
 * The value of the preference.
 *
 * This will return the `defaultValue` if it is set to nil, or if no value has been provided yet.
 */

@property (nonatomic, copy, nullable) NSNumber *value;

/**
 * The value of the preference.
 *
 * This will return the `defaultValue` if it is set to nil, or if no value has been provided yet.
 */

@property (nonatomic) CGFloat floatValue;

/**
 * The default value for the preference.
 *
 * This is not stored as part of the user defaults, but will be provided as the `value` if none is available.
 */

@property (nonatomic, copy, nullable) NSNumber *defaultValue;

/**
 * The value of the preference.
 *
 * This will return the `defaultValue` if it is set to nil, or if no value has been provided yet.
 */

@property (nonatomic) CGFloat defaultFloatValue;

///---------------------------------------------
/// @name User Interface
///---------------------------------------------

/**
 * The `UISlider` used by the reciever to modify the preference.
 *
 * This acts as a correctly typed alias for the `control` property on `JSMStaticPreference`
 */

@property (nonatomic, weak, readonly) UISlider *slider;

@end

NS_ASSUME_NONNULL_END
