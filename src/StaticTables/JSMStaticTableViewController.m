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

#import "JSMStaticTableViewController.h"
#import "JSMStaticSection.h"

@interface JSMStaticTableViewController ()

@end

@implementation JSMStaticTableViewController

#pragma mark - Creating a Table View Controller

+ (instancetype)grouped {
    return [[self alloc] initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Override the initial data source
    self.tableView.dataSource = self.dataSource;
}

#pragma mark - Data Source

@synthesize dataSource = _dataSource;

- (JSMStaticDataSource *)dataSource {
    if( _dataSource == nil ) {
        _dataSource = [JSMStaticDataSource new];
        _dataSource.delegate = self;
    }
    return _dataSource;
}

#pragma mark - Static data source delegate

- (void)dataSource:(JSMStaticDataSource *)dataSource sectionNeedsReload:(JSMStaticSection *)section atIndex:(NSUInteger)index {
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)dataSource:(JSMStaticDataSource *)dataSource rowNeedsReload:(JSMStaticRow *)row atIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

#pragma mark - Animating the Sections

- (JSMStaticSection *)createSectionWithRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    return [self.dataSource createSectionWithRowAnimation:animation];
}

- (JSMStaticSection *)createSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    return [self.dataSource createSectionAtIndex:index withRowAnimation:animation];
}

- (void)addSection:(JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    [self.dataSource addSection:section withRowAnimation:animation];
}

- (void)insertSection:(JSMStaticSection *)section atIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    [self.dataSource insertSection:section atIndex:index withRowAnimation:animation];
}

- (void)reloadSection:(JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    [self.dataSource reloadSection:section withRowAnimation:animation];
}

- (void)removeSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    [self.dataSource removeSectionAtIndex:index withRowAnimation:animation];
}

- (void)removeSection:(JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    [self.dataSource removeSection:section withRowAnimation:animation];
}

#pragma mark - Animating the Rows

- (JSMStaticRow *)createRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    return [self.dataSource createRowAtIndexPath:indexPath withRowAnimation:animation];
}

- (void)insertRow:(__kindof JSMStaticRow *)row atIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    return [self.dataSource insertRow:row atIndexPath:indexPath withRowAnimation:animation];
}

- (void)addRow:(__kindof JSMStaticRow *)row toSection:(JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    [self.dataSource addRow:row toSection:section withRowAnimation:animation];
}

- (void)insertRow:(__kindof JSMStaticRow *)row intoSection:(JSMStaticSection *)section atIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    [self.dataSource insertRow:row intoSection:section atIndex:index withRowAnimation:animation];
}

- (void)reloadRow:(__kindof JSMStaticRow *)row withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    [self.dataSource reloadRow:row withRowAnimation:animation];
}

- (void)removeRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    [self.dataSource removeRowAtIndexPath:indexPath withRowAnimation:animation];
}

- (void)removeRow:(__kindof JSMStaticRow *)row withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    [self.dataSource removeRow:row withRowAnimation:animation];
}

#pragma mark - Utilities

// Throw an exception if we don't have the right data source
- (void)validateDataSource {
    if( ! [self.dataSource isKindOfClass:[JSMStaticDataSource class]] ) {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }
}

@end
