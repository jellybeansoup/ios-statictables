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

@class JSMStaticDataSource;
@class JSMStaticSection;
@class JSMStaticRow;

NS_ASSUME_NONNULL_BEGIN

/**
 * Objects can adopt the `JSMStaticDataSourceDelegate` protocol to recieve notifications on changes
 * to the data source, allowing them to react accordingly, as well as make additional changes (like sorting
 * the data structure).
 */

@protocol JSMStaticDataSourceDelegate <NSObject>

@optional

/**
 * Called when the collection of `JSMStaticSection` object has been modified.
 *
 * The purpose of this method is to allow the delegate to make any modifications desired to the sections array
 * when changes are detected, such as sorting of the array contents. Sections should not be added, removed or altered
 * within this method, as it will cause an exception.
 *
 * @param dataSource The data source whose sections were modified.
 * @param sections The modified collection of sections contained in the data source.
 * @return The collection of `JSMStaticSection` objects, as provided in the `sections` parameter, with any
 *      required modifications performed on it.
 */

- (NSArray <JSMStaticSection *> *)dataSource:(JSMStaticDataSource *)dataSource sectionsDidChange:(NSArray <JSMStaticSection *> *)sections;

/**
 * Called when a `section` requests a reload using its `setNeedsReload` method.
 *
 * This method is optional, but it is strongly suggested that, if you are not using `JSMStaticTableViewController`, you
 * implement it and perform the appropriate reload on your table view. This will allow you to easily respond to requests
 * by the section to reload its contents, and will allow you to make changes without having to perform refreshes throughout
 * your code.
 *
 * @param dataSource The data source that contains the section needing to be reloaded.
 * @param section The section that requested to be reloaded.
 * @param index The index of the section within the data source.
 * @return void
 */

- (void)dataSource:(JSMStaticDataSource *)dataSource sectionNeedsReload:(JSMStaticSection *)section atIndex:(NSUInteger)index;

/**
 * Called when a `row` requests a reload using its `setNeedsReload` method.
 *
 * This method is optional, but it is strongly suggested that, if you are not using `JSMStaticTableViewController`, you
 * implement it and perform the appropriate reload on your table view. This will allow you to easily respond to requests
 * by the section to reload its contents, and will allow you to make changes without having to perform refreshes throughout
 * your code.
 *
 * @param dataSource The data source that contains the row needing to be reloaded.
 * @param row The row that requested to be reloaded.
 * @param indexPath The index path of the row within the data source.
 * @return void
 */

- (void)dataSource:(JSMStaticDataSource *)dataSource rowNeedsReload:(JSMStaticRow *)row atIndexPath:(NSIndexPath *)indexPath;

/**
 * Called when the user moves a `row` in edit mode.
 *
 * For this method to be called, the row's `canBeMoved` flag must be set to `YES`, and the user must then drag the row.
 * The method is not called if a row is moved programmatically.
 *
 * @param dataSource The data source that contains the row that was moved.
 * @param row The row that was moved by the user.
 * @param fromIndexPath The original index path of the row within the data source (before it was moved).
 * @param toIndexPath The new index path of the row within the data source (after it was moved).
 * @return void
 */

- (void)dataSource:(JSMStaticDataSource *)dataSource didMoveRow:(JSMStaticRow *)row fromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

/**
 * Called after the data source deletes a row at the request of the user.
 *
 * For this method to be called, the row's `canBeDeleted` flag must be set to `YES`, and the user must then delete the row.
 * The method is not called if a row is removed programmatically.
 *
 * If implemented, you will need to perform the animation for removing the cell from the tableview using the
 * `tableView:deleteRowsAtIndexPaths:withRowAnimation:` yourself.
 *
 * @param dataSource The data source that contained the row before it was deleted.
 * @param row The row that was deleted by the user.
 * @param indexPath The index path of the row before it was deleted.
 * @return void
 */

- (void)dataSource:(JSMStaticDataSource *)dataSource didDeleteRow:(JSMStaticRow *)row fromIndexPath:(NSIndexPath *)indexPath;

/**
 * Notifies the receiver that the data source is about to start processing of one or more changes due to an add, remove, or move.
 *
 * This method is called before all calls to `dataSource:didChangeRow:atIndexPath:newIndexPath:` and
 * `dataSource:didChangeSection:atIndex:newIndex:` have been sent for a given change event.
 *
 * @param dataSource The data source that was changed.
 */

- (BOOL)dataSourceShouldPerformChanges:(JSMStaticDataSource *)dataSource;

/**
 * Notifies the receiver that a section has been changed due to an add, remove or move.
 *
 * This method is called once for each changed section detected by the data source.
 *
 * @param dataSource The data source that was changed.
 * @param section The section that changed.
 * @param index The original index for the changed section (or `NSNotFound` for insertions).
 * @param newIndex The new index for the changed section (or `NSNotFound` for deletions).
 */

- (void)dataSource:(JSMStaticDataSource *)dataSource didChangeSection:(JSMStaticSection *)section atIndex:(NSUInteger)index newIndex:(NSUInteger)newIndex;

