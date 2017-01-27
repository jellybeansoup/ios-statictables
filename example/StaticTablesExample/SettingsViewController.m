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

#import "SettingsViewController.h"

@interface SettingsViewController () <JSMStaticPreferenceObserver>

@property (nonatomic, strong) NSArray *sections;

@end

@implementation SettingsViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    JSMStaticSection *section1 = [JSMStaticSection sectionWithKey:@"storedPreferences"];
    section1.footerText = @"Preferences like this text field can save their value to user defaults automatically by initialising them with a key.";

    JSMStaticTextPreference *twitterPreference = [JSMStaticTextPreference preferenceWithKey:@"com.jellystyle.staticTables.twitter"];
    twitterPreference.text = @"Twitter";
    twitterPreference.defaultValue = @"jellybeansoup";
    twitterPreference.textField.delegate = self;
    twitterPreference.textField.returnKeyType = UIReturnKeyDone;
    [section1 addRow:twitterPreference];

    JSMStaticSection *section2 = [JSMStaticSection sectionWithKey:@"transientPreferences"];
    section2.footerText = @"Alternatively, you can create a transient preference, the value for which will only be kept for as long as the preference is in memory.\n\nThis is useful for instances where you want to use the value for something now, but not keep it permanently: like an editing or login screen.";

    JSMStaticTextPreference *urlPreference = [JSMStaticTextPreference transientPreferenceWithKey:@"transientPreference"];
    urlPreference.text = @"URL";
    urlPreference.textField.keyboardType = UIKeyboardTypeURL;
    urlPreference.textField.delegate = self;
    urlPreference.textField.returnKeyType = UIReturnKeyDone;
    [section2 addRow:urlPreference];

    JSMStaticSection *section3 = [JSMStaticSection sectionWithKey:@"mutableSection"];
    section3.footerText = @"It's also possible to update your table view dynamically based on the value of a preference. Here we show a slider preference when the toggle is flipped on, and otherwise, we hide the preference completely.";

    JSMStaticBooleanPreference *showPreference = [JSMStaticBooleanPreference preferenceWithKey:@"com.jellystyle.staticTables.mutated"];
    showPreference.text = @"Show Slider";
    [showPreference addObserver:self];
    [section3 addRow:showPreference];

    JSMStaticSection *section4 = [JSMStaticSection sectionWithKey:@"allPreferences"];
    section4.footerText = @"Other kinds of preferences are equally easy to implement with the same features.";

    JSMStaticBooleanPreference *boolPreference = [JSMStaticBooleanPreference preferenceWithKey:@"com.jellystyle.staticTables.bool"];
    boolPreference.text = @"Boolean";
    boolPreference.toggle.onTintColor = [UIColor purpleColor];
    [section4 addRow:boolPreference];

    JSMStaticSelectPreference *selectPreference = [JSMStaticSelectPreference preferenceWithKey:@"com.jellystyle.staticTables.select"];
    selectPreference.text = @"Select";
    selectPreference.options = @[
                                 @{ JSMStaticSelectOptionValue: @"option1", JSMStaticSelectOptionLabel: @"Option 1", JSMStaticSelectOptionImage: @"1" },
                                 @{ JSMStaticSelectOptionValue: @"option2", JSMStaticSelectOptionLabel: @"Option 2", JSMStaticSelectOptionImage: @"2" },
                                 @{ JSMStaticSelectOptionValue: @"option3", JSMStaticSelectOptionLabel: @"Option 3", JSMStaticSelectOptionImage: @"3" },
                                 ];
    [section4 addRow:selectPreference];

    JSMStaticSection *section5 = [JSMStaticSection new];

    JSMStaticRow *reset = [JSMStaticRow new];
    reset.style = UITableViewCellStyleDefault;
    reset.text = @"Reset All Preferences";
    [reset configurationForCell:^(JSMStaticRow *row, UITableViewCell *cell) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithRed:0.6 green:0 blue:0 alpha:1];
    }];
    [section5 addRow:reset];

    // Save and load the sections
    self.sections = @[ section1, section2, section3, section4, section5 ];
    self.dataSource.sections = self.sections;

    // Set up our parts that can be added and removed.
    [self updateTableView];
}

- (void)updateTableView {

    JSMStaticSection *section = [self.dataSource sectionWithKey:@"mutableSection"];
    JSMStaticBooleanPreference *showPreference = (JSMStaticBooleanPreference *)[section rowWithKey:@"com.jellystyle.staticTables.mutated"];
    if( showPreference.boolValue ) {

        JSMStaticSliderPreference *sliderPreference = [JSMStaticSliderPreference preferenceWithKey:@"com.jellystyle.staticTables.slider"];
        sliderPreference.text = @"Slider";
        [self addRow:sliderPreference toSection:section withRowAnimation:UITableViewRowAnimationAutomatic];

    }
    else {

        JSMStaticSliderPreference *sliderPreference = (JSMStaticSliderPreference *)[section rowWithKey:@"com.jellystyle.staticTables.slider"];
        [self removeRow:sliderPreference withRowAnimation:UITableViewRowAnimationAutomatic];

    }

}

#pragma mark - Static preference observer

- (void)preference:(JSMStaticPreference *)preference didChangeValue:(id)value {
    [self updateTableView];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Fetch the row that was selected
    JSMStaticRow *row = [self.dataSource rowAtIndexPath:indexPath];
    // Reset all the preferences to their default values
    if( [row.text isEqualToString:@"Reset All Preferences"] ) {

        [self.view endEditing:YES];

        for( NSUInteger s = 0; s<self.dataSource.sections.count; s++ ) {
            JSMStaticSection *section = [self.dataSource sectionAtIndex:s];

            for( NSUInteger r = 0; r<section.rows.count; r++ ) {
                JSMStaticRow *row = [section rowAtIndex:r];

                if( [row isKindOfClass:[JSMStaticPreference class]] ) {
                    [(JSMStaticPreference *)row setValue:nil];
                }
            }

        }

    }
    // We'll need to display the view controller for select preferences to the user
    else if( [row isKindOfClass:[JSMStaticSelectPreference class]] ) {

        JSMStaticSelectPreference *select = (JSMStaticSelectPreference *)row;
        [self.navigationController pushViewController:select.viewController animated:YES];

    }
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return NO;
}

@end
