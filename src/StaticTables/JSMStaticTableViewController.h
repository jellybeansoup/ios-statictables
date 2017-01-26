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
#import "JSMStaticDataSource.h"
#import "JSMStaticDataSource+Convenience.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * The `JSMStaticTableViewController` class creates a view controller object that manages a table view
 * using a `JSMStaticDataSource` as the data source for the table view. It's purpose it to implement
 * common behaviours and functionality so you don't have to do that yourself.
 *
 * Because I'm nice like that.
 *
 * It also conforms to the `JSMStaticDataSourceDelegate` protocol so that you can respond to messages
 * from the data source when necessary. It also implements some of the more useful delegate methods with
 * common implementations, including:
 *
 * - `dataSource:sectionNeedsReload:atIndex:`
 * - `dataSource:rowNeedsReload:atIndexPath:`
 *
 * Of course, these implementations can be overridden if desired.
 */

@interface JSMStaticTableViewController : UITableViewController <JSMStaticDataSourceDelegate>

///---------------------------------------------
/// @name Creating a Table View Controller
///---------------------------------------------

/**
 * Allocates a new instance of `JSMStaticTableViewController`, with a "grouped" table view.
 *
 * @return A new instance of a grouped `JSMStaticTableViewController`.
 */

+ (instancetype)grouped;

///---------------------------------------------
/// @name Data Source
///---------------------------------------------

/**
 * The static data source used to control the content of the reciever's table view.
 */

@property (nonatomic, strong, readonly) JSMStaticDataSource *dataSource;

///---------------------------------------------
/// @name Animating the Sections
///---------------------------------------------

/**
 * Creates a new `JSMStaticSection` object and adds it to the end of the observer.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param animation The `UITableViewRowAnimation` you want to use for the update animation.
 * @return The resulting instance of `JSMStaticSection`.
 */

- (JSMStaticSection *)createSectionWithRowAnimation:(UITableViewRowAnimation)animation;

/**
 * Creates a new `JSMStaticSection` object and inserts it into the observer at the given index.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param index The location at which to insert the section.
 * @param animation The `UITableViewRowAnimation` you want to use for the update animation.
 * @return The resulting instance of `JSMStaticSection`.
 */

- (JSMStaticSection *)createSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation;

/**
 * Adds the given `JSMStaticSection` object to the content structure.
 *
 * If the section exists in a data source already, it will be removed before being added to the observer.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param section A `JSMStaticSection` to add.
 * @param animation The `UITableViewRowAnimation` you want to use for the update animation.
 * @return void
 */

- (void)addSection:(__kindof JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 * Inserts the given `JSMStaticSection` object at the given index.
 *
 * If the section exists in a data source already, it will be removed before being inserted into the observer.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param section A `JSMStaticSection` to insert into the content structure.
 * @param index The location at which to insert the section.
 * @param animation The `UITableViewRowAnimation` you want to use for the update animation.
 * @return void
 */

- (void)insertSection:(__kindof JSMStaticSection *)section atIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation;

/**
 * Reload the given section if it exists within the reciever's data source.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param section The section you want to reload.
 * @param animation The `UITableViewRowAnimation` you want to use for the update animation.
 * @return void
 */

- (void)reloadSection:(__kindof JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 * Remove the section at the given index from the content structure.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param index The location of the section you want to remove.
 * @param animation The `UITableViewRowAnimation` you want to use for the update animation.
 * @return void
 */

- (void)removeSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation;

/**
 * Remove the given section from the content structure.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param section The section you want to remove.
 * @param animation The `UITableViewRowAnimation` you want to use for the update animation.
 * @return void
 */

- (void)removeSection:(__kindof JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation;

///---------------------------------------------
/// @name Animating the Rows
///---------------------------------------------

/**
 * Creates a new `JSMStaticRow` object and inserts it at the given index path.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param indexPath The location at which to insert the row.
 * @param animation The `UITableViewRowAnimation` you want to use for the update animation.
 * @return The resulting instance of `JSMStaticRow`.
 */

- (__kindof JSMStaticRow *)createRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

/**
 * Inserts the given `JSMStaticRow` object at the given index path.
 *
 * If the row exists in a section already, it will be removed before being inserted at the given index path.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param row A `JSMStaticRow` to insert into the content structure.
 * @param indexPath The location at which to insert the row.
 * @param animation The `UITableViewRowAnimation` you want to use for the update animation.
 * @return void
 */

- (void)insertRow:(__kindof JSMStaticRow *)row atIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

/**
 * Add the given `JSMStaticRow` object to the given `JSMStaticSection`.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param row A `JSMStaticRow` to insert into the content structure.
 * @param section The `JSMStaticSection` you want to add the row to.
 * @param animation The `UITableViewRowAnimation` you want to use for the update animation.
 * @return void
 */

- (void)addRow:(__kindof JSMStaticRow *)row toSection:(__kindof JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 * Insert the given `JSMStaticRow` object into the given `JSMStaticSection`.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param row A `JSMStaticRow` to insert into the content structure.
 * @param section The `JSMStaticSection` you want to insert the row into.
 * @param index The position within the given section that you want to insert the row into.
 * @param animation The `UITableViewRowAnimation` you want to use for the update animation.
 * @return void
 */

- (void)insertRow:(__kindof JSMStaticRow *)row intoSection:(__kindof JSMStaticSection *)section atIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation;

/**
 * Reload the given row if it exists within the reciever's data source.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param row The row you want to reload.
 * @param animation The `UITableViewRowAnimation` you want to use for the update animation.
 * @return void
 */

- (void)reloadRow:(__kindof JSMStaticRow *)row withRowAnimation:(UITableViewRowAnimation)animation;

/**
 * Remove the row at the given index path from the content structure.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param indexPath The location of the row you want to remove.
 * @param animation The `UITableViewRowAnimation` you want to use for the update animation.
 * @return void
 */

- (void)removeRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

/**
 * Remove the given row from the content structure.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param row The row you want to remove.
 * @param animation The `UITableViewRowAnimation` you want to use for the update animation.
 * @return void
 */

- (void)removeRow:(__kindof JSMStaticRow *)row withRowAnimation:(UITableViewRowAnimation)animation;

@end

NS_ASSUME_NONNULL_END
