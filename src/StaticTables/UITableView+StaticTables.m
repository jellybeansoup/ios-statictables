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

#import "UITableView+StaticTables.h"
#import "JSMStaticDataSource.h"
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

#pragma mark - Managing the Sections

- (JSMStaticSection *)createSectionWithRowAnimation:(UITableViewRowAnimation)animation {
    // Throw an exception if we don't have the right data source
    if( ! [self.dataSource isKindOfClass:[JSMStaticDataSource class]] ) {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }

    JSMStaticSection *section = [(JSMStaticDataSource *)self.dataSource createSection];
    NSUInteger sectionIndex = [(JSMStaticDataSource *)self.dataSource indexForSection:section];
    [self insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:animation];
    return section;
}

- (JSMStaticSection *)createSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation {
    // Throw an exception if we don't have the right data source
    if( ! [self.dataSource isKindOfClass:[JSMStaticDataSource class]] ) {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }

    JSMStaticSection *section = [(JSMStaticDataSource *)self.dataSource createSectionAtIndex:index];
    NSUInteger sectionIndex = [(JSMStaticDataSource *)self.dataSource indexForSection:section];
    [self insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:animation];
    return section;
}

- (void)addSection:(JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation {
    // Throw an exception if we don't have the right data source
    if( ! [self.dataSource isKindOfClass:[JSMStaticDataSource class]] ) {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }

    [(JSMStaticDataSource *)self.dataSource addSection:section];
    NSUInteger sectionIndex = [(JSMStaticDataSource *)self.dataSource indexForSection:section];
    [self insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:animation];
}

- (void)insertSection:(JSMStaticSection *)section atIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation {
    // Throw an exception if we don't have the right data source
    if( ! [self.dataSource isKindOfClass:[JSMStaticDataSource class]] ) {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }

    [(JSMStaticDataSource *)self.dataSource insertSection:section atIndex:index];
    NSUInteger sectionIndex = [(JSMStaticDataSource *)self.dataSource indexForSection:section];
    [self insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:animation];
}

- (JSMStaticSection *)sectionAtIndex:(NSUInteger)index {
    // Throw an exception if we don't have the right data source
    if( ! [self.dataSource isKindOfClass:[JSMStaticDataSource class]] ) {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }

    return [(JSMStaticDataSource *)self.dataSource sectionAtIndex:index];
}

- (NSUInteger)indexForSection:(JSMStaticSection *)section {
    // Throw an exception if we don't have the right data source
    if( ! [self.dataSource isKindOfClass:[JSMStaticDataSource class]] ) {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }

    return [(JSMStaticDataSource *)self.dataSource indexForSection:section];
}

- (BOOL)containsSection:(JSMStaticSection *)section {
    // Throw an exception if we don't have the right data source
    if( ! [self.dataSource isKindOfClass:[JSMStaticDataSource class]] ) {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }

    return [(JSMStaticDataSource *)self.dataSource containsSection:section];
}

- (void)reloadSection:(JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation {
    // Throw an exception if we don't have the right data source
    if( ! [self.dataSource isKindOfClass:[JSMStaticDataSource class]] ) {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }

    NSUInteger sectionIndex = [(JSMStaticDataSource *)self.dataSource indexForSection:section];
    [self reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:animation];
}

- (void)removeSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation {
    // Throw an exception if we don't have the right data source
    if( ! [self.dataSource isKindOfClass:[JSMStaticDataSource class]] ) {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }

    [(JSMStaticDataSource *)self.dataSource removeSectionAtIndex:index];
    [self deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:animation];
}

- (void)removeSection:(JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation {
    // Throw an exception if we don't have the right data source
    if( ! [self.dataSource isKindOfClass:[JSMStaticDataSource class]] ) {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }

    NSUInteger sectionIndex = [(JSMStaticDataSource *)self.dataSource indexForSection:section];
    [(JSMStaticDataSource *)self.dataSource removeSection:section];
    [self deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:animation];
}

#pragma mark - Managing the Rows

- (JSMStaticRow *)createRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    // Throw an exception if we don't have the right data source
    if( ! [self.dataSource isKindOfClass:[JSMStaticDataSource class]] ) {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }

    JSMStaticRow *row = [(JSMStaticDataSource *)self.dataSource createRowAtIndexPath:indexPath];
    [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
    return row;
}

- (void)insertRow:(JSMStaticRow *)row atIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    // Throw an exception if we don't have the right data source
    if( ! [self.dataSource isKindOfClass:[JSMStaticDataSource class]] ) {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }

    // Move within the data source and determine the index paths
    NSIndexPath *fromIndexPath = [(JSMStaticDataSource *)self.dataSource indexPathForRow:row];
    [(JSMStaticDataSource *)self.dataSource insertRow:row atIndexPath:indexPath];

    // Run the animation
    [self animateRowToIndexPath:indexPath fromIndexPath:fromIndexPath withRowAnimation:animation];
}

- (void)addRow:(JSMStaticRow *)row toSection:(JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation {
    // Throw an exception if we don't have the right data source
    if( ! [self.dataSource isKindOfClass:[JSMStaticDataSource class]] ) {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }

    // Move within the data source and determine the index paths
    NSIndexPath *fromIndexPath = [(JSMStaticDataSource *)self.dataSource indexPathForRow:row];
    [section addRow:row];
    NSIndexPath *toIndexPath = [(JSMStaticDataSource *)self.dataSource indexPathForRow:row];

    // Run the animation
    [self animateRowToIndexPath:toIndexPath fromIndexPath:fromIndexPath withRowAnimation:animation];
}

- (void)insertRow:(JSMStaticRow *)row intoSection:(JSMStaticSection *)section atIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation {
    // Throw an exception if we don't have the right data source
    if( ! [self.dataSource isKindOfClass:[JSMStaticDataSource class]] ) {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }

    // Move within the data source and determine the index paths
    NSIndexPath *fromIndexPath = [(JSMStaticDataSource *)self.dataSource indexPathForRow:row];
    [section insertRow:row atIndex:index];
    NSIndexPath *toIndexPath = [(JSMStaticDataSource *)self.dataSource indexPathForRow:row];

    // Run the animation
    [self animateRowToIndexPath:toIndexPath fromIndexPath:fromIndexPath withRowAnimation:animation];
}

- (void)animateRowToIndexPath:(NSIndexPath *)toIndexPath fromIndexPath:(NSIndexPath *)fromIndexPath withRowAnimation:(UITableViewRowAnimation)animation {
    if( toIndexPath != nil && fromIndexPath != nil ) {
        [self moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
    }
    else if( toIndexPath != nil && fromIndexPath == nil ) {
        [self insertRowsAtIndexPaths:@[toIndexPath] withRowAnimation:animation];
    }
    else if( toIndexPath == nil && fromIndexPath != nil ) {
        // The idea here is if we're copying from one data source to the other, I guess?
        [self deleteRowsAtIndexPaths:@[fromIndexPath] withRowAnimation:animation];
    }
    else {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }
}

- (JSMStaticRow *)rowAtIndexPath:(NSIndexPath *)indexPath {
    // Throw an exception if we don't have the right data source
    if( ! [self.dataSource isKindOfClass:[JSMStaticDataSource class]] ) {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }

    return [(JSMStaticDataSource *)self.dataSource rowAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForRow:(JSMStaticRow *)row {
    // Throw an exception if we don't have the right data source
    if( ! [self.dataSource isKindOfClass:[JSMStaticDataSource class]] ) {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }

    return [(JSMStaticDataSource *)self.dataSource indexPathForRow:row];
}

- (void)reloadRow:(JSMStaticRow *)row withRowAnimation:(UITableViewRowAnimation)animation {
    // Throw an exception if we don't have the right data source
    if( ! [self.dataSource isKindOfClass:[JSMStaticDataSource class]] ) {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }

    NSIndexPath *indexPath = [(JSMStaticDataSource *)self.dataSource indexPathForRow:row];
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)removeRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    // Throw an exception if we don't have the right data source
    if( ! [self.dataSource isKindOfClass:[JSMStaticDataSource class]] ) {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }

    [(JSMStaticDataSource *)self.dataSource removeRowAtIndexPath:indexPath];
    [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)removeRow:(JSMStaticRow *)row withRowAnimation:(UITableViewRowAnimation)animation {
    // Throw an exception if we don't have the right data source
    if( ! [self.dataSource isKindOfClass:[JSMStaticDataSource class]] ) {
        [NSException raise:@"Invalid Data Source" format:@"Table view data source must be an instance of JSMStaticDataSource to use %s",__FUNCTION__];
    }

    NSIndexPath *indexPath = [(JSMStaticDataSource *)self.dataSource indexPathForRow:row];
    [(JSMStaticDataSource *)self.dataSource removeRow:row];
    [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

@end
