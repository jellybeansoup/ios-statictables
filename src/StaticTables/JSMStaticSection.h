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

@protocol JSMStaticSectionDelegate <NSObject>

@optional

/**
 * Called when the collection of `JSMStaticRow` objects has been modified.
 *
 * The purpose of this method is to allow the delegate to make any modifications desired to the rows
 * array when changes are detected, such as sorting of the array contents.
 *
 * @param section The section whose rows were modified.
 * @param rows The modified collection of rows contained in the section.
 * @return The collection of `JSMStaticRow` objects, as provided in the `rows` parameter, with any
 *      required modifications performed on it.
 */

- (NSArray *)section:(JSMStaticSection *)section rowsDidChange:(NSArray <JSMStaticRow *> *)rows;

/**
 * Called when the user moves a `row` in edit mode for both the section the row was originally in, and the section
 * the row was moved to (if the section stays the same, it is only called once).
 *
 * For this method to be called, the row's `canBeMoved` flag must be set to `YES`, and the user must then drag the row.
 * The method is not called if a row is moved programmatically.
 *
 * @param section The section that contains the row that was moved (either before or after the move).
 * @param row The row that was moved by the user.
 * @param fromIndexPath The original index path of the row within the data source (before it was moved).
 * @param toIndexPath The new index path of the row within the data source (after it was moved).
 * @return void
 */

- (void)section:(JSMStaticSection *)section didMoveRow:(JSMStaticRow *)row fromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

/**
 * Called after the data source deletes a row at the request of the user.
 *
 * For this method to be called, the row's `canBeDeleted` flag must be set to `YES`, and the user must then delete the row.
 * The method is not called if a row is removed programmatically.
 *
 * Unlike the repective `JSMStaticDataSourceDelegate` method, this method is called *after* the row is deleted from the
 * table view. To alter the animation used, or to perform tasks before the animation occurs, you will need to implement
 * the `JSMStaticDataSourceDelegate` method instead.
 *
 * @param section The section that contained the row before it was deleted.
 * @param row The row that was deleted by the user.
 * @param indexPath The index path of the row before it was deleted.
 * @return void
 */

- (void)section:(JSMStaticSection *)section didDeleteRow:(JSMStaticRow *)row fromIndexPath:(NSIndexPath *)indexPath;

@end


/**
 * A `JSMStaticSection` objects acts as a data source for a single `JSMStaticViewController` section.
 * It defines the basic structure such as the number of rows and any header or footer text.
 */

@interface JSMStaticSection : NSObject

///---------------------------------------------
/// @name Creating Sections
///---------------------------------------------

/**
 * Allocates and initialises an instance of `JSMStaticSection`.
 *
 * @return The new instance of `JSMStaticSection`.
 */

+ (instancetype)section;

/**
 * Allocates and initialises an instance of `JSMStaticSection` with the given key.
 *
 * @param key The key to use in identifying the section.
 * @return The new instance of `JSMStaticSection` with the given key.
 */

+ (instancetype)sectionWithKey:(NSString * _Nullable)key;

/**
 * An identifier for the reciever.
 *
 * This identifier is provided as part of `rowWithKey:` and cannot be changed.
 */

@property (nonatomic, copy, readonly, nullable) NSString * key;

///---------------------------------------------
/// @name Comparing Sections
///---------------------------------------------

/**
 * Test whether the reciever is equal to another section.
 *
 * This method considers two sections to be equal if:
 * - they are the same object.
 * - both sections have keys and both keys are equal.
 * - neither section has a key, but the `headerText`, `footerText` and `rows` are all equal.
 *
 * @param section The section to compare to the reciever.
 * @return Flag that indicates if the given section is equal to the the reciever (`YES`) or not (`NO`).
 */

- (BOOL)isEqualToSection:(JSMStaticSection *)section;

///---------------------------------------------
/// @name Managing the Delegate
///---------------------------------------------

/**
 * The object that acts as the delegate of the receiving section.
 *
 * The delegate must adopt the JSMStaticSectionDelegate protocol. The delegate is not retained.
 */

