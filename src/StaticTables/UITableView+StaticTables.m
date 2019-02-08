//
// Copyright © 2019 Daniel Farrelly
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

#import "UITableView+StaticTables.h"
#import "JSMStaticDataSource.h"
#import "JSMStaticDataSource+Convenience.h"
#import "JSMStaticSection.h"
#import "JSMStaticRow.h"

@implementation UITableView (StaticTables)

#pragma mark - Preparing for Updates

- (void)performUpdates:(JSMTableViewUpdatesBlock)updates {
    [self beginUpdates];
    if( updates ) {
        updates(self);
    }
    [self endUpdates];
}

- (void)performUpdates:(JSMTableViewUpdatesBlock)updates withCompletion:(JSMTableViewUpdatesCompletion)completion {
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    [self performUpdates:updates];
    [CATransaction commit];
}

#pragma mark - Animating the Sections

- (JSMStaticSection *)createSectionWithRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    return [(JSMStaticDataSource *)self.dataSource createSectionWithRowAnimation:animation];
}

- (JSMStaticSection *)createSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    return [(JSMStaticDataSource *)self.dataSource createSectionAtIndex:index withRowAnimation:animation];
}

- (void)addSection:(JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    [(JSMStaticDataSource *)self.dataSource addSection:section withRowAnimation:animation];
}

- (void)insertSection:(JSMStaticSection *)section atIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    [(JSMStaticDataSource *)self.dataSource insertSection:section atIndex:index withRowAnimation:animation];
}

- (JSMStaticSection *)sectionAtIndex:(NSUInteger)index {
    [self validateDataSource];
    return [(JSMStaticDataSource *)self.dataSource sectionAtIndex:index];
}

- (NSUInteger)indexForSection:(JSMStaticSection *)section {
    [self validateDataSource];
    return [(JSMStaticDataSource *)self.dataSource indexForSection:section];
}

- (BOOL)containsSection:(JSMStaticSection *)section {
    [self validateDataSource];
    return [(JSMStaticDataSource *)self.dataSource containsSection:section];
}

- (void)reloadSection:(JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    [(JSMStaticDataSource *)self.dataSource reloadSection:section withRowAnimation:animation];
}

- (void)removeSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    [(JSMStaticDataSource *)self.dataSource removeSectionAtIndex:index withRowAnimation:animation];
}

- (void)removeSection:(JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    [(JSMStaticDataSource *)self.dataSource removeSection:section withRowAnimation:animation];
}

#pragma mark - Animating the Rows

- (JSMStaticRow *)createRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    return [(JSMStaticDataSource *)self.dataSource createRowAtIndexPath:indexPath withRowAnimation:animation];
}

- (void)insertRow:(JSMStaticRow *)row atIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    return [(JSMStaticDataSource *)self.dataSource insertRow:row atIndexPath:indexPath withRowAnimation:animation];
}

- (void)addRow:(JSMStaticRow *)row toSection:(JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    [(JSMStaticDataSource *)self.dataSource addRow:row toSection:section withRowAnimation:animation];
}

- (void)insertRow:(JSMStaticRow *)row intoSection:(JSMStaticSection *)section atIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    [(JSMStaticDataSource *)self.dataSource insertRow:row intoSection:section atIndex:index withRowAnimation:animation];
}

- (JSMStaticRow *)rowAtIndexPath:(NSIndexPath *)indexPath {
    [self validateDataSource];
    return [(JSMStaticDataSource *)self.dataSource rowAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForRow:(JSMStaticRow *)row {
    [self validateDataSource];
    return [(JSMStaticDataSource *)self.dataSource indexPathForRow:row];
}

- (void)reloadRow:(JSMStaticRow *)row withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    [(JSMStaticDataSource *)self.dataSource reloadRow:row withRowAnimation:animation];
}

- (void)removeRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    [(JSMStaticDataSource *)self.dataSource removeRowAtIndexPath:indexPath withRowAnimation:animation];
}

- (void)removeRow:(JSMStaticRow *)row withRowAnimation:(UITableViewRowAnimation)animation {
    [self validateDataSource];
    [(JSMStaticDataSource *)self.dataSource removeRow:row withRowAnimation:animation];
}

#pragma mark - Utilities

// Throw an exception if we don't have the right data source
- (void)validateDataSource {
    if( ! [self.dataSource isKindOfClass:[JSMStaticDataSource class]] ) {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }
}

@end
