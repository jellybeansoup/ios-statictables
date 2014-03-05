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

#import "JSMPreferenceViewController.h"

@interface JSMPreferenceViewController ()

/**
 * The index path for the currently selected option.
 */

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation JSMPreferenceViewController

#pragma mark - Factory

+ (instancetype)instanceWithPreference:(JSMPreference *)preference {
	JSMPreferenceViewController *viewController = [self new];
    viewController.preference = preference;
	return viewController;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set the navigation title
	self.navigationItem.title = self.title;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _preference.options.count;
}

- (JSMStaticViewCell *)configureCell:(JSMStaticViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Get the option for the given index path
    JSMPreferenceOption *option = [_preference optionForIndex:indexPath.row];
    // Configure the cell
	cell.textLabel.text = option.label;
	cell.textLabel.textColor = [UIColor darkTextColor];
    // Display the stat of this option's selection
	if( [option.value isEqual:_preference.value] ) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _selectedIndexPath = indexPath;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    // Return the cell
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // If this option is not selected
	if( ! [_selectedIndexPath isEqual:indexPath] ) {
		// Deselect the old row
		UITableViewCell *oldCell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
		oldCell.accessoryType = UITableViewCellAccessoryNone;
        // Get the option for the new index path
        JSMPreferenceOption *option = [_preference optionForIndex:indexPath.row];
        // Set the preference's value
		_preference.value = option.value;
		// Select the new row
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		_selectedIndexPath = indexPath;
    }
	// Remove the cell highlight
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