@property (nonatomic, weak, nullable) id <JSMStaticSectionDelegate> delegate;

///---------------------------------------------
/// @name Data Structure
///---------------------------------------------

/**
 * The table view the section belongs to.
 * 
 * @see JSMStaticDataSource.tableview
 */

@property (nonatomic, weak, readonly, nullable) UITableView *tableView;

/**
 * The `JSMStaticDataSource` that the section belongs to.
 */

@property (nonatomic, weak, readonly, nullable) JSMStaticDataSource *dataSource;

///---------------------------------------------
/// @name Managing the Section's Content
///---------------------------------------------

/**
 * A collection of `JSMStaticRow` objects used to define the content of this section.
 */

@property (nonatomic, weak) NSArray <JSMStaticRow *> *rows;

/**
 * The number of `JSMStaticRow` objects in this section.
 */

@property (nonatomic, readonly) NSUInteger numberOfRows;

/**
 * Creates a new `JSMStaticRow` object and adds it to the end of the section.
 *
 * @return The resulting instance of `JSMStaticRow`.
 */

- (JSMStaticRow *)createRow;

/**
 * Creates a new `JSMStaticRow` object and inserts it into the section at the provided index.
 *
 * @param index The location at which to insert the row.
 * @return The resulting instance of `JSMStaticRow`.
 */

- (JSMStaticRow *)createRowAtIndex:(NSUInteger)index;

/**
 * Adds the given `JSMStaticRow` object to the end of the section.
 *
 * If the row exists in a section already, it will be removed before being added to the observer.
 *
 * @param row A `JSMStaticRow` to add to the section.
 * @return void
 */

- (void)addRow:(JSMStaticRow *)row;

/**
 * Inserts the given `JSMStaticRow` object into the section at the provided index.
 *
 * If the row exists in a section already, it will be removed before being inserted into the observer.
 *
 * @param row A `JSMStaticRow` to insert into the section.
 * @param index The index at which to insert the row.
 * @return void
 */

- (void)insertRow:(JSMStaticRow *)row atIndex:(NSUInteger)index;

/**
 * Fetch the `JSMStaticRow` with the given key.
 *
 * If more than one row exists for the given key, only the first will be returned.
 *
 * @param key The key matching the static row you want to retrieve.
 * @return The key matching the given key, or `nil` if no key is available.
 */

- (JSMStaticRow * _Nullable)rowWithKey:(NSString *)key;

/**
 * Fetch the `JSMStaticRow` representing the row at the given index.
 *
 * @param index The location of the row you want to retrieve.
 * @return The row at the given index, or `nil` if no row is available.
 */

- (JSMStaticRow * _Nullable)rowAtIndex:(NSUInteger)index;

/**
 * Fetch the index within the content structure for the given row.
 *
 * @param row The row you want to find within the section.
 * @return The index, or `NSNotFound` if the row is not present.
 */

- (NSUInteger)indexForRow:(JSMStaticRow *)row;

/**
 * Determine if the given section is within the content structure.
 *
 * @param row The row you want to find within the section.
 * @return Flag indicating if the object is present (true) or not (false).
 */

- (BOOL)containsRow:(JSMStaticRow *)row;

/**
 * Remove the row at the given index from the section.
 *
 * @param index The location of the row you want to remove.
 * @return void
 */

- (void)removeRowAtIndex:(NSUInteger)index;

/**
 * Remove the given row from the section.
 *
 * @param row The row you want to remove.
 * @return void
 */

- (void)removeRow:(JSMStaticRow *)row;

/**
 * Remove all of the rows from the section.
 *
 * @return void
 */

- (void)removeAllRows;

///---------------------------------------------
/// @name Managing Headers and Footers
///---------------------------------------------

/**
 * The text used in the section header.
 */

@property (nonatomic, copy, nullable) NSString *headerText;

/**
 * The text used in the section footer.
 */

@property (nonatomic, copy, nullable) NSString *footerText;

///---------------------------------------------
/// @name Refreshing the Section
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
NS_ASSUME_NONNULL_END
