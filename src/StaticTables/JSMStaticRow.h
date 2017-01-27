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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JSMStaticSection.h"

@class JSMStaticSection;
@class JSMStaticRow;

NS_ASSUME_NONNULL_BEGIN

/**
 * A `JSMStaticRow` objects acts as a data source for a single `UITableViewCell`.
 * It defines the basic structure such as the number of rows and any header or footer text.
 */

@interface JSMStaticRow : NSObject

///---------------------------------------------
/// @name Creating rows
///---------------------------------------------

/**
 * Allocates and initialises an instance of `JSMStaticRow`.
 *
 * @return The new instance of `JSMStaticRow`.
 */

+ (instancetype)row NS_SWIFT_UNAVAILABLE("Use init() instead.");

/**
 * Allocates and initialises an instance of `JSMStaticRow` with the given key.
 *
 * @param key The key to use in identifying the row.
 * @return The new instance of `JSMStaticRow` with the given key.
 */

+ (instancetype)rowWithKey:(id _Nullable)key NS_SWIFT_UNAVAILABLE("Use init(key:) instead.");

/**
 * Initialises an instance of `JSMStaticRow`.
 *
 * @return The new instance of `JSMStaticRow`.
 */

- (instancetype)init;

/**
 * Initialises an instance of `JSMStaticRow` with the given key.
 *
 * @param key The key to use in identifying the row.
 * @return The new instance of `JSMStaticRow` with the given key.
 */

- (instancetype)initWithKey:(id _Nullable)key NS_SWIFT_NAME(init(key:));

/**
 * An identifier for the reciever.
 *
 * This identifier is provided as part of `rowWithKey:` and cannot be changed.
 */

@property (nonatomic, strong, readonly, nullable) id key;

///---------------------------------------------
/// @name Comparing Rows
///---------------------------------------------

/**
 * Test whether the reciever is equal to another row.
 *
 * This method considers two sections to be equal if:
 * - they are the same object.
 * - both rows have keys and both keys are equal.
 * - neither row has a key, but the `text`, `detailText` and `image` are all equal.
 *
 * @param row The row to compare to the reciever.
 * @return Flag that indicates if the given row is equal to the the reciever (`YES`) or not (`NO`).
 */

- (BOOL)isEqualToRow:(__kindof JSMStaticRow *)row NS_SWIFT_NAME(isEqual(to:));

///---------------------------------------------
/// @name Data Structure
///---------------------------------------------

/**
 * The table view the row belongs to.
 *
 * @see JSMStaticDataSource.tableview
 */

@property (nonatomic, weak, readonly, nullable) UITableView *tableView;

/**
 * The section that the row belongs to.
 */

@property (nonatomic, weak, readonly, nullable) __kindof JSMStaticSection *section;

///---------------------------------------------
/// @name Predefined content
///---------------------------------------------

/**
 * The string used for the `UITableViewCell`'s `textLabel` content.
 */

@property (nonatomic, copy, nullable) NSString *text;

/**
 * The string used for the `UITableViewCell`'s `detailTextLabel` content.
 */

@property (nonatomic, copy, nullable) NSString *detailText;

/**
 * The image used for the `UITableViewCell`'s `imageView` content.
 */

@property (nonatomic, copy, nullable) UIImage *image;

/**
 * The cell style used for the `UITableViewCell` instance.
 */

@property (nonatomic) UITableViewCellStyle style;

/**
 * The selection used for the `UITableViewCell` instance.
 */

@property (nonatomic) UITableViewCellSelectionStyle selectionStyle;

/**
 * The accessory type used for the `UITableViewCell` instance. Defaults to `UITableViewCellAccessoryNone`.
 */

@property (nonatomic) UITableViewCellAccessoryType accessoryType;

/**
 * The accessory view used for the `UITableViewCell` instance. Setting this causes `accessoryType` to be ignored.
 */

@property (nonatomic, strong, nullable) UIView *accessoryView;

/**
 * The accessory type used for the `UITableViewCell` instance in an editing state. Defaults to `UITableViewCellAccessoryNone`.
 */

@property (nonatomic) UITableViewCellAccessoryType editingAccessoryType;

/**
 * The accessory view used for the `UITableViewCell` instance in an editing state. Setting this causes `editingAccessoryType` to be ignored.
 */

@property (nonatomic, strong, nullable) UIView *editingAccessoryView;

///---------------------------------------------
/// @name Configuring the cell
///---------------------------------------------

typedef void(^JSMStaticTableViewCellConfiguration)( JSMStaticRow *row, UITableViewCell *cell );

/**
 * Method intended for use by subclasses to configure the given cell. This method is called before any block provided
 * by `configurationforCell:`, but after the internal configuration has been performed. This makes it excellent for
 * providing custom default behaviour, but can be overridden.
 *
 * @param cell The cell to be configured.
 * @return void
 */

- (void)configureCell:(__kindof UITableViewCell *)cell NS_SWIFT_NAME(configure(_:));

/**
 * Provide configuration for the row's `UITableViewCell` when it is prepared for view.
 *
 * @param configurationBlock The location of the section you want to retrieve. You are provided with two parameters:
 *      a cell for you to configure, passed by reference, and the index path pointing to the cell in the overall
 *      structure.
 * @return void
 */

- (void)configurationForCell:(JSMStaticTableViewCellConfiguration)configurationBlock NS_SWIFT_NAME(configurationForCell(handler:));

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

///---------------------------------------------
/// @name Manipulating the Row
///---------------------------------------------

/**
 * The cell editing style used for the `UITableViewCell` instance.
 */

@property (nonatomic) UITableViewCellEditingStyle editingStyle;

/**
 * Flag for indicating whether the user can change the position of this row within the table view.
 *
 * If set as YES, the parent data source will take care of moving the row to the position selected by the user, and call
 * the `` method on its delegate on completion.
 */

@property (nonatomic) BOOL canBeMoved;

/**
 * Flag for indicating whether the user can delete this row.
 *
 * If set as YES, the parent data source will take care of removing the row, and call the `` method on its delegate on completion.
 */

@property (nonatomic) BOOL canBeDeleted;

@end

NS_ASSUME_NONNULL_END
