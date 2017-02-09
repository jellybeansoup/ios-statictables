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

#import "JSMStaticDataSource+Convenience.h"
#import "JSMStaticSection.h"
#import "JSMStaticRow.h"

@implementation JSMStaticDataSource (Convenience)

#pragma mark - Animating the Sections

- (JSMStaticSection *)createSectionWithRowAnimation:(UITableViewRowAnimation)animation {
    JSMStaticSection *section = [self createSection];
    NSUInteger sectionIndex = [self indexForSection:section];
	[self animateSectionToIndex:sectionIndex fromIndex:NSNotFound withRowAnimation:animation];
    return section;
}

- (JSMStaticSection *)createSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation {
    JSMStaticSection *section = [self createSectionAtIndex:index];
	[self animateSectionToIndex:index fromIndex:NSNotFound withRowAnimation:animation];
    return section;
}

- (void)addSection:(JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation {
    [self addSection:section];
    NSUInteger sectionIndex = [self indexForSection:section];
	[self animateSectionToIndex:sectionIndex fromIndex:NSNotFound withRowAnimation:animation];
}

- (void)insertSection:(JSMStaticSection *)section atIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation {
    [self insertSection:section atIndex:index];
    NSUInteger sectionIndex = [self indexForSection:section];
	[self animateSectionToIndex:sectionIndex fromIndex:NSNotFound withRowAnimation:animation];
}

- (void)reloadSection:(JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSUInteger sectionIndex = [self indexForSection:section];
	[self animateSectionToIndex:sectionIndex fromIndex:sectionIndex withRowAnimation:animation];
}

- (void)removeSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation {
    [self removeSectionAtIndex:index];
	[self animateSectionToIndex:NSNotFound fromIndex:index withRowAnimation:animation];
}

- (void)removeSection:(JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSUInteger sectionIndex = [self indexForSection:section];
    [self removeSection:section];
	[self animateSectionToIndex:NSNotFound fromIndex:sectionIndex withRowAnimation:animation];
}

#pragma mark - Animating the Rows

- (JSMStaticRow *)createRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    JSMStaticRow *row = [self createRowAtIndexPath:indexPath];
	[self animateRowToIndexPath:indexPath fromIndexPath:nil withRowAnimation:animation];
    return row;
}

- (void)insertRow:(JSMStaticRow *)row atIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *fromIndexPath = [self indexPathForRow:row];
    [self insertRow:row atIndexPath:indexPath];
    [self animateRowToIndexPath:indexPath fromIndexPath:fromIndexPath withRowAnimation:animation];
}

- (void)addRow:(JSMStaticRow *)row toSection:(JSMStaticSection *)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *fromIndexPath = [self indexPathForRow:row];
    [section addRow:row];
    NSIndexPath *toIndexPath = [self indexPathForRow:row];
    [self animateRowToIndexPath:toIndexPath fromIndexPath:fromIndexPath withRowAnimation:animation];
}

- (void)insertRow:(JSMStaticRow *)row intoSection:(JSMStaticSection *)section atIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *fromIndexPath = [self indexPathForRow:row];
    [section insertRow:row atIndex:index];
    NSIndexPath *toIndexPath = [self indexPathForRow:row];
    [self animateRowToIndexPath:toIndexPath fromIndexPath:fromIndexPath withRowAnimation:animation];
}

- (void)reloadRow:(JSMStaticRow *)row withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *indexPath = [self indexPathForRow:row];
	[self animateRowToIndexPath:indexPath fromIndexPath:indexPath withRowAnimation:animation];
}

- (void)removeRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    JSMStaticRow *row = [self rowAtIndexPath:indexPath];
	[self removeRow:row atIndexPath:indexPath withRowAnimation:animation];
}

- (void)removeRow:(JSMStaticRow *)row withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *indexPath = [self indexPathForRow:row];
	[self removeRow:row atIndexPath:indexPath withRowAnimation:animation];
}

- (void)removeRow:(JSMStaticRow *)row atIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
	if( row == nil || indexPath == nil ) {
		return;
	}

	[self removeRow:row];
	[self animateRowToIndexPath:nil fromIndexPath:indexPath withRowAnimation:animation];
}

#pragma mark - Performing the actual animations

- (void)animateSectionToIndex:(NSUInteger)toIndex fromIndex:(NSUInteger)fromIndex withRowAnimation:(UITableViewRowAnimation)animation {
	if( self.tableView == nil || (toIndex == NSNotFound && fromIndex == NSNotFound)) {
		return;
	}

	if( self.tableView.window == nil ) {
		[self.tableView reloadData];
	}
	else if( toIndex != NSNotFound && fromIndex != NSNotFound ) {
		if( toIndex == fromIndex ) {
			[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:fromIndex] withRowAnimation:animation];
		}
		else {
			[self.tableView moveSection:fromIndex toSection:toIndex];
		}
	}
	else if( toIndex != NSNotFound && fromIndex == NSNotFound ) {
		[self.tableView insertSections:[NSIndexSet indexSetWithIndex:toIndex] withRowAnimation:animation];
	}
	else if( toIndex == NSNotFound && fromIndex != NSNotFound ) {
		[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:fromIndex] withRowAnimation:animation];
	}
}

- (void)animateRowToIndexPath:(NSIndexPath *)toIndexPath fromIndexPath:(NSIndexPath *)fromIndexPath withRowAnimation:(UITableViewRowAnimation)animation {
	if( self.tableView == nil || (toIndexPath == nil && fromIndexPath == nil)) {
		return;
	}

	if( self.tableView.window == nil ) {
		[self.tableView reloadData];
	}
	else if( toIndexPath != nil && fromIndexPath != nil ) {
		if( [toIndexPath isEqual:fromIndexPath] ) {
			[self.tableView reloadRowsAtIndexPaths:@[fromIndexPath] withRowAnimation:animation];
		}
		else {
			[self.tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
		}
	}
	else if( toIndexPath != nil && fromIndexPath == nil ) {
		[self.tableView insertRowsAtIndexPaths:@[toIndexPath] withRowAnimation:animation];
	}
	else if( toIndexPath == nil && fromIndexPath != nil ) {
		[self.tableView deleteRowsAtIndexPaths:@[fromIndexPath] withRowAnimation:animation];
	}
}

@end