/**
 * Notifies the receiver that a row has been changed due to an add, remove or move.
 *
 * This method is called once for each changed row detected by the data source.
 *
 * @param dataSource The data source that was changed.
 * @param row The row that changed.
 * @param indexPath The original index path for the changed row (or `nil` for insertions).
 * @param newIndexPath The new index path for the changed row (or `nil` for deletions).
 */

- (void)dataSource:(JSMStaticDataSource *)dataSource didChangeRow:(__kindof JSMStaticRow *)row atIndexPath:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath;

/**
 * Notifies the receiver that the data source has completed processing of one or more changes due to an add, remove, or move.
 *
 * This method is called after all calls to `dataSource:didChangeRow:atIndexPath:newIndexPath:` and
 * `dataSource:didChangeSection:atIndex:newIndex:` have been sent for a given change event.
 *
 * @param dataSource The data source that was changed.
 */

- (void)dataSourceDidPerformChanges:(JSMStaticDataSource *)dataSource;

@end

/**
 * A `JSMStaticDataSource` objects can act as a data source for a `UITableView`.
 */

@interface JSMStaticDataSource : NSObject <UITableViewDataSource>

///---------------------------------------------
/// @name Managing the Table View
///---------------------------------------------

/**
 * The table view the data source is supplying data to.
 *
 * If for whatever reason you've set the reciever as the data source for multiple table views (which is crazy), the value of
 * this property will be the most recently updated table view.
 */

@property (nonatomic, weak, readonly, nullable) UITableView *tableView;

///---------------------------------------------
/// @name Managing the Delegate
///---------------------------------------------

/**
 * The object that acts as the delegate of the receiving data source.
 *
 * The delegate must adopt the JSMStaticDataSourceDelegate protocol. The delegate is not retained.
 */

@property (nonatomic, weak, nullable) id <JSMStaticDataSourceDelegate> delegate;

///---------------------------------------------
/// @name Creating Table View Cells
///---------------------------------------------

/**
 * The class used by the data source when allocating new table view cells.
 */

@property (nonatomic) Class cellClass;

/**
 * Fetch the default table view cell class for all instances of `JSMStaticDataSource`.
 *
 * The class returned is used by all instances of `JSMStaticDataSource`, except where it is overridden by
 * providing an alternate class with the `cellClass` property.
 *
 * @return The default class used by data source instances when allocating new table view cells.
 */

+ (Class)cellClass;

/**
 * Set the default table view cell class for all instances of `JSMStaticDataSource`.
 *
 * The class given is used by all instances of `JSMStaticDataSource`, except where it is overridden by providing
 * an alternate class with the `cellClass` property.
 *
 * @param cellClass The default class to be used by data source instances when allocating new table view cells.
 * @return void
 */

+ (void)setCellClass:(Class)cellClass;

///---------------------------------------------
/// @name Managing the Sections
///---------------------------------------------

/**
 * A collection of `JSMStaticSection` objects contained in the reciever.
 */

@property (nonatomic, weak) NSArray <JSMStaticSection *> *sections;

/**
 * The number of `JSMStaticSection` objects contained in the reciever.
 */

@property (nonatomic, readonly) NSUInteger numberOfSections;

/**
 * Creates a new `JSMStaticSection` object and adds it to the end of the observer.
 *
 * @return The resulting instance of `JSMStaticSection`.
 */

- (JSMStaticSection *)createSection;

/**
 * Creates a new `JSMStaticSection` object and inserts it into the observer at the given index.
 *
 * @param index The location at which to insert the section.
 * @return The resulting instance of `JSMStaticSection`.
 */

- (JSMStaticSection *)createSectionAtIndex:(NSUInteger)index;

/**
 * Adds the given `JSMStaticSection` object to the content structure.
 *
 * If the section exists in a data source already, it will be removed before being added to the observer.
 *
 * @param section A `JSMStaticSection` to add.
 * @return void
 */

- (void)addSection:(JSMStaticSection *)section;

/**
 * Inserts the given `JSMStaticSection` object at the given index.
 *
 * If the section exists in a data source already, it will be removed before being inserted into the observer.
 *
 * @param section A `JSMStaticSection` to insert into the content structure.
 * @param index The location at which to insert the section.
 * @return void
 */

- (void)insertSection:(JSMStaticSection *)section atIndex:(NSUInteger)index;

/**
 * Fetch the `JSMStaticSection` with the given key.
 *
 * If more than one section exists for the given key, only the first will be returned.
 *
 * @param key The key matching the static section you want to retrieve.
 * @return The section matching the given key, or `nil` if no section is available.
 */

- (JSMStaticSection * _Nullable)sectionWithKey:(NSString *)key;

/**
 * Fetch the `JSMStaticSection` representing the section at the given index.
 *
 * @param index The location of the section you want to retrieve.
 * @return The section at the given index, or `nil` if no section is available.
 */

- (JSMStaticSection * _Nullable)sectionAtIndex:(NSUInteger)index;

/**
 * Fetch the index within the content structure for the given section.
 *
 * @param section The section you want to find within the content structure.
 * @return The index, or `NSNotFound` if the section is not present.
 */

- (NSUInteger)indexForSection:(JSMStaticSection *)section;

