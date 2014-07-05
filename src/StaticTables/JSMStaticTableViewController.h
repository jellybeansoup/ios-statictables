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

#import <UIKit/UIKit.h>
#import "JSMStaticDataSource.h"

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

@end
