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
#import <UIKit/UIKit.h>
#import "JSMStaticTableViewController.h"

@class JSMStaticSelectPreference;
@class JSMStaticDataSource;

NS_ASSUME_NONNULL_BEGIN

/**
 * Instances of `JSMStaticSelectPreferenceViewController` are used as the interface for selecting a
 * value for a `JSMStaticSelectPreference` instance from a preconfigured collection of options.
 *
 * Typically, an instance is provided by the `JSMStaticSelectPreference` in question, but for more
 * complex behaviours, or customisation of the user interface, a subclass can be created an initialised
 * with `initWithPreference:`.
 */

@interface JSMStaticSelectPreferenceViewController : JSMStaticTableViewController <UITableViewDelegate>

///---------------------------------------------
/// @name Creating the View Controller
///---------------------------------------------

/**
 * Initialises an allocated `JSMStaticSelectPreferenceViewController` object with a given `preference`.
 *
 * @param preference The preference that is used to provide the default functionality.
 * @return Initialised `JSMStaticSelectPreferenceViewController` object with `preference`.
 */

- (instancetype)initWithPreference:(__kindof JSMStaticSelectPreference *)preference;

/**
 * The `JSMStaticSelectPreference` that provides the default options and other functionality for the reciever.
 */

@property (nonatomic, weak) __kindof JSMStaticSelectPreference *preference;

@end

NS_ASSUME_NONNULL_END
