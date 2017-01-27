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

#import "MainViewController.h"
#import "SettingsViewController.h"
#include <stdlib.h>

@interface MainViewController ()

@property (nonatomic, strong) JSMStaticSection *managers;

@property (nonatomic, strong) JSMStaticSection *employees;

@property (nonatomic, strong) JSMStaticSection *customers;

@end

@implementation MainViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Customers
    self.customers = [JSMStaticSection new];
    self.customers.headerText = @"Customers";
    self.customers.footerText = @"Tap customers to reorder.";
    [self.dataSource addSection:self.customers];

    JSMStaticRow *devina = [JSMStaticRow new];
    devina.text = @"Devina";
    [self.customers addRow:devina];
	
	JSMStaticRow *chase = [JSMStaticRow new];
	chase.text = @"Chase";
	[self.customers addRow:chase];
	
	JSMStaticRow *anthony = [JSMStaticRow new];
	anthony.text = @"Anthony";
	[self.customers addRow:anthony];
	
	JSMStaticRow *dominic = [JSMStaticRow new];
	dominic.text = @"Dominic";
	[self.customers addRow:dominic];
	
	JSMStaticRow *hatterman = [JSMStaticRow new];
	hatterman.text = @"Hatterman";
	[self.customers addRow:hatterman];
	
	JSMStaticRow *lydia = [JSMStaticRow new];
	lydia.text = @"Lydia";
	[self.customers addRow:lydia];
	
	JSMStaticRow *monica = [JSMStaticRow new];
	monica.text = @"Monica";
	[self.customers addRow:monica];

    // Managers
    self.managers = [JSMStaticSection new];
    self.managers.headerText = @"Managers";
    self.managers.footerText = @"Tap a manager to demote them.";
    [self.dataSource addSection:self.managers];

    JSMStaticRow *norma = [JSMStaticRow new];
    norma.text = @"Norma";
    norma.detailText = @"Technician";
    norma.style = UITableViewCellStyleDefault;
    [self.managers addRow:norma];

    // Employees
    self.employees = [JSMStaticSection new];
    self.employees.delegate = self;
    self.employees.headerText = @"Employees";
    self.employees.footerText = @"Tap an employee to promote them.";
    [self.dataSource addSection:self.employees];

    JSMStaticRow *jason = [JSMStaticRow new];
    jason.text = @"Jason";
    jason.detailText = @"Ticketing";
    jason.style = UITableViewCellStyleSubtitle;
    [self.employees addRow:jason];

    JSMStaticRow *becky = [JSMStaticRow new];
    becky.text = @"Becky";
    becky.detailText = @"Ticketing";
    becky.style = UITableViewCellStyleSubtitle;
    [self.employees addRow:becky];

    JSMStaticRow *melissa = [JSMStaticRow new];
    melissa.text = @"Melissa";
    melissa.detailText = @"Concessions";
    melissa.style = UITableViewCellStyleSubtitle;
    [self.employees addRow:melissa];

    JSMStaticRow *kurt = [JSMStaticRow new];
    kurt.text = @"Kurt";
    kurt.detailText = @"Janitorial";
    kurt.style = UITableViewCellStyleSubtitle;
    [self.employees addRow:kurt];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Fetch the row that was selected
    JSMStaticRow *row = [self.dataSource rowAtIndexPath:indexPath];

	// Let's randomly shuffle the selected customer to a new position within the same section
	if( [row.section isEqual:self.customers] ) {
		NSUInteger oldIndex = [row.section indexForRow:row];
		NSUInteger newIndex = arc4random_uniform((uint32_t)row.section.numberOfRows);
		
		// So we always appear to move, we may need to fudge the new index a bit.
		// Note that the row's old index plus one would also appear not to move, so we'll need to fudge that too.
		if( newIndex == oldIndex || newIndex == oldIndex + 1 ) {
			newIndex = oldIndex + 2;
		}
		
		// We can simply insert the row at it's new index, and it'll move automatically.
		[tableView performUpdates:^(UITableView *tableView) {
			[tableView insertRow:row intoSection:row.section atIndex:newIndex withRowAnimation:UITableViewRowAnimationAutomatic];
		}];

		return;
	}

	// Here, we'll move people between sections
	JSMStaticSection *newSection;
	if( [row.section isEqual:self.employees] ) {
		newSection = self.managers;
	}
	else if( [row.section isEqual:self.managers] ) {
		newSection = self.employees;
	}

	// And if we recieved a section, we go forth!
    if( newSection != nil ) {
        JSMStaticSection *oldSection = row.section;
        MainViewController __weak *weakSelf = self;

        // If we removed the section we're moving to, we need to add it back in first.
        if( ! [newSection.dataSource isEqual:self.dataSource] ) {
            [tableView performUpdates:^(UITableView *tableView) {
                [tableView addSection:newSection withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        }

        // We'll add the row (or rather, move it), and then make a quick change when that's completed.
        [tableView performUpdates:^(UITableView *tableView) {
            [tableView addRow:row toSection:newSection withRowAnimation:UITableViewRowAnimationFade];
        } withCompletion:^{

            // Note that we don't have to reload when the style is changed here. That's because the row asks to
            // be reloaded, and JSMStaticTableViewController obliges automatically.
            if( newSection == weakSelf.managers ) {
                row.style = UITableViewCellStyleDefault;
            }
            else {
                row.style = UITableViewCellStyleSubtitle;
            }

        }];
		
		// Once we've moved the row, we can safely remove any empty sections
		[tableView performUpdates:^(UITableView *tableView) {
			if( oldSection.numberOfRows == 0 ) {
				[tableView removeSection:oldSection withRowAnimation:UITableViewRowAnimationAutomatic];
			}
			else {
				//[oldSection setNeedsReload];
			}
		}];
	}
}

#pragma mark - Static data source delegate

// Here, we use the data source delegate method to find out when it's section change and to then
// re-sort them automatically in the order we want them.

- (NSArray *)dataSource:(JSMStaticDataSource *)viewController sectionsDidChange:(NSArray *)sections {
    NSArray *sectionOrder = @[ @"Managers", @"Employees", @"Customers" ];
    return [sections sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSUInteger obj1Index = [sectionOrder indexOfObject:[(JSMStaticSection *)obj1 headerText]];
        NSUInteger obj2Index = [sectionOrder indexOfObject:[(JSMStaticSection *)obj2 headerText]];
        if( obj1Index > obj2Index ) {
            return NSOrderedDescending;
        }
        else if( obj1Index < obj2Index ) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

#pragma mark - Static section delegate

// We do the same with rows in the employees section, sorting alphabetically by name.

- (NSArray *)section:(JSMStaticSection *)section rowsDidChange:(NSArray *)rows {
    return [rows sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[(JSMStaticRow *)obj1 text] compare:[(JSMStaticRow *)obj2 text]];
    }];
}

@end
