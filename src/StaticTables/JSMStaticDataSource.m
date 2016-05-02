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

#pragma mark - Managing the Sections

- (NSArray *)sections {
    return self.mutableSections.copy;
}

- (void)setSections:(NSArray *)sections {
    _mutableSections = sections.mutableCopy;
    // Update the data source for all the added sections
    for( NSUInteger i=0; i<_mutableSections.count; i++ ) {
        [(JSMStaticSection *)_mutableSections[i] setDataSource:self];
    }
    // Notify the delegate
    if( self.delegate != nil && [self.delegate respondsToSelector:@selector(dataSource:sectionsDidChange:)] ) {
        _mutableSections = [[self.delegate dataSource:self sectionsDidChange:_mutableSections.copy] mutableCopy];
    }
}

- (NSUInteger)numberOfSections {
    return self.mutableSections.count;
}

- (JSMStaticSection *)createSection {
    JSMStaticSection *section = [JSMStaticSection section];
    [self addSection:section];
    return section;
}

- (JSMStaticSection *)createSectionAtIndex:(NSUInteger)index {
    JSMStaticSection *section = [JSMStaticSection section];
    [self insertSection:section atIndex:index];
    return section;
}

- (void)addSection:(JSMStaticSection *)section {
    if( [self containsSection:section] ) {
        return;
    }
    // Update the section's data source
    section.dataSource = self;
    // Add the section to the end
    [self.mutableSections addObject:section];
    // Notify the delegate
    if( self.delegate != nil && [self.delegate respondsToSelector:@selector(dataSource:sectionsDidChange:)] ) {
        self.mutableSections = [[self.delegate dataSource:self sectionsDidChange:self.mutableSections.copy] mutableCopy];
    }
}

- (void)insertSection:(JSMStaticSection *)section atIndex:(NSUInteger)index {
    if( [self indexForSection:section] == index ) {
        return;
    }
    // Update the section's data source
    section.dataSource = self;
    // No inserting outside the bounds, default to the appropriate end
    if( index >= self.mutableSections.count ) {
        [self.mutableSections addObject:section];
    }
    // Otherwise add at the specified index
    else {
        [self.mutableSections insertObject:section atIndex:index];
    }
    // Notify the delegate
    if( self.delegate != nil && [self.delegate respondsToSelector:@selector(dataSource:sectionsDidChange:)] ) {
        self.mutableSections = [[self.delegate dataSource:self sectionsDidChange:self.mutableSections.copy] mutableCopy];
    }
}

- (JSMStaticSection *)sectionWithKey:(NSString *)key {
    return [[self.mutableSections filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"key = %@",key]] firstObject];
}

- (JSMStaticSection *)sectionAtIndex:(NSUInteger)index {
    // We won't find anything outside the bounds
    if( index >= self.mutableSections.count ) {
        return nil;
    }
    // Fetch the object
    return (JSMStaticSection *)self.mutableSections[index];
}

- (NSUInteger)indexForSection:(JSMStaticSection *)section {
    return [self.mutableSections indexOfObject:section];
}

- (BOOL)containsSection:(JSMStaticSection *)section {
    return [self.mutableSections containsObject:section];
}

- (void)removeSectionAtIndex:(NSUInteger)index {
    if( ! [self sectionAtIndex:index] ) {
        return;
    }
    // Update the section's data source
    [self sectionAtIndex:index].dataSource = nil;
    // Remove the section
    [self.mutableSections removeObjectAtIndex:index];
    // Notify the delegate
    if( self.delegate != nil && [self.delegate respondsToSelector:@selector(dataSource:sectionsDidChange:)] ) {
        self.mutableSections = [[self.delegate dataSource:self sectionsDidChange:self.mutableSections.copy] mutableCopy];
    }
}

- (void)removeSection:(JSMStaticSection *)section {
    if( ! [self containsSection:section] ) {
        return;
    }
    // Update the section's data source
    section.dataSource = nil;
    // Remove the section
    [self.mutableSections removeObject:section];
    // Notify the delegate
    if( self.delegate != nil && [self.delegate respondsToSelector:@selector(dataSource:sectionsDidChange:)] ) {
        self.mutableSections = [[self.delegate dataSource:self sectionsDidChange:self.mutableSections.copy] mutableCopy];
    }
}

