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

#import "JSMStaticViewController.h"
#import "JSMPreferenceViewController.h"
#import "JSMBooleanPreference.h"

@interface JSMStaticViewController ()

@property (nonatomic, strong) NSArray *sections;

@end

@implementation JSMStaticViewController

#pragma mark - Instance creation

+ (instancetype)new {
    return (JSMStaticViewController *)[[self alloc] initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - View life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Clear the sections data
    _sections = nil;
    // Refresh the tableview
    [self.tableView reloadData];
}

#pragma mark - Static sections

- (NSArray *)sections {
    return nil;
}

- (NSArray *)cachedSections {
    // Fetch the section definitions if we need them
    NSArray *sections;
    if( _sections == nil && ( sections = [self sections] ) != nil ) {
        _sections = sections;
    }
    // Return the section definitions
    return _sections;
}

- (JSMStaticViewSection *)sectionForIndex:(NSInteger)section {
    // Find the section
    NSArray *sections;
    if( ( sections = [self cachedSections] ) != nil && sections.count > section ) {
        return (JSMStaticViewSection *)[[self cachedSections] objectAtIndex:section];
    }
    // Default to nil
    return nil;
}

- (JSMStaticViewSection *)sectionForKey:(NSString *)key {
    // Find the section
    for( JSMStaticViewSection *section in [self cachedSections] ) {
        if( [section.key isEqual:key] ) {
            return section;
        }
    }
    // Default to nil
    return nil;
}

- (NSString *)sectionKeyForIndex:(NSInteger)section {
    return [[self sectionForIndex:section] key];
}

- (NSInteger)sectionIndexForKey:(NSString *)key {
    // Find the section
    NSArray *sections = [self cachedSections];
    for( NSInteger i = 0; i<sections.count; i++ ) {
        if( [[(JSMStaticViewSection *)sections[i] key] isEqual:key] ) {
            return i;
        }
    }
    // Default to nil
    return -1;
}

- (void)refreshSections {
    _sections = nil;
    [self cachedSections];
}

- (void)reloadTableView {
    [self refreshSections];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Static sections
    NSArray *sections;
    if( ( sections = [self cachedSections] ) != nil ) {
        return sections.count;
    }
    // Default
	return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Static sections
    NSArray *sections;
    if( ( sections = [self cachedSections] ) != nil ) {
        return [(JSMStaticViewSection *)[sections objectAtIndex:section] rows];
    }
    // Default
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // Static sections
    NSArray *sections;
    if( ( sections = [self cachedSections] ) != nil ) {
        return [(JSMStaticViewSection *)[sections objectAtIndex:section] headerText];
    }
	// Default
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    // Static sections
    NSArray *sections;
    if( ( sections = [self cachedSections] ) != nil ) {
        return [(JSMStaticViewSection *)[sections objectAtIndex:section] footerText];
    }
	// Default
	return nil;
}

- (UITableViewCellStyle)tableView:(UITableView *)tableView cellStyleAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellStyleValue1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSMStaticViewCell *cell;
	// Preference cell configuration
    UITableViewCellStyle cellStyle = [self tableView:tableView cellStyleAtIndexPath:indexPath];
    if( cell.preference != nil ) {
        cellStyle = UITableViewCellStyleValue1;
	}
    // Get the cell style
    switch( cellStyle ) {

        case UITableViewCellStyleDefault: {
            static NSString *JSMPrefsDefaultReuseIdentifier = @"JSMPrefsDefaultReuseIdentifier";
            if( ( cell = (JSMStaticViewCell *)[tableView dequeueReusableCellWithIdentifier:JSMPrefsDefaultReuseIdentifier] ) == nil ) {
                cell = [[JSMStaticViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JSMPrefsDefaultReuseIdentifier];
            }
            break;
        }

        case UITableViewCellStyleValue1:
        default: {
            static NSString *JSMPrefsValue1ReuseIdentifier = @"JSMPrefsValue1ReuseIdentifier";
            if( ( cell = (JSMStaticViewCell *)[tableView dequeueReusableCellWithIdentifier:JSMPrefsValue1ReuseIdentifier] ) == nil ) {
                cell = [[JSMStaticViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:JSMPrefsValue1ReuseIdentifier];
            }
            break;
        }

        case UITableViewCellStyleValue2: {
            static NSString *JSMPrefsValue2ReuseIdentifier = @"JSMPrefsValue2ReuseIdentifier";
            if( ( cell = (JSMStaticViewCell *)[tableView dequeueReusableCellWithIdentifier:JSMPrefsValue2ReuseIdentifier] ) == nil ) {
                cell = [[JSMStaticViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:JSMPrefsValue2ReuseIdentifier];
            }
            break;
        }

        case UITableViewCellStyleSubtitle: {
            static NSString *JSMPrefsSubtitleReuseIdentifier = @"JSMPrefsSubtitleReuseIdentifier";
            if( ( cell = (JSMStaticViewCell *)[tableView dequeueReusableCellWithIdentifier:JSMPrefsSubtitleReuseIdentifier] ) == nil ) {
                cell = [[JSMStaticViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:JSMPrefsSubtitleReuseIdentifier];
            }
            break;
        }

    }
    // Reset the accessory view and the preference
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    cell.preference = nil;
    // Cell background color
    if( self.cellBackgroundColor ) {
        cell.backgroundColor = self.cellBackgroundColor;
    }
    if( self.cellSelectedBackgroundColor ) {
        cell.selectedBackgroundColor = self.cellSelectedBackgroundColor;
    }
    // Custom cell configuration
    cell = [self configureCell:(JSMStaticViewCell *)cell atIndexPath:indexPath];
	// Preference View Controller
    if( cell.preference != nil ) {
        // Boolean preference
        if( [cell.preference.class isEqual:[JSMBooleanPreference class]] ) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell displaySwitchWithValue:[(JSMBooleanPreference *)cell.preference boolValue]];
		}
        // Text preference
        else if( cell.preference.options.count <= 0 ) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell displayTextFieldWithValue:[(JSMBooleanPreference *)cell.preference value]];
		}
        // Selection Preference
        else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.detailTextLabel.text = cell.preference.selectedOption.label;
        }
	}
    // Return the cell
	return (UITableViewCell *)cell;
}

