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

@class JSMStaticDataSource;
@class JSMStaticSection;
@class JSMStaticRow;

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

- (NSArray *)section:(JSMStaticSection *)section rowsDidChange:(NSArray *)rows;

@end


/**
 * A `JSMStaticSection` objects acts as a data source for a single `JSMStaticViewController` section.
 * It defines the basic structure such as the number of rows and any header or footer text.
 */

@interface JSMStaticSection : NSObject

///---------------------------------------------
/// @name Managing the Delegate
///---------------------------------------------

/**
 * The object that acts as the delegate of the receiving section.
 *
 * The delegate must adopt the JSMStaticSectionDelegate protocol. The delegate is not retained.
 */

@property (nonatomic, weak) id <JSMStaticSectionDelegate> delegate;

///---------------------------------------------
/// @name Data Structure
///---------------------------------------------

/**
 * The `JSMStaticDataSource` that the section belongs to.
 */

@property (nonatomic, weak, readonly) JSMStaticDataSource *dataSource;

///---------------------------------------------
/// @name Managing the Section's Content
///---------------------------------------------

/**
 * A collection of `JSMStaticRow` objects used to define the content of this section.
 */

@property (nonatomic, weak) NSArray *rows;

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
 * Fetch the `JSMStaticRow` representing the row at the given index.
 *
 * @param index The location of the row you want to retrieve.
 * @return The row at the given index, or `nil` if no row is available.
 */

- (JSMStaticRow *)rowAtIndex:(NSUInteger)index;

/**
 * Fetch the index within the content structure for the given row.
 *
 * @param row The row you want to find within the section.
 * @return The index, or -1 if the row is not present.
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