- (void)removeAllSections {
    if( self.mutableSections.count == 0 ) {
        return;
    }
    // Update the sections' datasource
    [self.mutableSections makeObjectsPerformSelector:@selector(setDataSource:) withObject:nil];
    // Remove the sections
    [self.mutableSections removeAllObjects];
    // Notify the delegate
    if( self.delegate != nil && [self.delegate respondsToSelector:@selector(dataSource:sectionsDidChange:)] ) {
        self.mutableSections = [[self.delegate dataSource:self sectionsDidChange:self.mutableSections.copy] mutableCopy];
    }
}

#pragma mark - Managing the Rows

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

- (JSMStaticRow *)rowWithKey:(NSString *)key {
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
    // Ensure we own the section first
    if( ! [self containsSection:section] ) {
        return;
    }
    // All we do is notify the delegate
    if( self.delegate != nil && [self.delegate respondsToSelector:@selector(dataSource:sectionNeedsReload:atIndex:)] ) {
        [self.delegate dataSource:self sectionNeedsReload:section atIndex:[self indexForSection:section]];
    }
}

- (void)requestReloadForRow:(JSMStaticRow *)row {
    // Ensure we own the row first
    NSIndexPath *indexPath = [self indexPathForRow:row];
    if( indexPath == nil ) {
        return;
    }
    // All we do is notify the delegate
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

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithStyle:(UITableViewCellStyle)style {
    id cell;
    // Get the cell style
    switch( style ) {
        case UITableViewCellStyleDefault: {
            static NSString *JSMStaticDataSourceDefaultReuseIdentifier = @"JSMStaticDataSourceDefaultReuseIdentifier";
            if( ( cell = [tableView dequeueReusableCellWithIdentifier:JSMStaticDataSourceDefaultReuseIdentifier] ) == nil ) {
                cell = [[self.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JSMStaticDataSourceDefaultReuseIdentifier];
            }
            break;
        }
        case UITableViewCellStyleValue1:
        default: {
            static NSString *JSMStaticDataSourceValue1ReuseIdentifier = @"JSMStaticDataSourceValue1ReuseIdentifier";
            if( ( cell = [tableView dequeueReusableCellWithIdentifier:JSMStaticDataSourceValue1ReuseIdentifier] ) == nil ) {
                cell = [[self.cellClass alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:JSMStaticDataSourceValue1ReuseIdentifier];
            }
            break;
        }
        case UITableViewCellStyleValue2: {
            static NSString *JSMStaticDataSourceValue2ReuseIdentifier = @"JSMStaticDataSourceValue2ReuseIdentifier";
            if( ( cell = [tableView dequeueReusableCellWithIdentifier:JSMStaticDataSourceValue2ReuseIdentifier] ) == nil ) {
                cell = [[self.cellClass alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:JSMStaticDataSourceValue2ReuseIdentifier];
            }
            break;
        }
        case UITableViewCellStyleSubtitle: {
            static NSString *JSMStaticDataSourceSubtitleReuseIdentifier = @"JSMStaticDataSourceSubtitleReuseIdentifier";
            if( ( cell = [tableView dequeueReusableCellWithIdentifier:JSMStaticDataSourceSubtitleReuseIdentifier] ) == nil ) {
                cell = [[self.cellClass alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:JSMStaticDataSourceSubtitleReuseIdentifier];
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
	UITableViewCell *cell = [self tableView:tableView dequeueReusableCellWithStyle:row.style];
	// Remove invalid subviews
	for(UIView *subview in cell.contentView.subviews) {
		if( [subview isEqual:cell.textLabel] ) continue;
		if( [subview isEqual:cell.detailTextLabel] ) continue;
		if( [subview isEqual:cell.imageView] ) continue;
		[subview removeFromSuperview];
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