- (JSMStaticViewCell *)configureCell:(JSMStaticViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JSMStaticViewCell *cell = (JSMStaticViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	// Preference View Controller
    if( cell.preference != nil ) {
        // Boolean preference
        if( [cell.preference.class isEqual:[JSMBooleanPreference class]] ) {
            return;
		}
        // Text preference
        else if( cell.preference.options.count <= 0 ) {
            return;
        }
        // Selection Preference
        else {
            JSMPreferenceViewController *viewController = [JSMPreferenceViewController instanceWithPreference:cell.preference];
            viewController.title = cell.textLabel.text;
            viewController.backgroundColor = self.backgroundColor;
            viewController.cellSeparatorColor = self.cellSeparatorColor;
            viewController.cellBackgroundColor = self.cellBackgroundColor;
            viewController.cellSelectedBackgroundColor = self.cellSelectedBackgroundColor;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        return;
	}
    // Let subclasses have a go
    if( cell != nil ) {
        [self tableView:tableView cell:cell wasSelectedAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView cell:(JSMStaticViewCell *)cell wasSelectedAtIndexPath:(NSIndexPath *)indexPath {
    return;
}

#pragma mark - Appearance

- (UIColor *)backgroundColor {
    return self.tableView.backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.tableView.backgroundColor = backgroundColor;
}

- (UIColor *)cellSeparatorColor {
    return self.tableView.separatorColor;
}

- (void)setCellSeparatorColor:(UIColor *)cellSeparatorColor {
    self.tableView.separatorColor = cellSeparatorColor;
}

@end
