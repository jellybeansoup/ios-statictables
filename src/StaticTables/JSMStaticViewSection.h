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
 * A `JSMStaticViewSection` objects acts as a data source for a single `JSMStaticViewController` section.
 * It defines the basic structure such as the number of rows and any header or footer text.
 */

@interface JSMStaticViewSection : NSObject

///---------------------------------------------
/// @name Creating a Section Entity
///---------------------------------------------

/**
 * Returns a `JSMStaticViewSection` object created to describe a section used in a `JSMStaticViewController`
 *
 * @param key A string used as an identifier for the section.
 * @param rows The number of rows the section should display.
 * @return An instance of `JSMStaticViewSection`.
 */

+ (instancetype)sectionWithKey:(NSString *)key andNumberOfRows:(NSInteger)rows;

///---------------------------------------------
/// @name Configuring the Section
///---------------------------------------------

/**
 * A string key used to identify the section.
 */

@property (nonatomic, strong) NSString *key;

/**
 * The number of rows displayed in this section.
 */

@property (nonatomic) NSInteger rows;

///---------------------------------------------
/// @name Managing Headers and Footers
///---------------------------------------------

/**
 * The text used in the section header.
 */

@property (nonatomic, strong) NSString *headerText;

/**
 * The text used in the section footer.
 */

@property (nonatomic, strong) NSString *footerText;

@end
