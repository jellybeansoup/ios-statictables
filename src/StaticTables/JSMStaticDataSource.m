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
#import "NSArray+StaticTables.h"

@interface JSMStaticDataSource ()

@property (nonatomic, strong) NSMutableArray <JSMStaticSection *> *mutableSections;

@property (nonatomic, copy, readonly) NSArray<JSMStaticChange *> *differences;

@property (nonatomic, readonly) NSUInteger changesBeingProcessed;

@property (nonatomic, readonly) BOOL informDelegate;

@property (nonatomic, readonly) BOOL informDataSource;

@end

@interface JSMStaticSection (JSMStaticDataSource)

- (void)setDataSource:dataSource;

- (void)setDirty:(BOOL)dirty;

@property (nonatomic, copy, readonly) NSArray<JSMStaticChange *> *differences;

@end

@interface JSMStaticRow (JSMStaticDataSource)

- (void)prepareCell:(UITableViewCell *)cell;

@end

@implementation JSMStaticDataSource

@synthesize mutableSections = _mutableSections;

- (instancetype)init {
    if( ( self = [super init] ) ) {
        _cellClass = [JSMStaticDataSource cellClass];
        _mutableSections = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
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

- (NSArray <JSMStaticSection *> *)sections {
    return self.mutableSections.copy;
}

- (void)setSections:(NSArray <JSMStaticSection *> *)sections {
    NSMutableArray *mutableSections = sections.mutableCopy;

    // If the sections are the same, bail out now.
    if( [_mutableSections isEqualToArray:mutableSections] ) {
        return;
    }

    NSArray *oldSections = self.sections;

    // Detach the sections that are being removed.
    for( JSMStaticSection *section in _mutableSections ) {
        if( section.dataSource != self ) continue;
        section.dataSource = nil;
    }

    // Attach the sections that are being inserted.
    for( JSMStaticSection *section in mutableSections ) {
        if( section.dataSource == self ) continue;
        else if( section.dataSource != nil ) {
            [section.dataSource removeSection:section];
        }
        section.dataSource = self;
    }

    // Update the sections
    _mutableSections = mutableSections;

    // Notify the delegate
    if( self.delegate != nil && [self.delegate respondsToSelector:@selector(dataSource:sectionsDidChange:)] ) {
        _mutableSections = [[self.delegate dataSource:self sectionsDidChange:_mutableSections.copy] mutableCopy];
    }
    [self jst_sectionsDidChange:oldSections];
    // We don't call KVO methods in the setter, as it appears to be done for us.
}

- (NSUInteger)numberOfSections {
    return self.sections.count;
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
    if( section == nil ) return;

    // Index for appending to the array, should account for being in the datasource already
    NSUInteger index = self.mutableSections.count;
    if( section.dataSource != nil && [self isEqual:section.dataSource] ) {
        index = index - 1;
    }

    [self insertSection:section atIndex:index];
}

- (void)insertSection:(JSMStaticSection *)section atIndex:(NSUInteger)index {
    if( section == nil ) return;

    // Keep the index inside the bounds
    NSUInteger maxIndex = self.mutableSections.count;
    if( section.dataSource != nil && [self isEqual:section.dataSource] ) {
        maxIndex = maxIndex - 1;
    }
    index = MIN( maxIndex, MAX( 0, index ) );

    // Section isn't moving anywhere
    if( section.dataSource != nil && [self isEqual:section.dataSource] && [self indexForSection:section] == index ) {
        return;
    }

    // Remove the row from it's current section
    if( section.dataSource != nil ) {
        [section.dataSource removeSection:section];
    }

    [self willChangeValueForKey:@"sections"];
    NSArray *oldSections = self.sections;

    // Insert the row
    section.dataSource = self;
    [self.mutableSections insertObject:section atIndex:index];

    // Notify the delegate
    if( self.delegate != nil && [self.delegate respondsToSelector:@selector(dataSource:sectionsDidChange:)] ) {
        self.mutableSections = [[self.delegate dataSource:self sectionsDidChange:self.mutableSections.copy] mutableCopy];
    }
    [self didChangeValueForKey:@"sections"];
    [self jst_sectionsDidChange:oldSections];
}

- (JSMStaticSection *)sectionWithKey:(NSString *)key {
    return [[self.sections filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"key = %@",key]] firstObject];
}

- (JSMStaticSection *)sectionAtIndex:(NSUInteger)index {
    // We won't find anything outside the bounds
    if( index >= self.sections.count ) {
        return nil;
    }
    // Fetch the object
    return (JSMStaticSection *)[self.sections objectAtIndex:index];
}

- (NSUInteger)indexForSection:(JSMStaticSection *)section {
    return [self.sections indexOfObject:section];
}

- (BOOL)containsSection:(JSMStaticSection *)section {
    return [self.sections containsObject:section];
}

- (void)removeSectionAtIndex:(NSUInteger)index {
    JSMStaticSection *section = [self sectionAtIndex:index];
    if( section == nil ) {
        return;
    }
    [self removeSection:section];
}

- (void)removeSection:(JSMStaticSection *)section {
    if( section == nil ) {
        return;
    }

    [self willChangeValueForKey:@"rows"];
    NSArray *oldSections = self.sections;

    // Remove the row
    section.dataSource = nil;
    [self.mutableSections removeObject:section];

    // Notify the delegate
    if( self.delegate != nil && [self.delegate respondsToSelector:@selector(dataSource:sectionsDidChange:)] ) {
        self.mutableSections = [[self.delegate dataSource:self sectionsDidChange:self.mutableSections.copy] mutableCopy];
    }
    [self didChangeValueForKey:@"rows"];
    [self jst_sectionsDidChange:oldSections];
}

- (void)removeAllSections {
    // No sections to remove
    if( self.mutableSections.count == 0 ) {
        return;
    }

    // Assign an empty array
    self.sections = [NSArray array];
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

- (__kindof JSMStaticRow *)rowWithKey:(NSString *)key {
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

- (__kindof JSMStaticRow *)rowAtIndexPath:(NSIndexPath *)indexPath {
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
    [self jst_sectionsDidChange:self.sections];
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
    // Apply the content from the row
    cell.textLabel.text = row.text;
    cell.detailTextLabel.text = row.detailText;
    cell.imageView.image = row.image;
    // Reset some basics
    cell.selectionStyle = row.selectionStyle;
    cell.accessoryType = row.accessoryType;
    cell.accessoryView = row.accessoryView;
    cell.editingAccessoryType = row.editingAccessoryType;
    cell.editingAccessoryView = row.editingAccessoryView;
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
    return [[self rowAtIndexPath:indexPath] canBeDeleted];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if( editingStyle == UITableViewCellEditingStyleDelete ) {
        // Remove the row
        JSMStaticRow *row = [self rowAtIndexPath:indexPath];
        JSMStaticSection *section = row.section;
        [self removeRow:row];
        // All we do now is notify the delegate
        if( self.delegate != nil && [self.delegate respondsToSelector:@selector(dataSource:didDeleteRow:fromIndexPath:)] ) {
            [self.delegate dataSource:self didDeleteRow:row fromIndexPath:indexPath];
        }
        else {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        // Tell the section
        if( section.delegate != nil && [section.delegate respondsToSelector:@selector(section:didDeleteRow:fromIndexPath:)] ) {
            [section.delegate section:section didDeleteRow:row fromIndexPath:indexPath];
        }
    }
}

#pragma mark - Responding to changes

- (BOOL)shouldPerformChanges {
    return YES;
    // Empty implementation, as method is designed to be overriden by subclasses.
}

- (void)didChangeSection:(JSMStaticSection *)row atIndex:(NSUInteger)index newIndex:(NSUInteger)newIndex {
    // Empty implementation, as method is designed to be overriden by subclasses.
}

- (void)didChangeRow:(__kindof JSMStaticRow *)row atIndexPath:(nonnull NSIndexPath *)indexPath newIndexPath:(nonnull NSIndexPath *)newIndexPath {
    // Empty implementation, as method is designed to be overriden by subclasses.
}

- (void)didPerformChanges {
    // Empty implementation, as method is designed to be overriden by subclasses.
}

- (void)jst_sectionsDidChange:(NSArray<__kindof JSMStaticSection *> *)old {
    NSArray<__kindof JSMStaticSection *> *new = self.sections.copy;

    // We're going to find all the differences
    _differences = [old jst_changesRequiredToMatchArray:new];

    // After all that, we don't have anything to change, apparently?
    if( _differences.count == 0 ) return;

    // Inform the people of the differences
    id<JSMStaticDataSourceDelegate> delegate = self.delegate;
    if( _changesBeingProcessed <= 0 ) {
        _informDelegate = [delegate respondsToSelector:@selector(dataSourceShouldPerformChanges:)] ? [delegate dataSourceShouldPerformChanges:self] : YES;
        _informDataSource = [self respondsToSelector:@selector(shouldPerformChanges)] ? [self shouldPerformChanges] : YES;
    }

    _changesBeingProcessed++;

    if( _informDelegate || _informDataSource ) {
        [_differences enumerateObjectsUsingBlock:^(JSMStaticChange * _Nonnull change, NSUInteger idx, BOOL * _Nonnull stop) {
            if( _informDelegate && [delegate respondsToSelector:@selector(dataSource:didChangeSection:atIndex:newIndex:)] ) {
                [delegate dataSource:self didChangeSection:change.object atIndex:change.fromIndex newIndex:change.toIndex];
            }
            if( _informDataSource && [delegate respondsToSelector:@selector(didChangeSection:atIndex:newIndex:)] ) {
                [self didChangeSection:change.object atIndex:change.fromIndex newIndex:change.toIndex];
            }
        }];
    }

    _changesBeingProcessed--;

    if( _changesBeingProcessed <= 0 ) {
        if( delegate != nil && [delegate respondsToSelector:@selector(dataSourceDidPerformChanges:)] ) {
            [delegate dataSourceDidPerformChanges:self];
        }
        if( [self respondsToSelector:@selector(didPerformChanges)] ) {
            [self didPerformChanges];
        }
    }
}

- (void)jst_rowsDidChangeInSection:(JSMStaticSection *)section {
    id<JSMStaticDataSourceDelegate> delegate = self.delegate;
    if( _changesBeingProcessed <= 0 ) {
        _informDelegate = [delegate respondsToSelector:@selector(dataSourceShouldPerformChanges:)] ? [delegate dataSourceShouldPerformChanges:self] : YES;
        _informDataSource = [self respondsToSelector:@selector(shouldPerformChanges)] ? [self shouldPerformChanges] : YES;
    }

    _changesBeingProcessed++;

    if( _informDelegate || _informDataSource ) {
        NSUInteger sectionIndex = [section.dataSource indexForSection:section];
        [section.differences enumerateObjectsUsingBlock:^(JSMStaticChange * _Nonnull change, NSUInteger idx, BOOL * _Nonnull stop) {
            NSIndexPath *fromIndexPath = [NSIndexPath indexPathForRow:change.fromIndex inSection:sectionIndex];
            NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:change.toIndex inSection:sectionIndex];
            if( _informDelegate && [delegate respondsToSelector:@selector(dataSource:didChangeRow:atIndexPath:newIndexPath:)] ) {
                [delegate dataSource:self didChangeRow:change.object atIndexPath:fromIndexPath newIndexPath:toIndexPath];
            }
            if( _informDataSource && [delegate respondsToSelector:@selector(didChangeRow:atIndexPath:newIndexPath:)] ) {
                [self didChangeRow:change.object atIndexPath:fromIndexPath newIndexPath:toIndexPath];
            }
        }];
    }

    _changesBeingProcessed--;

    if( _changesBeingProcessed <= 0 ) {
        if( delegate != nil && [delegate respondsToSelector:@selector(dataSourceDidPerformChanges:)] ) {
            [delegate dataSourceDidPerformChanges:self];
        }
        if( [self respondsToSelector:@selector(didPerformChanges)] ) {
            [self didPerformChanges];
        }
    }
}

@end
