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

#import "JSMStaticDataSource.h"
#import "JSMStaticSection.h"
#import "JSMStaticRow.h"

@interface JSMStaticDataSource ()

@property (nonatomic, strong) NSMutableArray *mutableSections;

@end

@interface JSMStaticSection (JSMStaticDataSource)

- (void)setDataSource:dataSource;

- (void)setDirty:(BOOL)dirty;

@end

@interface JSMStaticRow (JSMStaticDataSource)

- (void)prepareCell:(UITableViewCell *)cell;

@end

@implementation JSMStaticDataSource

@synthesize mutableSections = _mutableSections;

- (id)init {
    if( ( self = [super init] ) ) {
        _cellClass = self.class.cellClass;
        _mutableSections = [NSMutableArray array];
    }
    return self;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@",self.class];
    if( self.mutableSections.count > 0 ) {
        [description appendFormat:@" (\n\t%@\n)",[[[self.mutableSections valueForKeyPath:@"description"] componentsJoinedByString:@",\n"] stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"]];
    }
    [description appendString:@">"];
    return description;
}

#pragma mark - Creating Table View Cells

static Class _staticCellClass = nil;

+ (Class)cellClass {
    if( _staticCellClass == nil ) {
        return [UITableViewCell class];
    }
    return _staticCellClass;
}

+ (void)setCellClass:(Class)cellClass {
    _staticCellClass = cellClass;
}

#pragma mark - Accessing sections

- (NSArray *)sections {
	return self.mutableSections.copy;
}

- (NSUInteger)numberOfSections {
	return self.mutableSections.count;
}

- (JSMStaticSection *)sectionWithKey:(id)key {
	return [[self.mutableSections filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"key = %@",key]] firstObject];
}

- (JSMStaticSection *)sectionAtIndex:(NSUInteger)index {
	if( index == NSNotFound || index >= self.mutableSections.count ) {
		return nil;
	}

	return (JSMStaticSection *)self.mutableSections[index];
}

- (NSUInteger)indexForSection:(JSMStaticSection *)section {
	return [self.mutableSections indexOfObject:section];
}

- (BOOL)containsSection:(JSMStaticSection *)section {
	return [self.mutableSections containsObject:section];
}

#pragma mark - Mutating sections

- (void)setSections:(NSArray *)sections {
	if( self.mutableSections.count > 0 ) {
		[self.mutableSections makeObjectsPerformSelector:@selector(setDataSource:) withObject:nil];
		[self.mutableSections removeAllObjects];
	}
	
	for( JSMStaticSection *section in sections ) {
		if( section.dataSource != nil ) {
			[section.dataSource removeSection:section];
		}
		
		section.dataSource = self;
		
		[self.mutableSections addObject:section];
	}
	
	[self sectionsDidChange];
}

- (JSMStaticSection *)createSection {
    JSMStaticSection *section = [JSMStaticSection section];
    [self addSection:section];
    return section;
}

- (JSMStaticSection *)createSectionAtIndex:(NSUInteger)index {
	NSAssert(index != NSNotFound, @"You cannot create a section at NSNotFound.");
	
    JSMStaticSection *section = [JSMStaticSection section];
    [self insertSection:section atIndex:index];
    return section;
}

- (void)addSection:(JSMStaticSection *)section {
	NSUInteger index = self.mutableSections.count;
	
	[self insertSection:section atIndex:index];
}

- (void)insertSection:(JSMStaticSection *)section atIndex:(NSUInteger)index {
	NSAssert(index != NSNotFound, @"You cannot insert a section at NSNotFound.");
	
	// Remove from the existing data source
	if( section.dataSource == self ) {
		NSUInteger oldIndex = [self.mutableSections indexOfObject:section];
		
		if( index == oldIndex || index == oldIndex + 1 ) {
			return;
		}
		else if( index > oldIndex ) {
			index -= 1; // Adjust to account for the section's removal.
		}
		
		[self.mutableSections removeObjectAtIndex:oldIndex];
	}
	else if( section.dataSource != nil ) {
		[section.dataSource removeSection:section];
	}
	
	// Add to the receiver
	section.dataSource = self;
    if( index >= self.mutableSections.count ) {
        [self.mutableSections addObject:section];
    }
    else {
        [self.mutableSections insertObject:section atIndex:index];
    }
	
	[self sectionsDidChange];
}

- (void)removeSectionAtIndex:(NSUInteger)index {
	NSAssert(index != NSNotFound, @"You cannot remove a section at NSNotFound.");
	
	JSMStaticSection *section = [self.mutableSections objectAtIndex:index];
	
	if( section == nil ) {
		return;
	}
	
	[self removeSection:section atIndex:index];
}

- (void)removeSection:(JSMStaticSection *)section {
	NSUInteger index = [self.mutableSections indexOfObject:section];
	
	if( index == NSNotFound ) {
		return;
	}
	
	[self removeSection:section atIndex:index];
}

- (void)removeSection:(JSMStaticSection *)section atIndex:(NSUInteger)index {
	NSAssert(index != NSNotFound, @"You cannot remove a section at NSNotFound.");
	
	section.dataSource = nil;
	[self.mutableSections removeObjectAtIndex:index];
	
	[self sectionsDidChange];
}

- (void)removeAllSections {
    if( self.mutableSections.count == 0 ) {
        return;
    }

	[self.mutableSections makeObjectsPerformSelector:@selector(setDataSource:) withObject:nil];
	[self.mutableSections removeAllObjects];

	[self sectionsDidChange];
}

- (void)sectionsDidChange {
	if( self.delegate != nil && [self.delegate respondsToSelector:@selector(dataSource:sectionsDidChange:)] ) {
		_mutableSections = [[self.delegate dataSource:self sectionsDidChange:_mutableSections.copy] mutableCopy];
	}
}

#pragma mark - Accessing rows

- (JSMStaticRow *)rowWithKey:(id)key {
	__block JSMStaticRow *foundRow;
	
	[self.mutableSections enumerateObjectsUsingBlock:^(JSMStaticSection *section, NSUInteger idx, BOOL *stop) {
		JSMStaticRow *row = [section rowWithKey:key];
		if( row != nil ) {
			foundRow = row;
			*stop = YES;
		}
	}];
	
	return foundRow;
}

- (JSMStaticRow *)rowAtIndexPath:(NSIndexPath *)indexPath {
	JSMStaticSection *section = [self sectionAtIndex:(NSUInteger)indexPath.section];
	if( section == nil ) {
		return nil;
	}
	return [section rowAtIndex:(NSUInteger)indexPath.row];
}

- (NSIndexPath *)indexPathForRow:(JSMStaticRow *)row {
	JSMStaticSection *section = row.section;
	if( section == nil ) {
		return nil;
	}
	NSInteger sectionIndex = (NSInteger)[self indexForSection:section];
	NSInteger rowIndex = (NSInteger)[section indexForRow:row];
	if( rowIndex == NSNotFound || rowIndex < 0 ) {
		return nil;
	}
	return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
}

#pragma mark - Mutating Rows

- (JSMStaticRow *)createRowAtIndexPath:(NSIndexPath *)indexPath {
    JSMStaticSection *section = [self sectionAtIndex:(NSUInteger)indexPath.section];
    if( section == nil ) {
        return nil;
    }
    return [section createRowAtIndex:(NSUInteger)indexPath.row];
}

- (void)insertRow:(JSMStaticRow *)row atIndexPath:(NSIndexPath *)indexPath {
    JSMStaticSection *section = [self sectionAtIndex:(NSUInteger)indexPath.section];
    if( section == nil ) {
        return;
    }
    [section insertRow:row atIndex:(NSUInteger)indexPath.row];
}

- (void)removeRowAtIndexPath:(NSIndexPath *)indexPath {
    JSMStaticSection *section = [self sectionAtIndex:(NSUInteger)indexPath.section];
    if( section == nil ) {
        return;
    }
    return [section removeRowAtIndex:(NSUInteger)indexPath.row];
}

- (void)removeRow:(JSMStaticRow *)row {
    NSIndexPath *indexPath = [self indexPathForRow:row];
    if( indexPath == nil ) {
        return;
    }
    [self removeRowAtIndexPath:indexPath];
}

#pragma mark - Refreshing the Contents

- (void)requestReloadForSection:(JSMStaticSection *)section {
	NSUInteger index = [self indexForSection:section];
	if( index == NSNotFound && _tableView.numberOfSections > (NSInteger)index ) {
		return;
	}

	if( self.delegate != nil && [self.delegate respondsToSelector:@selector(dataSource:sectionNeedsReload:atIndex:)] ) {
        [self.delegate dataSource:self sectionNeedsReload:section atIndex:[self indexForSection:section]];
    }
}

- (void)requestReloadForRow:(JSMStaticRow *)row {
	NSIndexPath *indexPath = [self indexPathForRow:row];
    if( indexPath == nil ) {
        return;
    }

	// If there's no cell, reloading can just happen when the cell comes into view.
	if( [_tableView cellForRowAtIndexPath:indexPath] == nil ) {
		return;
	}

	if( self.delegate != nil && [self.delegate respondsToSelector:@selector(dataSource:rowNeedsReload:atIndexPath:)] ) {
        [self.delegate dataSource:self rowNeedsReload:row atIndexPath:indexPath];
    }
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Store a link to the table view
    _tableView = tableView;

    // Return the number of sections
    return self.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JSMStaticSection *sectionObject = [self sectionAtIndex:(NSUInteger)section];
    [sectionObject setDirty:NO];
    return sectionObject.numberOfRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self sectionAtIndex:(NSUInteger)section] headerText];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [[self sectionAtIndex:(NSUInteger)section] footerText];
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellForRow:(JSMStaticRow *)row {
    UITableViewCell *cell;
	Class cellClass;
	// Get the cell class
	if( row.cellClass != nil ) {
		cellClass = row.cellClass;
	}
	else {
		cellClass = self.cellClass;
	}
	// Get the cell style
	switch( row.style ) {
        case UITableViewCellStyleDefault: {
			NSString *reuseIdentifier = [NSString stringWithFormat:@"JSMStaticDataSourceDefaultReuseIdentifier.%@", cellClass];
            if( ( cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier] ) == nil ) {
                cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            }
            break;
        }
        case UITableViewCellStyleValue1:
        default: {
            NSString *reuseIdentifier = [NSString stringWithFormat:@"JSMStaticDataSourceValue1ReuseIdentifier.%@", cellClass];
            if( ( cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier] ) == nil ) {
                cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
            }
            break;
        }
        case UITableViewCellStyleValue2: {
            NSString *reuseIdentifier = [NSString stringWithFormat:@"JSMStaticDataSourceValue2ReuseIdentifier.%@", cellClass];
            if( ( cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier] ) == nil ) {
                cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
            }
            break;
        }
        case UITableViewCellStyleSubtitle: {
            NSString *reuseIdentifier = [NSString stringWithFormat:@"JSMStaticDataSourceSubtitleReuseIdentifier.%@", cellClass];
            if( ( cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier] ) == nil ) {
                cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
            }
            break;
        }
    }
    // Return the cell
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Get the row for this particular index path
	JSMStaticRow *row = [self rowAtIndexPath:indexPath];
	// Get a cell
	UITableViewCell *cell = [self tableView:tableView dequeueReusableCellForRow:row];
	// Remove invalid subviews
	if (row.cellClass == nil) {
		for(UIView *subview in cell.contentView.subviews) {
			if( [subview isEqual:cell.textLabel] ) continue;
			if( [subview isEqual:cell.detailTextLabel] ) continue;
			if( [subview isEqual:cell.imageView] ) continue;
			[subview removeFromSuperview];
		}
	}
	// Configure the cell using the row's configuration block
	[row prepareCell:cell];
	// Return the cell
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self rowAtIndexPath:indexPath] canBeMoved];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // Move the row
    JSMStaticRow *row = [self rowAtIndexPath:sourceIndexPath];
    [self insertRow:row atIndexPath:destinationIndexPath];
    // All we do now is notify the delegate
    if( self.delegate != nil && [self.delegate respondsToSelector:@selector(dataSource:didMoveRow:fromIndexPath:toIndexPath:)] ) {
        [self.delegate dataSource:self didMoveRow:row fromIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
    // And the section delegates as well
    JSMStaticSection *sourceSection = [self sectionAtIndex:sourceIndexPath.section];
    if( sourceSection.delegate != nil && [sourceSection.delegate respondsToSelector:@selector(section:didMoveRow:fromIndexPath:toIndexPath:)] ) {
        [sourceSection.delegate section:sourceSection didMoveRow:row fromIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
    if( sourceIndexPath.section != destinationIndexPath.section ) {
        JSMStaticSection *destinationSection = [self sectionAtIndex:destinationIndexPath.section];
        if( destinationSection.delegate != nil && [destinationSection.delegate respondsToSelector:@selector(section:didMoveRow:fromIndexPath:toIndexPath:)] ) {
            [destinationSection.delegate section:destinationSection didMoveRow:row fromIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	JSMStaticRow *row = [self rowAtIndexPath:indexPath];
	return row.canBeDeleted || row.editingStyle != UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	JSMStaticRow *row = [self rowAtIndexPath:indexPath];

	// Allow the delegate a chance to deal with this
	if( self.delegate != nil && [self.delegate respondsToSelector:@selector(dataSource:commitEditingStyle:forRow:atIndexPath:)] ) {
		[self.delegate dataSource:self commitEditingStyle:editingStyle forRow:row atIndexPath:indexPath];
	}

	// Handle delete
	else if( editingStyle == UITableViewCellEditingStyleDelete ) {
        [self removeRow:row];

		// All we do now is notify the delegate
        if( self.delegate != nil && [self.delegate respondsToSelector:@selector(dataSource:didDeleteRow:fromIndexPath:)] ) {
            [self.delegate dataSource:self didDeleteRow:row fromIndexPath:indexPath];
        }
        else {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }

		// And the section delegate as well
        JSMStaticSection *section = [self sectionAtIndex:indexPath.section];
        if( section.delegate != nil && [section.delegate respondsToSelector:@selector(section:didDeleteRow:fromIndexPath:)] ) {
            [section.delegate section:section didDeleteRow:row fromIndexPath:indexPath];
        }
    }
}

@end
