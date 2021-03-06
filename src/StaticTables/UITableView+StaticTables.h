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

@import UIKit;

@class JSMStaticSection;
@class JSMStaticRow;

NS_ASSUME_NONNULL_BEGIN

/**
 * This category provides a number of convenience methods to `UITableView` to make dealing with
 * an attached `JSMStaticDataSource` easier and cleaner.
 *
 * Many of the methods in this category will throw an exception if the reciever's `dataSource` property
 * does not point to an instance of `JSMStaticDataSource`, but you probably figured that.
 */

@interface UITableView (StaticTables)

///---------------------------------------------
/// @name Preparing for Updates
///---------------------------------------------

/**
 * A block definition for performing table view updates in a batch.
 */

typedef void(^JSMTableViewUpdatesBlock)(UITableView *tableView);

/**
 * A block definition that is used to handle the completion of a batch of table view updates..
 */

typedef void(^JSMTableViewUpdatesCompletion)(void);

/**
 * Block based alternative to the `beginUpdates` and `endUpdates` methods.
 *
 * @param updates Block for encapsulating all the updates you want to perform on the reciever.
 */

- (void)performUpdates:(JSMTableViewUpdatesBlock)updates NS_SWIFT_NAME(performUpdates(_:));

/**
 * Block based alternative to the `beginUpdates` and `endUpdates` methods, with bonus completion
 * block that runs when the tableview's animations are completed.
 *
 * @param updates Block for encapsulating all the updates you want to perform on the reciever.
 * @param completion Block that is called when the updates have completed their animations.
 */

- (void)performUpdates:(JSMTableViewUpdatesBlock)updates withCompletion:(JSMTableViewUpdatesCompletion)completion NS_SWIFT_NAME(performUpdates(_:completion:));

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

- (__kindof JSMStaticSection *)createSectionWithRowAnimation:(UITableViewRowAnimation)animation NS_SWIFT_NAME(createSection(with:));

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

- (__kindof JSMStaticSection *)createSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation NS_SWIFT_NAME(createSection(at:with:));

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
 */

- (void)addSection:(__kindof JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation NS_SWIFT_NAME(add(_:with:));

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
 */

- (void)insertSection:(__kindof JSMStaticSection *)section atIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation NS_SWIFT_NAME(insert(_:at:with:));

/**
 * Fetch the `JSMStaticSection` representing the section at the given index.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param index The location of the section you want to retrieve.
 * @return The section at the given index, or `nil` if no section is available.
 */

- (__kindof JSMStaticSection * _Nullable)sectionAtIndex:(NSUInteger)index NS_SWIFT_NAME(section(index:));

/**
 * Fetch the index within the content structure for the given section.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param section The section you want to find within the content structure.
 * @return The index, or -1 if the section is not present.
 */

- (NSUInteger)indexForSection:(__kindof JSMStaticSection *)section NS_SWIFT_NAME(index(for:));

/**
 * Determine if the given section is within the content structure.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param section The section you want to find within the content structure.
 * @return Flag indicating if the object is present (true) or not (false).
 */

- (BOOL)containsSection:(__kindof JSMStaticSection *)section NS_SWIFT_NAME(contains(_:));

/**
 * Reload the given section if it exists within the reciever's data source.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param section The section you want to reload.
 * @param animation The `UITableViewRowAnimation` you want to use for the update animation.
 */

- (void)reloadSection:(__kindof JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation NS_SWIFT_NAME(reload(_:with:));

/**
 * Remove the section at the given index from the content structure.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param index The location of the section you want to remove.
 * @param animation The `UITableViewRowAnimation` you want to use for the update animation.
 */

- (void)removeSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation NS_SWIFT_NAME(removeSection(at:with:));

/**
 * Remove the given section from the content structure.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param section The section you want to remove.
 * @param animation The `UITableViewRowAnimation` you want to use for the update animation.
 */

- (void)removeSection:(__kindof JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation NS_SWIFT_NAME(remove(_:with:));

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

- (JSMStaticRow *)createRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation NS_SWIFT_NAME(createRow(at:with:));

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
 */

- (void)insertRow:(__kindof JSMStaticRow *)row atIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation NS_SWIFT_NAME(insert(_:at:with:));

/**
 * Add the given `JSMStaticRow` object to the given `JSMStaticSection`.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param row A `JSMStaticRow` to insert into the content structure.
 * @param section The `JSMStaticSection` you want to add the row to.
 * @param animation The `UITableViewRowAnimation` you want to use for the update animation.
 */

- (void)addRow:(__kindof JSMStaticRow *)row toSection:(__kindof JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation NS_SWIFT_NAME(add(_:to:with:));

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
 */

- (void)insertRow:(__kindof JSMStaticRow *)row intoSection:(__kindof JSMStaticSection *)section atIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation NS_SWIFT_NAME(insert(_:into:at:with:));

/**
 * Fetch the `JSMStaticRow` representing the row at the given index path.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param indexPath The location of the row you want to retrieve.
 * @return The row at the given index path, or `nil` if no row is available.
 */

- (__kindof JSMStaticRow * _Nullable)rowAtIndexPath:(NSIndexPath *)indexPath NS_SWIFT_NAME(row(at:));

/**
 * Fetch the index path within the content structure for the given row.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param row The row you which to find within the content structure.
 * @return The index path, or `nil` if the row is not present.
 */

- (NSIndexPath * _Nullable)indexPathForRow:(__kindof JSMStaticRow *)row NS_SWIFT_NAME(indexPath(for:));

/**
 * Reload the given row if it exists within the reciever's data source.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param row The row you want to reload.
 * @param animation The `UITableViewRowAnimation` you want to use for the update animation.
 */

- (void)reloadRow:(__kindof JSMStaticRow *)row withRowAnimation:(UITableViewRowAnimation)animation NS_SWIFT_NAME(reload(_:with:));

/**
 * Remove the row at the given index path from the content structure.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param indexPath The location of the row you want to remove.
 * @param animation The `UITableViewRowAnimation` you want to use for the update animation.
 */

- (void)removeRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation NS_SWIFT_NAME(removeRow(at:with:));

/**
 * Remove the given row from the content structure.
 *
 * If the attached data source is not an instance of `JSMStaticDataSource`, calling this method will
 * throw an "Invalid Data Source" exception.
 *
 * @param row The row you want to remove.
 * @param animation The `UITableViewRowAnimation` you want to use for the update animation.
 */

- (void)removeRow:(__kindof JSMStaticRow *)row withRowAnimation:(UITableViewRowAnimation)animation NS_SWIFT_NAME(remove(_:with:));

@end

NS_ASSUME_NONNULL_END
