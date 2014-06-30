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

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) JSMStaticDataSource *dataSource;

@property (nonatomic, strong) JSMStaticSection *preferences;

@property (nonatomic, strong) JSMStaticSection *managers;

@property (nonatomic, strong) JSMStaticSection *employees;

@property (nonatomic, strong) JSMStaticSection *customers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Static Tables";

    // Create the data source
    self.dataSource = [JSMStaticDataSource new];
    self.dataSource.delegate = self;

    // Apply the data source to the table view
    self.tableView.dataSource = self.dataSource;

    // Preferences
    self.preferences = [JSMStaticSection new];
    self.preferences.headerText = @"Preferences";
    [self.dataSource addSection:self.preferences];

    JSMStaticTextPreference *urlPreference = [JSMStaticTextPreference preferenceWithKey:@"com.jellystyle.staticTables.url"];
    urlPreference.text = @"URL";
    urlPreference.defaultValue = @"http://apple.com";
    urlPreference.textField.keyboardType = UIKeyboardTypeURL;
    [self.preferences addRow:urlPreference];

    JSMStaticBooleanPreference *boolPreference = [JSMStaticBooleanPreference preferenceWithKey:@"com.jellystyle.staticTables.bool"];
    boolPreference.text = @"Boolean";
    boolPreference.toggle.onTintColor = [UIColor purpleColor];
    [self.preferences addRow:boolPreference];

    JSMStaticSelectPreference *selectPreference = [JSMStaticSelectPreference preferenceWithKey:@"com.jellystyle.staticTables.select"];
    selectPreference.text = @"Select";
    //selectPreference.detailText = @"This probably shouldn't work.";
    selectPreference.options = @{ @"option1": @"Option 1", @"option2": @"Option 2", @"option3": @"Option 3" };
    [self.preferences addRow:selectPreference];

    NSLog(@"%@",selectPreference.defaultValue);


    JSMStaticRow *reset = [JSMStaticRow new];
    reset.style = UITableViewCellStyleDefault;
    reset.text = @"Reset All Preferences";
    [reset configurationForCell:^(JSMStaticRow *row, UITableViewCell *cell) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithRed:0.6 green:0 blue:0 alpha:1];
    }];
    [self.preferences addRow:reset];

    // Managers
    self.managers = [JSMStaticSection new];
    self.managers.headerText = @"Managers";
    self.managers.footerText = @"Tap a manager to demote them.";
    [self.dataSource addSection:self.managers];

    JSMStaticRow *bob = [JSMStaticRow new];
    bob.text = @"Bob";
    bob.detailText = @"Janitorial";
    bob.style = UITableViewCellStyleDefault;
    [self.managers addRow:bob];

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

    // Customers
    self.customers = [JSMStaticSection new];
    self.customers.headerText = @"Customers";
    self.customers.footerText = @"The customer is almost never right.";
    [self.dataSource addSection:self.customers];

    JSMStaticRow *joe = [JSMStaticRow new];
    joe.text = @"Joe";
    [joe configurationForCell:^(JSMStaticRow *row, UITableViewCell *cell) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }];
    [self.customers addRow:joe];

    JSMStaticRow *michelle = [JSMStaticRow new];
    michelle.text = @"Michelle";
    [michelle configurationForCell:^(JSMStaticRow *row, UITableViewCell *cell) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }];
    [self.customers addRow:michelle];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Fetch the row that was selected
    JSMStaticRow *row = [self.dataSource rowAtIndexPath:indexPath];
    // Reset Preferences
    if( [row.text isEqual:@"Reset All Preferences"] ) {
        for( NSUInteger i = 0; i<self.preferences.rows.count; i++ ) {
            JSMStaticRow *row = [self.preferences rowAtIndex:i];
            if( [row isKindOfClass:[JSMStaticPreference class]] ) {
                [[(JSMStaticPreference *)row control] resignFirstResponder];
                [(JSMStaticPreference *)row setValue:nil];
            }
        }
    }
    else if ( [row isKindOfClass:[JSMStaticSelectPreference class]] ) {
        JSMStaticSelectPreference *select = (JSMStaticSelectPreference *)row;
        [self.navigationController pushViewController:select.viewController animated:YES];
    }
    // Here's where we'll be moving people
    JSMStaticSection *newSection;
    if( [row.section isEqual:self.employees] ) {
        newSection = self.managers;
    }
    else if( [row.section isEqual:self.managers] ) {
        newSection = self.employees;
    }
    // Perform the updates
    if( newSection != nil ) {
        if( ! [newSection.dataSource isEqual:self.dataSource] ) {
            [self.tableView performUpdates:^{
                [self.tableView addSection:newSection withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
            indexPath = [self.dataSource indexPathForRow:row];
        }
        [self.tableView performUpdates:^{
            [self.tableView addRow:row toSection:newSection withRowAnimation:UITableViewRowAnimationFade];
        } withCompletion:^{
            if( newSection == self.managers ) {
                row.style = UITableViewCellStyleDefault;
            }
            else {
                row.style = UITableViewCellStyleSubtitle;
            }
        }];
        [self.tableView performUpdates:^{
            if( self.managers.numberOfRows == 0 ) {
                [self.tableView removeSection:self.managers withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            if( self.employees.numberOfRows == 0 ) {
                [self.tableView removeSection:self.employees withRowAnimation:UITableViewRowAnimationAutomatic];
            }
       }];
   }
}

#pragma mark - Static data source delegate

- (NSArray *)dataSource:(JSMStaticDataSource *)viewController sectionsDidChange:(NSArray *)sections {
    NSArray *sectionOrder = @[ @"Preferences", @"Managers", @"Employees", @"Customers" ];
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

- (NSArray *)section:(JSMStaticSection *)section rowsDidChange:(NSArray *)rows {
    return [rows sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[(JSMStaticRow *)obj1 text] compare:[(JSMStaticRow *)obj2 text]];
    }];
}

@end
