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
#import "JSMStaticViewSection.h"
#import "JSMStaticViewCell.h"

@interface JSMStaticViewController : UITableViewController

/**
 *
 */

- (NSArray *)sections;

/**
 *
 */

- (JSMStaticViewSection *)sectionForIndex:(NSInteger)section;

/**
 *
 */

- (JSMStaticViewSection *)sectionForKey:(NSString *)key;

/**
 *
 */

- (NSString *)sectionKeyForIndex:(NSInteger)section;

/**
 *
 */

- (NSInteger)sectionIndexForKey:(NSString *)key;

/**
 *
 */

- (void)reloadTableView;

/**
 *
 */

- (void)refreshSections;

/**
 *
 */

- (UITableViewCellStyle)tableView:(UITableView *)tableView cellStyleAtIndexPath:(NSIndexPath *)indexPath;

/**
 *
 */

- (JSMStaticViewCell *)configureCell:(JSMStaticViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/**
 *
 */

- (void)tableView:(UITableView *)tableView cell:(JSMStaticViewCell *)cell wasSelectedAtIndexPath:(NSIndexPath *)indexPath;

///---------------------------------------------
/// @name Appearance
///---------------------------------------------

/**
 *
 */

@property (nonatomic, strong) UIColor *backgroundColor;

/**
 *
 */

@property (nonatomic, strong) UIColor *cellSeparatorColor;

/**
 *
 */

@property (nonatomic, strong) UIColor *cellBackgroundColor;

/**
 *
 */

@property (nonatomic, strong) UIColor *cellSelectedBackgroundColor;

@end
