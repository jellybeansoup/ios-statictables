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
#import "JSMStaticSection.h"
#import "JSMStaticViewCell.h"

@class JSMStaticSection;
@class JSMStaticRow;

/**
 * A `JSMStaticRow` objects acts as a data source for a single `UITableViewCell`.
 * It defines the basic structure such as the number of rows and any header or footer text.
 */

@interface JSMStaticRow : NSObject

///---------------------------------------------
/// @name Data Structure
///---------------------------------------------

/**
 * The section that the row belongs to.
 */

@property (nonatomic, weak, readonly) JSMStaticSection *section;

///---------------------------------------------
/// @name Predefined content
///---------------------------------------------

/**
 * The string used for the `UITableViewCell`'s `textLabel` content.
 */

@property (nonatomic, strong) NSString *text;

/**
 * The string used for the `UITableViewCell`'s `detailTextLabel` content.
 */

@property (nonatomic, strong) NSString *detailText;

/**
 * The image used for the `UITableViewCell`'s `imageView` content.
 */

@property (nonatomic, strong) UIImage *image;

/**
 * The cell style used for the `UITableViewCell` instance.
 */

@property (nonatomic) UITableViewCellStyle style;

///---------------------------------------------
/// @name Configuring the cell
///---------------------------------------------

typedef void(^JSMStaticTableViewCellConfiguration)( JSMStaticRow *row, UITableViewCell *cell );

/**
 * Provide configuration for the row's `UITableViewCell` when it is prepared for view.
 *
 * @param configurationBlock The location of the section you want to retrieve. You are provided with two parameters:
 *      a cell for you to configure, passed by reference, and the index path pointing to the cell in the overall
 *      structure.
 * @return void
 */

- (void)configurationForCell:(JSMStaticTableViewCellConfiguration)configurationBlock;

///---------------------------------------------
/// @name Refreshing the Row
///---------------------------------------------

/**
 * Returns a Boolean indicating whether the row has been marked as needing to be reloaded.
 *
 * @return Flag indicating if the row has been marked as needing to be reloaded (`YES`) or not (`NO`).
 */

- (BOOL)needsReload;

/**
 * Marks the row as needing to be reloaded within the table view.
 *
 * This method simply informs the data source it is contained in (if one is available) that it would like to be reloaded.
 * The data source will then inform its delegate, which needs to perform the reload. If the data source is not part of an
 * instance of `JSMStaticTableViewController`, you will need to ensure that you respond to the message appropriately.
 *
 * @return void
 */

- (void)setNeedsReload;

@end