/**
 * Determine if the given section is within the content structure.
 *
 * @param section The section you want to find within the content structure.
 * @return Flag indicating if the object is present (true) or not (false).
 */

- (BOOL)containsSection:(JSMStaticSection *)section;

/**
 * Remove the section at the given index from the content structure.
 *
 * @param index The location of the section you want to remove.
 * @return void
 */

- (void)removeSectionAtIndex:(NSUInteger)index;

/**
 * Remove the given section from the content structure.
 *
 * @param section The section you want to remove.
 * @return void
 */

- (void)removeSection:(JSMStaticSection *)section;

/**
 * Remove all of the sections from the content structure.
 *
 * @return void
 */

- (void)removeAllSections;

///---------------------------------------------
/// @name Managing the Rows
///---------------------------------------------

/**
 * Creates a new `JSMStaticRow` object and inserts it at the given index path.
 *
 * @param indexPath The location at which to insert the row.
 * @return The resulting instance of `JSMStaticRow`.
 */

- (JSMStaticRow *)createRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * Inserts the given `JSMStaticSection` object at the given index path.
 *
 * If the row exists in a section already, it will be removed before being inserted at the given index path.
 *
 * @param row A `JSMStaticSection` to insert into the content structure.
 * @param indexPath The location at which to insert the row.
 * @return void
 */

- (void)insertRow:(__kindof JSMStaticRow *)row atIndexPath:(NSIndexPath *)indexPath;

/**
 * Fetch the `JSMStaticRow` with the given key.
 *
 * If more than one row exists for the given key, only the first will be returned.
 *
 * @param key The key matching the static row you want to retrieve.
 * @return The key matching the given key, or `nil` if no key is available.
 */

- (__kindof JSMStaticRow * _Nullable)rowWithKey:(NSString *)key;

/**
 * Fetch the `JSMStaticRow` representing the row at the given index path.
 *
 * @param indexPath The location of the row you want to retrieve.
 * @return The row at the given index path, or `nil` if no row is available.
 */

- (__kindof JSMStaticRow * _Nullable)rowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * Fetch the index path within the content structure for the given row.
 *
 * @param row The row you which to find within the content structure.
 * @return The index path, or `nil` if the row is not present.
 */

- (NSIndexPath * _Nullable)indexPathForRow:(__kindof JSMStaticRow *)row;

/**
 * Remove the row at the given index path from the content structure.
 *
 * @param indexPath The location of the row you want to remove.
 * @return void
 */

- (void)removeRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * Remove the given row from the content structure.
 *
 * @param row The row you want to remove.
 * @return void
 */

- (void)removeRow:(__kindof JSMStaticRow *)row;

///---------------------------------------------
/// @name Responding to changes
///---------------------------------------------

/**
 * Method called when the section is about to start processing of one or more changes due to an add, remove, or move.
 * It is intended to be used by subclasses of `JSMStaticSection` to respond internally to changes performed on the
 * section's rows. It is equivalent to the section delegate's `sectionWillPerformChanges` method, but is called after
 * the delegate's implementation.
 *
 * This method is called before all calls to `didChangeRow:atIndex:newIndex:` have been sent for a given change event.
 */

- (BOOL)shouldPerformChanges;

/**
 * Method called when a row has been changed due to an add, remove or move. It is intended to be used by subclasses
 * of `JSMStaticSection` to respond internally to changes performed on the section's rows. It is equivalent to the
 * section delegate's `section:didChangeRow:atIndex:newIndex:` method, but is called after the delegate's implementation.
 *
 * This method is called once for each change detected by the section.
 *
 * @param row The row in the sections `rows` collection which changed.
 * @param index The original index for the changed row (or `NSNotFound` for insertions).
 * @param newIndex The new index for the changed row (or `NSNotFound` for deletions).
 */

- (void)didChangeSection:(JSMStaticSection *)row atIndex:(NSUInteger)index newIndex:(NSUInteger)newIndex;

/**
 * Method called when a row has been changed due to an add, remove or move. It is intended to be used by subclasses
 * of `JSMStaticSection` to respond internally to changes performed on the section's rows. It is equivalent to the
 * section delegate's `section:didChangeRow:atIndex:newIndex:` method, but is called after the delegate's implementation.
 *
 * This method is called once for each change detected by the section.
 *
 * @param row The row in the sections `rows` collection which changed.
 * @param index The original index for the changed row (or `NSNotFound` for insertions).
 * @param newIndex The new index for the changed row (or `NSNotFound` for deletions).
 */

- (void)didChangeRow:(__kindof JSMStaticRow *)row atIndexPath:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath;

/**
 * Method called when the section has completed processing of one or more changes due to an add, remove, or move.
 * It is intended to be used by subclasses of `JSMStaticSection` to respond internally to changes performed on the
 * section's rows. It is equivalent to the section delegate's `sectionWillPerformChanges` method, but is called after
 * the delegate's implementation.
 *
 * This method is called after all calls to `didChangeRow:atIndex:newIndex:` have been sent for a given change event.
 */

- (void)didPerformChanges;

@end
NS_ASSUME_NONNULL_END
