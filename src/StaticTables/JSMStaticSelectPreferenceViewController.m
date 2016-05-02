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

#import "JSMStaticSelectPreferenceViewController.h"
#import "JSMStaticSelectPreference.h"
#import "JSMStaticDataSource.h"

@interface JSMStaticSelectPreferenceViewController ()

@property (nonatomic, strong) JSMStaticSection *section;

@property (nonatomic, strong) NSMutableDictionary *rows;

@end

@interface JSMStaticSelectPreference (JSMStaticSelectPreferenceViewController)

- (void)clearViewController;

@end

@implementation JSMStaticSelectPreferenceViewController

#pragma mark - Creating the View Controller

- (instancetype)initWithPreference:(JSMStaticSelectPreference *)preference {
    if( ( self = [super initWithStyle:UITableViewStyleGrouped] ) ) {
        _preference = preference;
        _rows = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set the view title
    self.title = self.preference.text;

    // Add the section
    self.section = [JSMStaticSection section];
    [self.dataSource addSection:self.section];

    // Prepare the section with the preference's options
    [self.preference.options enumerateObjectsUsingBlock:^(NSDictionary *option, NSUInteger idx, BOOL *stop) {
        if( ! [option isKindOfClass:[NSDictionary class]] || option[JSMStaticSelectOptionValue] == nil ) {
            return;
        }

        id optionValue = option[JSMStaticSelectOptionValue];
        JSMStaticRow *row = [JSMStaticRow rowWithKey:option[JSMStaticSelectOptionValue]];
        row.style = UITableViewCellStyleSubtitle;

        id optionLabel = option[JSMStaticSelectOptionLabel] ?: optionValue;
        if( [optionLabel isKindOfClass:[NSString class]] ) {
            row.text = (NSString *)optionLabel;
        }

        id optionImage = option[JSMStaticSelectOptionImage];
        if( [optionImage isKindOfClass:[NSString class]] ) {
            row.image = [UIImage imageNamed:(NSString *)optionImage];
        }
        else if( [optionImage isKindOfClass:[UIImage class]] ) {
            row.image = (UIImage *)optionImage;
        }

        // We place a checkmark on the selected option
        JSMStaticSelectPreferenceViewController __weak *weakSelf = self;
        [row configurationForCell:^(JSMStaticRow *_row, UITableViewCell *cell) {
            JSMStaticSelectPreferenceViewController __strong *strongSelf = weakSelf;
            if( [strongSelf.preference.value isEqual:_row.key] ) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }];

        // Add to the section
		self.rows[optionValue] = row;
        [self.section addRow:row];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Reload the tableview
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    // Reload the tableview
    [self.preference clearViewController];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Find the rows for the existing and new values
    JSMStaticRow *oldRow = self.rows[self.preference.value];
    JSMStaticRow *newRow = [self.dataSource rowAtIndexPath:indexPath];
    // If the rows are actually one and the same, stop right now.
    if( [oldRow isEqual:newRow] ) {
        return;
    }
    // We're going to perform some updates
    [tableView beginUpdates];
    // Find the row that is checked and reload it
    if( oldRow != nil ) {
        [tableView reloadRowsAtIndexPaths:@[[self.dataSource indexPathForRow:oldRow]] withRowAnimation:UITableViewRowAnimationFade];
    }
    // Fetch the row for the option we are going to select and reload it
    self.preference.value = newRow.key;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    // And our updates are complete
    [tableView endUpdates];
}

@end
